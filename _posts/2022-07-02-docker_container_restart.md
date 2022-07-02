---
layout: single
title: "Docker Container 재시작 옵션"
categories: docker
tag: [restart, docker, container]
toc: true
#author_profile : false
---



## 자동재시작 명령어

```bash
$ docker run -it --restart unless-stopped --net=bridge --name docker-nginx nginx:latest /bin/bash
# Option
--restart [Parameter] : 컨테이너 내부의 프로세스 종료시 재시작 정책을 설정할 수 있습니다.
# Parameter
no : 프로세스가 종료되더라도 컨테이너를 재시작하시 않습니다.
on-failure : 프로레스 exit code 가 0 이 아닐 때 재시작합니다. 지정하지 않으면 계속해서 컨테이너를 재시작 합니다.
always : 프로세스의 exit code 와는 관계없이 재시작 합니다
unless-stopped : 부팅시 자동으로 컨테이너를 재시작 합니다.
```