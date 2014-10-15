FROM ubuntu:14.04
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

# From https://mesosphere.com/downloads/
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
RUN echo "deb http://repos.mesosphere.io/ubuntu trusty main" > /etc/apt/sources.list.d/mesosphere.list

RUN apt-get -yq update && apt-get -yq upgrade

RUN apt-get -yq install mesos

