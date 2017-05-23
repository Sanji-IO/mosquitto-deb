FROM sanji/mosquitto-dev:armhf

RUN [ "cross-build-start" ]

ADD . /data

WORKDIR /data/mosquitto-1.4.11

RUN debuild --no-lintian -us -uc

RUN [ "cross-build-end" ]
