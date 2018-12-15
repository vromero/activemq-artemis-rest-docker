# ActiveMQ Artemis REST interface

##########################################################
## Build Image                                           #
##########################################################
FROM maven:3.6.0-jdk-8 as builder
LABEL maintainer="Victor Romero <victor.romero@gmail.com>"

ARG ACTIVEMQ_ARTEMIS_VERSION
ARG ACTIVEMQ_DISTRIBUTION_URL
ENV JMX_EXPORTER_VERSION=0.3.1

WORKDIR /root

# See https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /opt/jmx-exporter
RUN wget "https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar" && \
  wget "https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar.sha1" && \
  echo "$(cat "jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar.sha1")" "jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar" | sha1sum -c - && \
  rm "jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar.sha1" && \
  ln -s "/opt/jmx-exporter/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar" "/opt/jmx-exporter/jmx_prometheus_javaagent.jar"

WORKDIR /root/artemis-rest
COPY artemis-rest .
RUN mvn clean package

##########################################################
## Run Image                                             #
##########################################################
FROM jetty:9.4.12
LABEL maintainer="Victor Romero <victor.romero@gmail.com>"

ARG ACTIVEMQ_ARTEMIS_VERSION
ENV ACTIVEMQ_ARTEMIS_VERSION=$ACTIVEMQ_ARTEMIS_VERSION

USER root

RUN apt-get -qq -o=Dpkg::Use-Pty=0 update && \
  apt-get -qq -o=Dpkg::Use-Pty=0 install -y --no-install-recommends \
    xmlstarlet=1.6.1-2 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder "/opt/jmx-exporter/jmx_prometheus_javaagent.jar" "lib"
COPY --from=builder "/root/artemis-rest/target/activemq-rest-${ACTIVEMQ_ARTEMIS_VERSION}.war" "webapps"
COPY "assets/broker.xml" "${JETTY_BASE}/resources/broker.xml"
COPY "assets/docker-entrypoint-artemis-rest.sh" "/"

RUN chown jetty "${JETTY_BASE}/resources/broker.xml"

USER jetty

ENTRYPOINT [ "/docker-entrypoint-artemis-rest.sh" ]

# Web Server
EXPOSE 8080
