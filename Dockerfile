FROM sanji/mosquitto-dev:armhf

RUN [ "cross-build-start" ]

ADD . /data

WORKDIR /data

RUN cd `ls | grep mosquitto-*` && \
	debuild --no-lintian -us -uc

RUN [ "cross-build-end" ]
