FROM stellar/base:latest

MAINTAINER Siddharth Suresh <siddharth@stellar.org>

EXPOSE 11625
EXPOSE 11626

VOLUME /data
VOLUME /postgresql-unix-sockets

ADD setup /
RUN /setup

ARG STELLAR_CORE_VERSION

#install stellar-core
RUN wget -qO - https://apt.stellar.org/SDF.asc | apt-key add -
RUN echo "deb https://apt.stellar.org/public unstable/" | tee -a /etc/apt/sources.list.d/SDF-unstable.list
RUN apt-get update
RUN apt-get install -y stellar-core=${STELLAR_CORE_VERSION}