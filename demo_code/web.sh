#!/bin/bash

yum install httpd php php-mysql php-gd php-mbstring -y
yum install mysql -y
wget -O /tmp/wordpress-4.9.4-ja.tar.gz https://ja.wordpress.org/wordpress-4.9.4-ja.tar.gz
cd /tmp
tar zxf wordpress-4.9.4-ja.tar.gz
mv wordpress /var/www/html
chown -R apache:apache /var/www/html
systemctl enable httpd
systemctl start httpd
export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
echo "<html><body><h1>Hello from Production Backend at instance <b>"$INSTANCE_ID"</b></h1></body></html>" > /var/www/html/index.html