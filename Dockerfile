FROM google/debian:wheezy

# Java
RUN \
    echo "===> add webupd8 repository..."  && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    apt-get update  && \
    \
    \
    echo "===> install Java"  && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
    apt-get install -y --force-yes oracle-java7-installer oracle-java7-set-default  && \
    \
    \
    echo "===> clean up..."  && \
    apt-get clean

# Install ElasticSearch.
RUN \
  cd /tmp && \
  wget --no-check-certificate https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.6.tar.gz && \
  tar xvzf elasticsearch-0.20.6.tar.gz && \
  rm -f elasticsearch-0.20.6.tar.gz && \
  mv /tmp/elasticsearch-0.20.6 /elasticsearch

RUN /elasticsearch/bin/plugin -install mobz/elasticsearch-head && \
    /elasticsearch/bin/plugin -install elasticsearch/elasticsearch-analysis-icu/1.7.0

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
CMD ["/elasticsearch/bin/elasticsearch", "-f"]
