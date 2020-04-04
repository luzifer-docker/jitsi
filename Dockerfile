FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive \
    GOSU_VERSION=1.11 \
    KORVIKE_VERSION=v0.6.1 \
    S6_VERSION=v1.21.8.0 \
    TERM=xterm

COPY build.sh /usr/local/bin/

RUN set -ex \
 && bash /usr/local/bin/build.sh

# Add config templates
COPY config/* /usr/local/share/jitsi-config/

# Add S6 start files
COPY setup.sh   /etc/cont-init.d/
COPY services   /etc/services.d

# Application expose
EXPOSE 80/tcp

VOLUME ["/ui"]

# Hopefully has some sense?
EXPOSE 10000/udp 10001/udp 10002/udp 10003/udp 10004/udp 10005/udp 10006/udp 10007/udp 10008/udp 10009/udp 10010/udp

ENTRYPOINT ["/init"]
