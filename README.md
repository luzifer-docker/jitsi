# Luzifer / jitsi

This container contains an [S6 overlay](https://github.com/just-containers/s6-overlay), a Prosody XMPP server, a nginx web-server and the [Jitsi components](https://jitsi.org/) to create a browser based video-chat from it.

The installation is based on the Jitsi/stable Debian installation with deactivated post-install scripts. To configure the container it needs to be started with the `JITSI_DOMAIN` environment variable which then is used to configure the container which internal certificates and configuration files.

After its start the container exposes port 80 to be proxied with a SSL / TLS terminating proxy.
