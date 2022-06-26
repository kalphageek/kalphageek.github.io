---
layout: single
title: "Docker Image 검색"
categories: docker
tag: [image, docker, search]
toc: true
#author_profile : false
---



## CLI에서 Image 검색

> hub.docker.com 에 있는 Image를 검색한다

```sh
$ docker search nginx
NAME    STARS     OFFICIAL   ...
nginx   16971     [OK]
...
$ docker pull nginx:latest
```

## Web Portal에서 Image 검색

https://hub.docker.com/ > 검색 : registry > Docker Official Image 선택
