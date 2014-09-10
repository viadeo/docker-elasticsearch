FROM google/debian:wheezy

# Java
RUN apt-get update && \
  apt-get -y install wget openjdk-7-jre-headless && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Install ElasticSearch.
RUN \
  cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.6.tar.gz && \
  tar xvzf elasticsearch-0.20.6.tar.gz && \
  rm -f elasticsearch-0.20.6.tar.gz && \
  mv /tmp/elasticsearch-0.20.6 /elasticsearch && \
  /elasticsearch/bin/plugin -install mobz/elasticsearch-head && \
  /elasticsearch/bin/plugin -install elasticsearch/elasticsearch-analysis-icu/1.7.0

# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch.yml config
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Define working directory.
WORKDIR /data

# http
EXPOSE 9200

# transport
EXPOSE 9300

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch", "-f"]
