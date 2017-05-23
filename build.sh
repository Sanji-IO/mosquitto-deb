#!/bin/bash

set -x
set -e
export MOSQ_SRC_URL=http://repo.mosquitto.org/debian/pool/main/m/mosquitto/mosquitto_1.4.11.orig.tar.gz
export MOSQ_DEBIAN_URL=http://repo.mosquitto.org/debian/pool/main/m/mosquitto/mosquitto_1.4.11-0mosquitto1.debian.tar.xz

rm -rf workspace
mkdir -p workspace
cd workspace
curl -O ${MOSQ_SRC_URL}
curl -O ${MOSQ_DEBIAN_URL}
export SRCNAME=`ls mosquitto_*orig*.gz`
export DEBIANNAME=`ls mosquitto_*.debian.tar.xz`
export FOLDER=${SRCNAME::-12}
tar zxvf ${SRCNAME}
tar xvf ${DEBIANNAME} -C `ls | grep mosquitto-*`

# Build x86 and arm packages
docker run -it -v `pwd`:/data -w /data/`ls | grep mosquitto-*` sanji/mosquitto-dev:latest debuild --no-lintian -us -uc
docker run -it -v `pwd`:/data -w /data/`ls | grep mosquitto-*` sanji/mosquitto-dev:armhf debuild --no-lintian -us -uc
