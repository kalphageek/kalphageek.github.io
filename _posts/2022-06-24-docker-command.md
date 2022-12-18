---
layout: single
title: "동작중인 Container에 사용할 수 있는 명령어"
categories: docker
tag: [run, container, docker, inspect, attach, extc, rm, restart, registry, ps, top, logs, log]
toc: true
toc_sticky: true
#author_profile : false
---



## Docker Run

* Docker 종료되면 Container 자동 삭제

```bash
$ docker run --rm -p 8080/8080 demo
```

* Docker가 시작되면 Container 항상 재실행

```bash
$ docker run -d -p 5000:5000 --restart always --name registry registry:2
```



## Container

* 동작중인 Container 목록 확인

```bash
$ docker ps [-a]
```

* Container 시작/종료/삭제

```bash
$ docker start centos
$ docker stop centos
# Container 삭제
$ docker container rm centos
# Container 강제 삭제
$ docker rm -f centos
```

* Foreground로 실행중인 Container에 연결

```bash
$ docker attach [옵션] centos
```

* 동작중인 Container에 추가명령 실행

```bash
$ docker exec -it centos /bin/bash
```

* 동작중인 Container 내부 프로세스 보기

```bash
$ docker top [옵션] centosalways
```

* 동작중인 Container 로그 보기

```bash
$ docker logs [-f] centos
```

* 동작중인 Container 리소스 모니터링

```bash
$ docker stats
$ docker stats centosalways
```



## Docker 상세 정보

* Network/Image/Container/Volume 상세정보 보기

```bash
$ docker inspect [network명/image명/container명/volume명]
```

