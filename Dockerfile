FROM sanji/mosquitto-dev:armhf

RUN [ "cross-build-start" ]

ADD . /data

WORKDIR /data

RUN cd mosquitto-1.4.11 && \
	debuild --no-lintian -us -uc

RUN [ "cross-build-end" ]
