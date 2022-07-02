---
layout: single
title: "Container Resource 제어"
categories: docker
tag: [resource, docker, container]
toc: true
#author_profile : false
---

## Memory 제한

| 옵션                 | 의미                                              |
| -------------------- | ------------------------------------------------- |
| --memory, -m         | 최대 메모리양 지정                                |
| --memory-swap        | 최대 메모리 + Swap 사이즈 지정, 생략시 2배로 설정 |
| --memory-reservation | --m 보다 적은값으로 구성하기 위한 설정            |
| --oom-kill-disable   | OOM Killer가 프로세스 kill하지 못하도록 보호      |

```bash
$ docker run -d -m 512m nginx:1.4
$ docker run -d -m 1g --memory-reservation 500m nginx:1.4
$ docker sun -d -m 200m --oom-kill-disable nginx:1.4
```



## CPU 제한

| 옵션          | 의미                                                         |
| ------------- | ------------------------------------------------------------ |
| --cpus        | Container에 할당할 CPU 코어 갯수                             |
| --cpuset-cpus | Container가 사용할 수 있는 CPU를 지정. CPU index는 0부터     |
| --cpu-share   | Default로 Container들이 사용하는 CPU 비중은 1024를 기반으로 설정. 이 값을 조정해서 CPU원 할당을 조정할 수 있음. <br />cpu-share=2048이며 기본값의 2배를 할당 |

```bash
$ docker run -d --cpus=.5 centos:7.8
$ docker run -d --cpu-share 2048 centos:7.8
$ docker run -d --cpuset-cpus 0-3 centos:7.8
```



## Block IO (Local Disbundle exec jekyll servek) 제한

| 옵션                                        | 의미                                                         |
| ------------------------------------------- | ------------------------------------------------------------ |
| --blkio-weight<br />--blkio-weight-device   | Block IO의 쿼타를 설정할 수 있으며 100~1000까지 선태<br />default 500 |
| --device-read-bps<br />--device-write-bps   | 특정 디바이스의 읽기와 쓰기 작업속도(초) 제한한다.<br />단위 : kb, mb, gb |
| --device-read-iops<br />--device-write-iops | Container의 읽기/쓰기 속도의 쿼타를 설정한다<br />초당 쿼타가 제한되 IO를 발생시킨다. 0 이상의 정수로 표기<br />초당 데이터 전송량 = iops * block size |

```bash
$ docker run -it --rm --blkio-write 100 centos:7.8 /bin/bash
$ docker run -it --rm --blkio-write-bps /dev/vda:1mb centos:7.8 /bin/bash
$ docker run -it --rm --blkio-read-bps /dev/vda:10mb centos:7.8 /bin/bash
$ docker run -it --rm --blkio-write-iops /dev/vda:10 centos:7.8 /bin/bash
$ docker run -it --rm --blkio-read-iops /dev/vda:100 centos:7.8 /bin/bash
```



## Container Resource 사용량 모니터링

* Docker 모니터링 Commands

  * docker stat : 실행중인 Container의 런타임 통계 확인

    ```bash
    $ docker stats [OPTIONS] [CONTAINER NAME]
    ```

  * docker event : Docker 호스트의 실시간 이벤트정보를 수집해서 출력

    ```bash
    $ dcoker events -f container=[CONTAINER NAME]
    $ dcoker image -f container=[IMAGE NAME]
    ```

* cAdviser

  [http://github.com/google/cadviser](http://github.com/google/cadviser)