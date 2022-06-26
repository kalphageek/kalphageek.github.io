---
layout: single
title: "Stress Utility"
categories: utility
tag: [stress, test, utility, docker]
toc: true
#author_profile : false
---

> 부하 테스트 프로그램



## 설치 (Docker)

```bash
# 2개의 cpu를 core를 100% 사용하도록 부하 발생
$ stress --cpu 2
# 프로세스 2개와 5초동안 사용할 만큼 메모리 부하 발생
$ stress --vm --vm-bytes 90m -t 5s
```

* Dockerfile

```do
FROM debian
MAINTAINER KAlphageek
RUN apt-get update; apt-get install stress -y
CMD ["/bin/sh", "-c", "stress -c 2"]
```



## Memory 부하 테스트

```bash
# Swap 사용 안함. 정상 종료
$ docker run -m 100m --memory-swap 100m stress:latest stress --vm 1 --vm-bytes 90m -t 5s

# Swap 사용 안함. FAIL
$ docker run -m 100m --memory-swap 100m stress:latest stress --vm 1 --vm-bytes 150m -t 5s

# Swap 2배. 장상 종료
$ docker run -m 100m stress:latest stress --vm 1 --vm-bytes 150m -t 5s
```



## OOM Killer 설정

```bash
# Memory 100MB 할당. Out of memery 발생시 프로세스 kill 시키지 않음
$ docker run -d -m 100m --name m4 --oom-kill-disable=true nginx

# 확인
$ docker inspect m4 | grep Oom
```



## CPU 부하 테스트

```bash
# CPU 1개를 100% 사용
$ docker run --cpuset-cpus 1 --name c1 -d stress:latest stress --cpu 1

## 확인
$ htop # 시인성 개선된 top
$ docker stats
```