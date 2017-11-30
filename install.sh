#!/bin/sh

#install supervisor

apt-get install -y python-setuptools
easy_install supervisor
echo_supervisord_conf > /etc/supervisord.conf
mkdir -p /etc/supervisor

#install shadowsocks

apt-get install -y python-pip
pip install --upgrade pip
pip install git+https://github.com/shadowsocks/shadowsocks.git@master

echo "[include]" >> /etc/supervisord.conf
echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisord.conf
cp shadowsocks.conf /etc/supervisor/conf.d/
cp kcptun.conf /etc/supervisor/conf.d/
cp server-config.json /usr/local/kcptun/server-config.json

mkdir -p /var/log/kcptun
touch /var/log/kcptun/server.log


#get kcptun

wget https://github.com/xtaci/kcptun/releases/download/v20171129/kcptun-linux-amd64-20171129.tar.gz
tar -xvf kcptun-linux-amd64-20171129.tar.gz
rm kcptun-linux-amd64-20171129.tar.gz
mkdir -p /usr/local/kcptun
mv server_linux_amd64 /usr/local/kcptun/server_linux_amd64

supervisord -c /etc/supervisord.conf
