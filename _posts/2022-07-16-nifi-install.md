---
layout: single
title: "Nifi 설치"
categories: nifi
tag: [nifi, install, docker]
toc: true
#author_profile : false
---





## Docker 설치

```bash
$ docker run --name nifi \
  -p 8443:8443 \
  -d \
  -e SINGLE_USER_CREDENTIALS_USERNAME=admin \
  -e SINGLE_USER_CREDENTIALS_PASSWORD=ctsBtRBKHRAx69EqUghvvgEvjnaLjFEB \
  apache/nifi:latest
```



## Nifi 접속

> https://localhost:8443/nifi

