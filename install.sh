#!/bin/sh

useradd kcptun
#install supervisor

apt-get install -y python-setuptools
easy_install supervisor
echo_supervisord_conf > /etc/supervisord.conf
mkdir -p /etc/supervisor
mkdir -p /etc/supervisor/conf.d

#install shadowsocks

apt-get install -y python-pip
pip install --upgrade pip
pip install git+https://github.com/shadowsocks/shadowsocks.git@master

echo "[include]" >> /etc/supervisord.conf
echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisord.conf
cp shadowsocks.conf /etc/supervisor/conf.d/
cp kcptun.conf /etc/supervisor/conf.d/
cp php-server.conf /etc/supervisor/conf.d/

mkdir -p /var/log/kcptun
touch /var/log/kcptun/server.log
cp server-config.json /usr/local/kcptun/server-config.json

#install php 
apt-get install -y php
mkdir -p /root/code/php-server
cp index.php /root/code/php-server/

#kcptun
chmod +x server_linux_amd64
mkdir -p /usr/local/kcptun
mv server_linux_amd64 /usr/local/kcptun/

supervisord -c /etc/supervisord.conf
