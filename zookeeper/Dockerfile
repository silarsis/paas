FROM ubuntu:trusty
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
RUN apt-get -yq update && apt-get -yq upgrade
RUN apt-get -yq install zookeeper
EXPOSE 2888 3888 2181
ENTRYPOINT ["/usr/share/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"]
