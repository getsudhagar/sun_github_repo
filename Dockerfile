# dockerfile to build image for JBoss EAP 6.4

# start from rhel 7.2
FROM rhel

# file author / maintainer
MAINTAINER "Sudhagar Nagarajan" "getsudhagar@gmail.com"

# update CentOS repo to rhel
ADD centos.repo /etc/yum.repos.d/
RUN yum update -y && yum install -y java-1.8.0-openjdk \
yum install -y unzip
ADD jboss-eap-7.0.0.zip /tmp
RUN unzip /tmp/jboss-eap-7.0.0.zip -d /opt/
RUN rm -f /tmp/jboss-eap-7.0.0.zip

# enabling sudo group
# enabling sudo over ssh
#RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
#sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers
RUN sed -i -e 's/1303/256/g' /opt/jboss-eap-7.0/bin/standalone.conf

# add a user for the application, with sudo permissions
RUN useradd -m jboss ; echo jboss: | chpasswd ; usermod -a -G wheel jboss

# create workdir
#RUN mkdir -p /opt/rh

#WORKDIR /opt/rh

# install JBoss EAP 6.4.0
#ADD jboss-eap-6.4.0.zip /tmp/jboss-eap-6.4.0.zip
#RUN unzip /tmp/jboss-eap-6.4.0.zip

# set environment
ENV JBOSS_HOME /opt/jboss-eap-7.0


RUN sed -i -e 's/1303/256/g' $JBOSS_HOME/bin/standalone.conf
# create JBoss console user
RUN $JBOSS_HOME/bin/add-user.sh admin password --silent
# configure JBoss
RUN echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> $JBOSS_HOME/bin/standalone.conf

# set permission folder
RUN chown -R jboss:jboss /opt

# JBoss ports
EXPOSE 8080 9990 9999

# start JBoss
ENTRYPOINT $JBOSS_HOME/bin/standalone.sh -c standalone-full-ha.xml

# deploy app
ADD *.war "$JBOSS_HOME/standalone/deployments/"
#ADD *.jar "$JBOSS_HOME/standalone/deployments/"

ADD create-resources.sh "$JBOSS_HOME/
CMD ["$JBOSS_HOME/create-resources.sh"]

USER jboss
CMD /bin/bash
