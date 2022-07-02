---
layout: single
title: "cAdvisor Utility"
categories: utility
tag: [monitoring, utility, docker]
toc: true
#author_profile : false
---

> Linux 리소스 모니터링. Web Portal 제공. Host 뿐아니라, Docker Container의 모니터링 제공

> 검색 : cadvisor

```bash
$ VERSION=v0.36.0 # use the latest release version from https://github.com/google/cadvisor/releases
$ sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor:$VERSION
```

http://localhost:8080

