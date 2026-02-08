FROM docker.io/library/alpine:3.12.3

LABEL org.opencontainers.image.title="Kafka shell tools" \
      org.opencontainers.image.authors="Andris Zbitkovskis <andris@z-b.lv>" \
      org.opencontainers.image.description="Basic kafka client utilities" \
      org.opencontainers.image.licenses="Apache License"

RUN apk add --clean-protected --no-cache --update \
            bash \
            curl \
            ca-certificates \
            iputils \
            jq \
            tmux \
            openjdk11-jdk \
            vim \ 
            wget && \
    rm -rf /var/cache/apk/* 
   
RUN  mkdir -p /var/lib/kafka/ && \
     mkdir -p /usr/local/ && \
     addgroup --system --gid 1221 kafka && \
     adduser -S -g kafka -u 1221 -D -G kafka -h /var/lib/kafka/ kafka

ARG KAFKA_RELEASE=3.9.1
ARG SCALA_VERSION=2.13
ARG KAFKA_DOWNLOAD_SOURCE=https://downloads.apache.org/kafka/

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk
ENV PATH /usr/local/kafka/bin/:$PATH

RUN  wget -q ${KAFKA_DOWNLOAD_SOURCE}/${KAFKA_RELEASE}/kafka_${SCALA_VERSION}-${KAFKA_RELEASE}.tgz -O /var/lib/kafka/kafka_${SCALA_VERSION}-${KAFKA_RELEASE}.tgz && \
     tar -xzf /var/lib/kafka/kafka_${SCALA_VERSION}-${KAFKA_RELEASE}.tgz -C /usr/local && \
     mv /usr/local/kafka_${SCALA_VERSION}-${KAFKA_RELEASE} /usr/local/kafka && \ 
     rm -fv  /var/lib/kafka/kafka_${SCALA_VERSION}-${KAFKA_RELEASE}.tgz

USER 1221
