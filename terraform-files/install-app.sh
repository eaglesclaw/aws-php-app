#!/bin/bash
apt-get update
apt-get install php8.1-fpm -y
apt-get install php-mysqli -y
apt-get install nginx -y
chmod -R 777 /var/www/html

sudo mkdir /var/www/mydomain
#chown -R ubuntu:ubuntu /var/www/mydomain
wget -O /var/www/html/index.php https://raw.githubusercontent.com/eaglesclaw/aws-php-app/main/index.php
wget -O /etc/nginx/sites-available/default https://raw.githubusercontent.com/eaglesclaw/aws-php-app/main/default
systemctl start nginx
systemctl enable nginx
