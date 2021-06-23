# docker-winevnc
Docker image to provide a simple vnc server with Wine. This image has also a menu entry for Winbox (Mikrotik)

## Create Dockerfiles
In order to create Dockerfiles you need jinja templating engine (Python). You can install it running the commands below:

```
pip install jinja2 jinja2-cli
```

## Expose winbox
If you want to run winbox you need to mount a volume with `winbox64.exe` executable.

```
docker run -v <your-dir>:/volume
```

## Run example

```
docker run -d --restart always -p 127.0.0.1:5900:5900 -v /opt/winevnc:/volume glutec/winevnc:latest
```
