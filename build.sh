#!/bin/bash

set -x
set -e
export MOSQ_SRC_URL=http://repo.mosquitto.org/debian/pool/main/m/mosquitto/mosquitto_1.4.11.orig.tar.gz
export MOSQ_DEBIAN_URL=http://repo.mosquitto.org/debian/pool/main/m/mosquitto/mosquitto_1.4.11-0mosquitto1.debian.tar.xz

rm -rf workspace
mkdir -p workspace
cd workspace
wget https://github.com/resin-io/qemu/releases/download/v2.5.50-resin-execve/qemu-execve.gz && gzip -d qemu-execve.gz
chmod +x qemu-execve
cp ../Dockerfile .
curl -O ${MOSQ_SRC_URL}
curl -O ${MOSQ_DEBIAN_URL}
export SRCNAME=`ls mosquitto_*orig*.gz`
export DEBIANNAME=`ls mosquitto_*.debian.tar.xz`
export FOLDER=${SRCNAME::-12}
tar zxvf ${SRCNAME}
tar xvf ${DEBIANNAME} -C `ls | grep mosquitto-*`

# Build armhf packages
docker run --entrypoint /usr/bin/qemu-arm-static -it \
    -v `pwd`/qemu-execve:/usr/bin/qemu-arm-static \
    -v `pwd`:/data \
    -w /data/`ls | grep mosquitto-*` \
    sanji/mosquitto-dev:armhf /bin/sh -c "debuild --no-lintian -us -uc"

# Build amd64 packages
docker run -it -v `pwd`:/data \
    -w /data/`ls | grep mosquitto-*` \
    sanji/mosquitto-dev:latest /bin/sh -c "debuild --no-lintian -us -uc"

