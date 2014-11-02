#!/bin/bash
ES_HOST=${ES_HOST:-\"+window.location.hostname+\"}
ES_PORT=${ES_PORT:-9200}
ES_SCHEME=${ES_SCHEME:-http}

sed -i "s#elasticsearch: \"http://\"+window.location.hostname+\":9200\",#elasticsearch: \"$ES_SCHEME://$ES_HOST:$ES_PORT\",#g" /usr/share/nginx/html/config.js
sed -i "s#root /var/www/html;#root /usr/share/nginx/html;#g" /etc/nginx/sites-available/default

nginx -c /etc/nginx/nginx.conf

