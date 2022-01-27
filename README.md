# Kodi 

Kodi 19 Matrix for X server with intel drivers.

You can run it using [x11docker](https://github.com/mviereck/x11docker) (preferred)
or if you don't mind about sharing memory with your host, by using the 
[provided docker-compose](https://github.com/benoitvidis/docker-kodi/blob/main/docker-compose.yml).

```
docker-compose run kodi
```

example of `docker-compose.override.yml` using pulseaudio

```yaml
version: "3"

services:
  kodi:
    volumes:
      - ./data:/home/kodi/.kodi
      - /run/user/${UID:-1000}/pulse:/tmp/pulse    
```
