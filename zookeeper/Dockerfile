# dockerfile to build image for JBoss EAP 6.4

# start from rhel 7.2
FROM rhel

# file author / maintainer
MAINTAINER "Sudhagar Nagarajan" "getsudhagar@gmail.com"

USER root

# update OS
ADD centos.repo /etc/yum.repos.d/
#ADD openjdk8.repo /etc/yum.repos.d/
RUN yum update -y && yum install -y java-1.8.0-openjdk \
#yum install -y unzip
#ADD jboss-eap-7.0.0.zip /tmp
#RUN unzip /tmp/jboss-eap-7.0.0.zip -d /opt/

ENV ZOOKEEPER_VERSION 3.4.6

EXPOSE 2181 2888 388

RUN yum -y install wget bind-utils && yum clean all
RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz > /opt/zookeeper-3.4.6.tar.gz
RUN tar -xvf /opt/zookeeper-3.4.6.tar.gz -C /opt
RUN mv /opt/zookeeper-3.4.6 /opt/zookeeper
RUN cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg
RUN mkdir -p /opt/zookeeper/{data,log}

WORKDIR /opt/zookeeper
VOLUME ["/opt/zookeeper/conf", "/opt/zookeeper/data", "/opt/zookeeper/log"]

COPY config-and-run.sh ./bin/
COPY zoo.cfg ./conf/
RUN chmod 777 /opt/zookeeper/bin/config-and-run.sh
CMD ["/opt/zookeeper/bin/config-and-run.sh"]
