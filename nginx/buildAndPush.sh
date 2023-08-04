#!/usr/bin/env bash

NGINX_VERSION="1.25.1"
ALPINE_VERSION="3.18"
REG_USERNAME="阿里云账号@aliyun.com"
REG_URL="registry.cn-shenzhen.aliyuncs.com"
REG_PASSWD="你的阿里云仓库密码"
aliyunusername="阿里云仓库名"
hubusername="hub.docker.com 的账号"
Harborhost="本地 Harbor 192.168.2.5:9910"
HarborPasswd="Harbor12345"

docker ps -a
echo;

# 停止所有none镜像
docker stop `docker images | grep  "<none>" | awk '{print $3}'`

# 删除所有none镜像
docker rmi `docker images | grep  "<none>" | awk '{print $3}'`

##
#docker rmi registry.cn-shenzhen.aliyuncs.com/${hubusername}/nginx:1.25.1-alpine-3.18 nginx:1.25.1-alpine-3.18
docker rmi nginx:1.25.1-alpine3.18
docker rmi registry.cn-shenzhen.aliyuncs.com/${aliyunusername}/nginx:1.21.0-alpine
#
#echo;
docker build --rm -t nginx:${NGINX_VERSION}-alpine-${ALPINE_VERSION} .
docker build -t nginx:${NGINX_VERSION}-alpine-${ALPINE_VERSION} .

# Docker 上传到阿里云镜像仓库
docker login registry.cn-shenzhen.aliyuncs.com --username=${REG_USERNAME} --password=${REG_PASSWD}
docker tag nginx:${NGINX_VERSION}-alpine-${ALPINE_VERSION} ${REG_URL}/${aliyunusername}/nginx:${NGINX_VERSION}-alpine-${ALPINE_VERSION}
docker push ${REG_URL}/${aliyunusername}/nginx:${NGINX_VERSION}-alpine-${ALPINE_VERSION}

# Docker 上传到 镜像推送 Dockerhub 本地仓库
docker login --username=${hubusername} --password-stdin=${REG_PASSWD}
# 将密码写入到一个文件中，例如/etc/docker_passwd文件
#cat /etc/docker_passwd  | docker login --username=${hubusername} --password-stdin=${REG_PASSWD}

docker tag nginx:${NGINX_VERSION}-alpine-${ALPINE_VERSION} ${hubusername}/nginx:${NGINX_VERSION}-alpine-${ALPINE_VERSION}
docker push ${hubusername}/nginx:${NGINX_VERSION}-alpine-${ALPINE_VERSION}

# Docker 上传到 镜像推送 Harbor 本地仓库
docker login ${Harborhost} --username=admin --password=${HarborPasswd}
docker tag nginx:${NGINX_VERSION}-alpine-${ALPINE_VERSION} ${Harborhost}/library/nginx:${NGINX_VERSION}-alpine-${ALPINE_VERSION}
docker push ${Harborhost}/library/nginx:${NGINX_VERSION}-alpine-${ALPINE_VERSION} && echo "镜像推送成功" || echo "镜像推送失败"

# 删除所有none镜像
docker rmi `docker images | grep  "<none>" | awk '{print $3}'`

docker image ls
docker ps -a