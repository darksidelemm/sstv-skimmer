Skims SSTV off a ka9q-radio or spyserver instance using QSSTV and uploads to mastodon. This is a WIP and shouldn't be considered as stable.

> You may also need `--security-opt seccomp=unconfined` due to security restrictions on high resolution timers.

```sh
docker run \
-e HOST= \
-e PORT= \
-e FREQ=14230000 \
-e M_USERNAME="" \
-e M_PASSWORD='' \
-e M_URL="https://botsin.space" \
-e M_CLIENT_ID='' \
-e M_CLIENT_SECRET='' \
-e SOURCE=SpyServer \
-e MODE=USB \
--restart always \
--name sstv-20 \
-v /var/run/dbus:/var/run/dbus \
-v /var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket \
ghcr.io/xssfox/sstv-skimmer:latest
```



Environment variables
==
These need to be in order for the skimmer to work

| Name | Description                                                                                                  |
| ---- | ------------------------------------------------------------------------------------------------------------ |
| HOST | spy server hostname OR ka9q-radio PCM host (e.g. sstvlsb-pcm.local)                                          | 
| PORT | spy server port (unused for ka9q-radio)                                                                      |
| FREQ | frequency for USB/LSB in Hz                                                                                  |
| SOURCE | KA9Q, SpyServer, or RTLSDR                                                                                 |
| MODE | USB, LSB or FM                                                                                               |
| M_USERNAME | User name for mastodon instance                                                                        |
| M_PASSWORD | Password for mastodon instance                                                                         |
| M_URL |  Mastodon url eg : "https://botsin.space"                                                                   |
| M_CLIENT_ID | Client ID                                                                                             |
| M_CLIENT_SECRET | Client secret (see https://mastodonpy.readthedocs.io/en/stable/# for  details on creating an app) | 
