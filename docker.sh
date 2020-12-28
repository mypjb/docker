#!/bin/bash

USER=root
PASSWORD=Aa123456
JENKINS_TAG="jenkinsci/blueocean:1.23.2"
MYSQL_TAG="mysql:8.0.21"
REDIS_TAG="redis:6.0.8"
MONGO_TAG="mongo:4.4.2"
NGINX_TAG="nginx:1.19.6"
DNS_TAG=" --cap-add=NET_ADMIN andyshinn/dnsmasq:2.81 "
BAGET_TAG="loicsharma/baget:latest"
BUILD_TAGS=(mypjb/dotnet-core-sdk:5.0 mypjb/dotnet-core-aspnet:5.0 andrewmackrodt/nodejs:12)
NETWORK="cluster"
DOCKER_VOLUME_PATH=/var/lib/docker/volumes
COMMON_ARGS=" run -d --restart=always --net=${NETWORK} "
SUBNET=172.18.0.0/16
GATEWAY=172.18.0.1
DNS_IP=172.18.0.254
docker network create -d bridge --subnet=${SUBNET} --gateway=${GATEWAY} $NETWORK

##mysql

docker volume create mysql-conf && docker volume create mysql-data
docker $COMMON_ARGS --name mysql -v mysql-conf:/etc/mysql -v mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=${PASSWORD} -p 3306:3306 $MYSQL_TAG
cp -r -f mysql/* ${DOCKER_VOLUME_PATH}/mysql-conf/_data/
docker restart mysql

##redis

docker volume create redis
docker $COMMON_ARGS --name redis -v redis:/usr/local/etc/redis -p 6379:6379 $REDIS_TAG redis-server /usr/local/etc/redis/redis.conf
cp -r -f redis/* ${DOCKER_VOLUME_PATH}/redis/_data/
docker restart redis

##mongo

docker volume create mongo-conf && docker volume create mongo-data
docker $COMMON_ARGS --name mongo -v mongo-conf:/etc/mongo -v mongo-data:/data/db -p 27017:27017 -p 8081:8081 -e MONGO_INITDB_ROOT_USERNAME=${USER} -e MONGO_INITDB_ROOT_PASSWORD=${PASSWORD} $MONGO_TAG --config /etc/mongo/mongod.conf
cp -r -f mongo/* ${DOCKER_VOLUME_PATH}/mongo-conf/_data/
docker restart mongo

##jenkins

docker volume create jenkins 
docker volume create nuget
docker volume create release
docker volume create yarn
docker $COMMON_ARGS --name=jenkins -u=${USER} -p 8080:8080 -p 50000:50000 -v jenkins:/var/jenkins_home -v release:/root/release  -v $(which docker):/bin/docker -v /var/run/docker.sock:/var/run/docker.sock -d ${JENKINS_TAG}

##nginx
docker volume create nginx

docker $COMMON_ARGS --name nginx -v nginx:/etc/nginx -p 80:80 -p 443:443 $NGINX_TAG
cp -r -f nginx/* ${DOCKER_VOLUME_PATH}/nginx/_data/
docker restart nginx

##nuget
docker volume create baget
docker $COMMON_ARGS --name nuget-server -p 8082:80 --env-file baget/baget.env -v baget:/var/baget $BAGET_TAG 

##dnsmasq

docker volume create dnsmasq
docker $COMMON_ARGS --name=dns --ip=${DNS_IP} -p 53:53/tcp -p 53:53/udp -v dnsmasq:/etc $DNS_TAG
#cp -f -r dnsmasq/* ${DOCKER_VOLUME_PATH}/dnsmasq/_data/
docker restart dns

##build

for TAG in ${BUILD_TAGS[@]};do
	docker pull $TAG
done
