# Luzifer / jitsi

This container contains an [S6 overlay](https://github.com/just-containers/s6-overlay), a Prosody XMPP server, a nginx web-server and the [Jitsi components](https://jitsi.org/) to create a browser based video-chat from it.

The installation is based on the Jitsi/stable Debian installation with deactivated post-install scripts. To configure the container it needs to be started with some requirements which then are used to configure the container which internal certificates and configuration files.

After its start the container listens on the specified address to be proxied with a SSL / TLS terminating proxy.

Start requirements:

- Provide a `JITSI_DOMAIN` ENV var which will be used to configure the container
- Provide a `JITSI_ADDR` to have the container listen on
- Start the container with `--net=host` in order to have the components work properly

## Setup

```console
# docker run -d -e JITSI_DOMAIN=jitsi.example.com -e JITSI_ADDR=127.0.0.1:1240 --net=host luzifer/jitsi
# cat /etc/nginx/conf.d/jitsi.conf
server {
  listen        443 ssl http2;
  listen        [::]:443 ssl http2;
  server_name   jitsi.example.com;

  ssl_certificate     /data/ssl/nginxle/example.com.pem;
  ssl_certificate_key /data/ssl/nginxle/example.com.key;

  location / {
    proxy_pass        http://127.0.0.1:1240;
    proxy_set_header  Upgrade $http_upgrade;
    proxy_set_header  Connection "Upgrade";
    proxy_set_header  Host $host;
    proxy_set_header  X-Real-IP $remote_addr;
    proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header  X-Forwarded-Proto $scheme;
  }
}
```

## Apply UI modifications

This container has a mechanism included to patch the installation inside the container on startup. There are two ways to modify those files: Patch them or overwrite them. Those modifications are needed to be mounted to the `/ui` mount-point of the container on startup.

This is my folder structure:

```
/ui
  +- files
      +- custom.head.html
      +- logo.png
  +- patches
      +- 01_index_html.patch
      +- 02_interface_config_js.patch
```

- The content of the `/ui/files` folder is copied over the `/usr/share/jitsi-meet` folder with `rsync` command so will replace the whole file being present there
- The patches in `/ui/patches` are executed inside the `/usr/share/jitsi-meet` folder using `patch` command so will modify the contents of the files
