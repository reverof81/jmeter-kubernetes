FROM alpine:3.12
LABEL maintainer="yjhan@meshkorea.net"

ENV JMETER_VERSION "5.3"

RUN apk update && \
    apk upgrade && \
    apk add --update openjdk8-jre wget tar bash iputils && \
    wget http://mirror.nbtelecom.com.br/apache//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz && \
    mkdir -p /opt/jmeter && \
    tar -zxf apache-jmeter-${JMETER_VERSION}.tgz -C /opt/jmeter/  --strip-components=1 && \
    rm -rf apache-jmeter-${JMETER_VERSION}.tgz && \
    rm -rf /var/cache/apk/* && \
    wget -O /usr/bin/tpl https://github.com/schneidexe/tpl/releases/download/v0.5.0/tpl-linux-amd64 && \
    chmod +x /usr/bin/tpl

ENV JMETER_HOME /opt/jmeter
ENV PATH $PATH:$JMETER_HOME/bin
