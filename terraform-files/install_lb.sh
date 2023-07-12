#!/bin/bash
apt-get update
apt-get install -y nginx
wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/eaglesclaw/aws-php-app/main/nginx.conf
systemctl start nginx
systemctl enable nginx
