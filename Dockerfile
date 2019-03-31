FROM alpine:3.8

LABEL image.version="1.0.0" \
      image.description="Docker image based on Alpine Linux with transmission-daemon." \
      image.date="2018-03-14" \
      maintainer="Evgen Rusakov" \
      url.docker="https://hub.docker.com/r/rev9en/transmission" \
      url.source="https://github.com/revgen/docker-repository/docker-transmission"

COPY root/ /

RUN apk add --no-cache transmission-cli transmission-daemon && \
    (rm "/tmp/"* 2>/dev/null || true) && \
    (rm -rf /var/cache/apk/* 2>/dev/null || true) && \
    chmod +x /start-transmission.sh && \
    chmod +x /usr/bin/transmission-control

VOLUME ["/downloads", "/incomplete", "/watch", "/config"]

EXPOSE 9091 45555

CMD ["/start-transmission.sh"]
