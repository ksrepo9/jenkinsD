FROM ubuntu
LABEL maintainer="kartikeyait@gmail.com"
ARG USERNAME=tomuser
ARG UID=2000
ARG GID=2000
RUN groupadd -g $GID -o $USERNAME
RUN useradd -u $UID -g $GID -o -s /bin/bash $USERNAME
ARG WAR_PACK=http://192.168.29.7:8081/repository/maven-snapshots/com/ksapp/ks/7-SNAPSHOT/ks-7-20240426.142946-1.war
ARG TOM_URL=https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz
ARG TOM_TAR=apache-tomcat-9.0.96.tar.gz
ARG TOM_SRC=apache-tomcat-9.0.96
ARG TOM_HOME=/tomcat
ARG PACK=/tomcat/webapps/ks.war
ENV TOM_START=/tomcat/bin/catalina.sh


RUN set -eux; \
  apt update; \
  apt-get install openjdk-11-jdk wget -y; \
  cd /opt/ && wget $TOM_URL && tar -xvf $TOM_TAR && cd $TOM_SRC/webapps && rm -rf *; \
  mv /opt/$TOM_SRC /tomcat;

ADD $WAR_PACK $PACK
RUN chown $USERNAME:$USERNAME $TOM_HOME -R

EXPOSE 8080
USER $USERNAME
ENTRYPOINT ["sh", "-c","$TOM_START run"]