#!/bin/bash

USER=root
PASSWORD=Aa123456
JENKINS_TAG=1.23.2
#docker volume create dns
#docker run --name=dnsmasq --restart=always -p 53:53/tcp -p 53:53/udp -v dns:/etc --cap-add=NET_ADMIN -d andyshinn/dnsmasq
#mysql

#docker volume create mysql-conf && docker volume create mysql-data
#docker run -d --name mysql --restart=always -v mysql-conf:/etc/mysql -v mysql-data:/var/lib/mysql -v /etc/resolv.conf:/etc/resolv.conf -e MYSQL_ROOT_PASSWORD=${USER} -p 3306:3306 mysql


#redis

#docker volume create redis
#echo -e 'bind 0.0.0.0\nloglevel verbose\ndatabases 16\nrequirepass ${PASSWORD}\nmaxmemory 256mb' > /var/lib/docker/volumes/redis/_data/redis.conf 
#docker run -d --name redis --restart=always -v redis:/usr/local/etc/redis -v /etc/resolv.conf:/etc/resolv.conf  -p 6379:6379 redis redis-server /usr/local/etc/redis/redis.conf

#mongo

#docker volume create mongo-conf && docker volume create mongo-data
#echo -e 'dbpath=/data/db\nauth=true\nbind_ip=0.0.0.0\n' >  /var/lib/docker/volumes/mongo-conf/_data/mongod.conf 
#docker run -d --name mongo --restart=always -v mongo-conf:/etc/mongo -v mongo-data:/data/db -v /etc/resolv.conf:/etc/resolv.conf -p 27017:27017 -p 8081:8081 -e MONGO_INITDB_ROOT_USERNAME=${USER} -e MONGO_INITDB_ROOT_PASSWORD=${PASSWORD} mongo --config /etc/mongo/mongod.conf


#docker volume create jenkins 
#docker volume create nuget
#docker volume create release
#docker volume create yarn
#docker run --restart=always --name=jenkins -u=${USER} -p 8080:8080 -p 50000:50000 -v jenkins:/var/jenkins_home -v release:/root/release  -v $(which docker):/bin/docker -v /var/run/docker.sock:/var/run/docker.sock -d jenkinsci/blueocean:${JENKINS_TAG}
