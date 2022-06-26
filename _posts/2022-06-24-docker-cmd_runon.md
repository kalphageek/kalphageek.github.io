---
layout: single
title: "동작중인 Container에 사용할 수 있는 명령어"
categories: docker
tag: [runon, container, docker]
toc: true
#author_profile : false
---



## 동작중인 Container 목록 확인

```bash
$ docker ps [-a]
```



## Container 시작/종료/삭제

```bash
$ docker start centos
$ docker stop centos
$ docker container rm centos
```



## Foreground로 실행중인 Catainer에 연결

```bash
$ docker attach [옵션] centos
```



## 동작중인 Container에 추가명령 실행

```bash
$ docker exec -it centos /bin/bash
```



## 동작중인 Container 내부 프로세스 보기

```bash
$ docker top [옵션] centos
```



## 동작중인 Container 로그 보기

```bash
$ docker logs [-f] centos
```



## 동작중인 Container 리소스 모니터링

```bash
$ docker stats
$ docker stats centos
```

