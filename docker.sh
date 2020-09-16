#!/bin/bash

USER=root
PASSWORD=Aa123456
JENKINS_TAG="jenkinsci/blueocean:1.23.2"
MYSQL_TAG="mysql:8.0.21"
REDIS_TAG="redis:6.0.8"
MONGO_TAG="mongo:6.0.8"
NGINX_TAG="nginx:1.19.2"
NETWORK="cluster"
COMMON_ARGS=" --restart=always --net=${NETWORK}"
#docker network create -d bridge $NETWORK

#mysql

#docker volume create mysql-conf && docker volume create mysql-data
#docker run -d --name mysql $COMMON_ARGS -v mysql-conf:/etc/mysql -v mysql-data:/var/lib/mysql -v /etc/resolv.conf:/etc/resolv.conf -e MYSQL_ROOT_PASSWORD=${USER} -p 3306:3306 $MYSQL_TAG


#redis

#docker volume create redis
#echo -e 'bind 0.0.0.0\nloglevel verbose\ndatabases 16\nrequirepass ${PASSWORD}\nmaxmemory 256mb' > /var/lib/docker/volumes/redis/_data/redis.conf 
#docker run -d --name redis $COMMON_ARGS -v redis:/usr/local/etc/redis -v /etc/resolv.conf:/etc/resolv.conf  -p 6379:6379 $REDIS_TAG redis-server /usr/local/etc/redis/redis.conf

#mongo

#docker volume create mongo-conf && docker volume create mongo-data
#echo -e 'dbpath=/data/db\nauth=true\nbind_ip=0.0.0.0\n' >  /var/lib/docker/volumes/mongo-conf/_data/mongod.conf 
#docker run -d --name mongo $COMMON_ARGS -v mongo-conf:/etc/mongo -v mongo-data:/data/db -v /etc/resolv.conf:/etc/resolv.conf -p 27017:27017 -p 8081:8081 -e MONGO_INITDB_ROOT_USERNAME=${USER} -e MONGO_INITDB_ROOT_PASSWORD=${PASSWORD} $MONGO_TAG --config /etc/mongo/mongod.conf


#docker volume create jenkins 
#docker volume create nuget
#docker volume create release
#docker volume create yarn
#docker run $COMMON_ARGS --name=jenkins -u=${USER} -p 8080:8080 -p 50000:50000 -v jenkins:/var/jenkins_home -v release:/root/release  -v $(which docker):/bin/docker -v /var/run/docker.sock:/var/run/docker.sock -d ${JENKINS_TAG}

#docker volume create nginx

#docker run --name nginx -d -v nginx:/etc/nginx $COMMON_ARGS -p 80:80 -p 443:443 $NGINX_TAG

