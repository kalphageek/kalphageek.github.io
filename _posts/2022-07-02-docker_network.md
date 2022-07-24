---
layout: single
title: "Docker Network 구성"
categories: docker
tag: [docker, network, link, wordpress]
toc: true
toc_sticky: true
#author_profile : false
---

## Default Network

> Host와 Container를 ip tables로 port forwarding해주는 Bridge Network이며, Container의 ip를 지정할 수 없다

1. Host ip : 10.144.30.125
2. docker0 (172.17.0.1) : 자동 생성되는 docker bridge network
3. Web container :172.17.0.2 (동적 할당)
4. Appjs container :172.17.0.3 (동적 할당)



## User Defined Network

> Container의 ip를 지정하려면 별도의 Bridge Network을 만들면 된다

1. Docker Network 생성
2. Container 생성 시 Network 지정

```bash
$ docker network create --driver bridge \
--subnet 192.168.100.0/24 \ # Option : 지정안하면 172.18.0.0/16로 자동 할당
--gateway 192.168.100.254 \ # Option : 지정안하면 192.168.100.1로 자동 할당
mynet

$ docker network ls

$ docker run -d --name appjs \
--net mynet --ip 192.168.100.100 \ # Option : 지정안하면 ip 자동 할당
-p 8080:8080 kalphageek/appjs
```



## Link Container

> --link Option을 통해 동일host의 Container간 연결

```bash
$ docker run -d --name mariadb -v /dbdata /var/lib/mysql \ # DB 파일 저장 위치
-e MYSQL_ROOT_PASSWORD=pass \
-e MYSQL_PASSWORD=wordpress \ #wordpress의 DB password
mariadb:5.7

$ docker run -d --name wordpress \
--link mariadb:mariadb \ # mariadb의 Container명:Alias
-e WORDPRESS_DB_PASSWORD=wordpress -p 80:80 wordpress:4 #wordpress db 자동생성 됨

$ ls /dbdata
wordpress
...
```

