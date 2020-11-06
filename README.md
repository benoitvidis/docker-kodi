# Kodi 

Kodi 18.9 Leia for X server with intel drivers.

You can run it using [x11docker](https://github.com/mviereck/x11docker) (preferred)
or if you don't mind about sharing memory with your host, by using the 
[provided docker-compose](https://github.com/benoitvidis/docker-kodi/blob/main/docker-compose.yml).

```
UID=$(id -u) GID=$(id -g) docker-compose run kodi
```
