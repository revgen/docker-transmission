# [docker-transmission][github-repo]

[![Build Docker Image](https://github.com/revgen/docker/actions/workflows/docker-transmission.yml/badge.svg)](https://github.com/revgen/docker/actions/workflows/docker-transmission.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Docker image based on [Alpine Linux][alpine-site] with [transmission-daemon][transmission-site].

Original idea taken from [linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission/) and [ezbiranik/docker-alpine-transmission](https://github.com/ezbiranik/docker-alpine-transmission).

The image is currently available on [hub.docker.com][transmission-hub].


## Usage

### With a helper bash script

Download [transmission helper bash script][transmission-helper-script] and install it into your PATH directory.
```bash
wget -O ~/bin/transmission https://raw.githubusercontent.com/revgen/docker-transmission/master/scripts/transmission
chmod +x ~/bin/transmission
```

Create local docker container from the image
```bash
transmission create
```


Start/Stop container
```bash
transmission start
transmission stop
```

Other commands
```bash
transmission help
```


### Docker command line interface

```bash
docker create --name=transmission \
-v <path to data>:/config \
-v <path to downloads>:/downloads \
-v <path to incomplete>:/incomplete \
-v <path to watch folder>:/watch \
-e PGID=<gid> -e PUID=<uid> \
-e TZ=<timezone> \
-e PASSWORD=${PASSWORD} \
-e USERNAME=${USERNAME} \
-p 9091:9091 -p 51413:51413 -p 51413:51413/udp \
rev9en/transmission
```

#### Reverse Proxy settings (nginx)

The Transmission was raised on the same host and web UI is using a default port 9091.

```bash
sudo vim /etc/nginx/site-available/default
```
```nginx
rewrite ^/transmission$ /transmission/web/ permanent;
rewrite ^/transmission/$ /transmission/web/ permanent;
rewrite ^/transmission/web$ /transmission/web/ permanent;
location /transmission/web/ {
    proxy_pass         http://localhost:9091;
    proxy_buffering    off;
    proxy_set_header   Host               $host;
    proxy_set_header   X-Real-IP          $remote_addr;
    proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
    proxy_set_header   X-Forwarded-Host   $host;
    proxy_pass_header  X-Transmission-Session-Id;
    access_log         /var/log/nginx/site-transmission-web.log;
    error_log          /var/log/nginx/site-transmission-web-error.log;
}

location /transmission/rpc {
    proxy_pass         http://localhost:9091;
    access_log         /var/log/nginx/site-transmission-rpc.log;
    error_log          /var/log/nginx/site-transmission-rpc-error.log;
}
                       
location /transmission/upload {
    proxy_pass         http://localhost:9091;
    access_log         /var/log/nginx/site-transmission-update.log;
    error_log          /var/log/nginx/site-transmission-update-error.log;
}
```
```bash
sudo service nginx restart 
```

After that you have an ability to open transmission web ui on the http://servername/transmission.

Transmission output logs can be found here: https://servername/transmission/web/log.html.

## Development

### Build transmission docker image
```bash
cd docker-transmission
docker build -t rev9en/transmission ./
docker tag rev9en/transmission:latest rev9en/transmission:<new version>
```

### Publish new docker image to the docker hub
```bash
docker login
docker push rev9en/transmission:<new version>
docker push rev9en/transmission:latest
```


[transmission-helper-script]: https://raw.githubusercontent.com/revgen/docker-transmission/master/scripts/transmission
[transmission-site]: https://transmissionbt.com/
[alpine-site]: https://hub.docker.com/_/alpine/
[transmission-hub]: https://hub.docker.com/r/rev9en/transmission/
[github-repo]: https://github.com/revgen/docker/docker-minidlna/
