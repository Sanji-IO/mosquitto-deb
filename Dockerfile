FROM sanji/mosquitto-dev:armhf

ADD . /data

WORKDIR /data/mosquitto-1.4.11

RUN debuild --no-lintian -us -uc
