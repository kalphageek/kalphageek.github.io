---
layout: single
title: "Docker-compose Example (Wordpress)"
categories: docker-compose
tag: [docker, compose, example, build]
toc: true
toc_sticky: true
#author_profile : false
---

> 홈페이지 생성



## 1단계, 서비스 디렉토리 생성

```bash
$ mkdir my_wordpress
$ cd my_wordpress
```



## 2단계, docker-compose.yml 생성

```bash
$ cat docker-compose.yml
version: "3.9"
    
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "80:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
volumes:
  db_data: {}
  wordpress_data: {}
```



## 3단계, docker-compose 실행

```bash
$ docker-compose up -d
```
