FROM vroong/jmeter-base:5.3
LABEL maintainer="yjhan@meshkorea.net"

EXPOSE 60000
ENV SSL_DISABLED true
ENV ONE_SHOT true
ENV SLAVE_SVC_NAME jmeter-slave
ENV TESTS_DIR /test

ADD run-test.sh /run-test.sh
RUN chmod +x /run-test.sh && mkdir /test

ENTRYPOINT /run-test.sh
