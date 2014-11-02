docker-kibana
=============


# Links

- [Monitoring Nuxeo Docker Container Logs with Logstash, Elasticsearch and Kibana](http://www.nuxeo.com/blog/monitoring-nuxeo-docker-container-logs-logstash-elasticsearch-kibana/)
- [elasticsearch - kibana](https://github.com/elasticsearch/kibana)
- [Docker image - kibana](https://github.com/arcus-io/docker-kibana)

# elasticsearch

- configure [embedded elasticsearch](https://github.com/nuxeo/marketplace-elasticsearch/tree/5.8) in Nuxeo Platform
- open browser `http://localhost:9200/`

# docker kibana

## Dockerfile

        FROM debian:jessie
        RUN apt-get update
        ENV DEBIAN_FRONTEND noninteractive
        RUN apt-get install -y nginx-full wget
        RUN wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz -O /tmp/kibana.tar.gz && \
            tar zxf /tmp/kibana.tar.gz && mv kibana-3.1.0/* /usr/share/nginx/html/
        RUN echo "daemon off;" >> /etc/nginx/nginx.conf
        ADD run.sh /usr/local/bin/run
        EXPOSE 80
        CMD ["/usr/local/bin/run"]

## run.sh

        #!/bin/bash
        ES_HOST=${ES_HOST:-\"+window.location.hostname+\"}
        ES_PORT=${ES_PORT:-9200}
        ES_SCHEME=${ES_SCHEME:-http}

        sed -i "s#elasticsearch: \"http://\"+window.location.hostname+\":9200\",#elasticsearch: \"$ES_SCHEME://$ES_HOST:$ES_PORT\",#g" /usr/share/nginx/html/config.js
        sed -i "s#root /var/www/html;#root /usr/share/nginx/html;#g" /etc/nginx/sites-available/default

        nginx -c /etc/nginx/nginx.conf

## build & launch

- build:

        git clone git@github.com:vdutat/docker-kibana.git
        docker build -t kibana .

- run:

        docker run -d -P -h kibana --name nuxeo-kibana -e ES_HOST=10.0.0.5 kibana
        docker ps

- extract port which is redirected to port 80

- open browser `http://10.0.0.5:<docker_image_port>/`

- restart:

        docker stop nuxeo-kibana
        docker start nuxeo-kibana

- stop docker:

        docker stop nuxeo-kibana
        
- re-build:

        docker rm kibana
        docker build -t kibana .
