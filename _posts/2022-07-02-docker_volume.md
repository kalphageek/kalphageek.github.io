---
layout: single
title: "Docker 데이터 영구저장 및 공유"
categories: docker
tag: [volume, docker, nginx, container, mariadb]
toc: true
toc_sticky: true
#author_profile : false
---



> Volume Mount 되지 않은 변경사항은 Container가 삭제되었을때 함께 삭제된다..



## Volume 생성 Option

* -v [host path] : [container mount path]
* -v [host path] : [container mount path] : [read write mode]
* -v [host path] : [container mount path]

예>

```bash
# Maria DB Data 영구 보존
$ docker run -d -v /dbdata:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=pass --name mariadb mariadb:10.7.3
# Read Only Mode
$ docker run -d -v /webdata:/var/www/html:ro ...
# Volume명은 자동 생성 (/var/lib/docker/volumes/UUID/_data)
$ docker run -d /var/lib/mysql -e MYSQL_ROOT_PASSWORD=pass mysql:latest
```



## 컨데이터간 데이터 공유 (Volume 공유)

```bash
# /webdata에 사용자 데이터 생성
$ docker run -v /webdata:/webdata -d --name df kalphageek:latest
# df에서 생성된 /webdata의 사용자데이터를 read only로 Nginx Web 서비스에서 사용
$ docker run -v /webdata:/usr/share/nginx/html:ro -d --name nginx -p 80:80 nginx:1.14
```



## Volume 관리

```bash
# Volume 보기
$ docker volume ls
# Volume 삭제
$ docker volume rm 57.....
```



