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
export SRCFOLDER=`ls | grep mosquitto-*`
tar xvf ${DEBIANNAME} -C "$SRCFOLDER"
patch $SRCFOLDER/debian/rules < ../patches/rule.patch

if [ "$ARCH" = "amd64" ]; then
    docker run -it -v `pwd`:/data \
        -w /data/$SRCFOLDER \
        sanji/mosquitto-dev:latest /bin/sh -c "debuild --no-lintian -us -uc"
elif [ "$ARCH" = "armhf" ]; then
    docker run --entrypoint /usr/bin/qemu-arm-static -it \
        -v `pwd`:/data \
        -w /data/$SRCFOLDER \
        sanji/mosquitto-dev:armhf /bin/sh -c "debuild --no-lintian -us -uc"
fi
