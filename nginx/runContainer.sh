#!/usr/bin/env bash
#!/usr/bin/env bash

NGINX_VERSION="1.25.1"
ALPINE_VERSION="3.18"

docker stop nginx > /dev/null
docker rm nginx > /dev/null

docker pull websfx/nginx:1.25.1-alpine-3.18
docker run -d -p 80:80 -p 443:443 --name nginx websfx/nginx:${NGINX_VERSION}-alpine${ALPINE_VERSION}

#docker logs -f nginx
docker ps -a |grep nginx

docker rm `docker ps -aq|grep Exited|awk '{print $1}'`

docker stop $(docker ps -aq)