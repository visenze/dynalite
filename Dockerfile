FROM ubuntu:16.04
MAINTAINER Florin Patan

EXPOSE 80

ENV DYNALITE_VERSION=1.1.1

RUN apt-get update && apt-get install -y g++ \
        make \
        python \
        software-properties-common \
        wget
RUN wget -qO- https://deb.nodesource.com/setup_7.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs
RUN wget -O dynalite.tar.gz https://github.com/mhart/dynalite/archive/v${DYNALITE_VERSION}.tar.gz && \
    tar -xf dynalite.tar.gz -C /tmp/ && \
    rm -f /tmp/dynalite.tar.gz
#COPY dynalite.tar.gz . 
#RUN  tar -xf dynalite.tar.gz -C /tmp/ && rm -f dynalite.tar.gz
WORKDIR /tmp/dynalite
RUN npm install -g dynalite && \
    apt-get purge -y g++ \
        make \
        software-properties-common \
        wget && \
    apt-get -y autoremove && \
    apt-get clean && rm -rf /build && rm -rf /var/tmp/* && rm -rf /var/lib/apt/lists/*
RUN mkdir data
COPY db/index.js /usr/lib/node_modules/dynalite/db/index.js

CMD ["dynalite","--createTableMs=100","--deleteTableMs=100","--updateTableMs=100","--path=data","--port=80"]