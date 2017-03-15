FROM google/debian:jessie

# Java
RUN apt-get update && \
  apt-get -y install wget openjdk-7-jre-headless && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Install ElasticSearch.
RUN \
  cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.tar.gz && \
  tar xvzf elasticsearch-1.1.1.tar.gz && \
  rm -f elasticsearch-1.1.1.tar.gz && \
  mv /tmp/elasticsearch-1.1.1 /elasticsearch

RUN /elasticsearch/bin/plugin -install mobz/elasticsearch-head && \
    /elasticsearch/bin/plugin -install elasticsearch/elasticsearch-analysis-icu/2.1.0

# Locale
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

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
CMD ["/elasticsearch/bin/elasticsearch"]
