#!/bin/sh

set -e

apt-get update
chown -R vagrant:vagrant /usr/local

apt-get -y install wget curl git-core build-essential ruby1.9.1 redis-server python-pip fontconfig

# used with bottle to serve the webapp
pip install paste barrister

cd /usr/local

if [ ! -f /usr/local/node-v0.10.17 ]; then
	curl -o node-v0.10.17.tar.gz http://nodejs.org/dist/v0.10.17/node-v0.10.17.tar.gz
	tar -zxf node-v0.10.17.tar.gz
    cd node-v0.10.17
    make install
fi

npm install -g coffee-script uglify-js docco

# phantomjs
if [ ! -f /usr/local/phantomjs/bin/phantomjs ]; then
    mkdir -p /usr/local/src
    curl -o /usr/local/src/phantomjs-1.5.0.tgz http://phantomjs.googlecode.com/files/phantomjs-1.5.0-linux-x86-dynamic.tar.gz
    cd /usr/local
    tar --no-same-owner -zxf /usr/local/src/phantomjs-1.5.0.tgz
    ln -s /usr/local/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
fi
