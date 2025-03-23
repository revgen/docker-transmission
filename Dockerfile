FROM alpine:3.8

ARG NAME="rev9en/transmission"
ARG VERSION="1.0.3"

LABEL version="${VERSION}"
LABEL name="${NAME}"
LABEL description="Docker image with transmission-daemon"
LABEL date="2018-03-14"
LABEL maintainer="Evgen Rusakov"
LABEL url.docker="https://hub.docker.com/r/rev9en/transmission"
LABEL url.source="https://github.com/revgen/docker/docker-transmission"

COPY root-fs/ /

RUN apk add --no-cache transmission-cli transmission-daemon && \
    chmod +x /entrypoint.sh && \
    chmod +x /usr/bin/transmission-control

VOLUME ["/downloads", "/watch", "/config"]

EXPOSE 9091 45555

CMD ["/entrypoint.sh"]
