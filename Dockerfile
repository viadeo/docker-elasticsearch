FROM google/debian:wheezy

# Java
RUN apt-get update && \
  apt-get -y install wget openjdk-7-jre-headless

# Elasticsearch
RUN wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.6.deb -O /tmp/elasticsearch-0.20.6.deb && \
 dpkg -i /tmp/elasticsearch-0.20.6.deb && \
 sed -i 's/MAX_OPEN_FILES=/# MAX_OPEN_FILES=/g' /etc/init.d/elasticsearch && \
 /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head && \
 sed -i 's/# discovery.zen.ping.multicast.enabled:.*/discovery.zen.ping.multicast.enabled: false/g' /etc/elasticsearch/elasticsearch.yml && \
 /usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-analysis-icu/1.7.0

EXPOSE 9200
EXPOSE 9300

CMD ["/usr/share/elasticsearch/bin/elasticsearch"]
