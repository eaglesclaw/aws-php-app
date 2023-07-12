#!/bin/bash

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

systemctl start docker
systemctl enable docker

docker run -d --name mysql_container -e MYSQL_ROOT_PASSWORD="myStrongPassword123" -p 3306:3306 mysql:8.0

docker ps -a
