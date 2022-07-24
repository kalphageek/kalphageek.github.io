---
layout: single
title: "Docker-compose Example (Visit Count)"
categories: docker-compose
tag: [docker, compose, example, build]
toc: true
toc_sticky: true
#author_profile : false
---

> 방문횟수를 카운트하는 python 컨테이너 빌드와 운영



## 1단계, 서비스 디렉토리 생성

```bash
$ mkdir visitcount
$ cd visitcount
```



## 2단계, Dockerfile 생성

```bash
$ cat dockerfile
FROM python:3.7-alpine
WORKDIR /code
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
# Python Library List -> requirements.txt
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 5000
# 전체 복사
COPY . .
# Web Server : Flask 실행
CMD ["flask", "run"]
```



## 3단계, docker-compose.yml 생성

```bash
$ cat docker-compose.yml
version: "3.9"
services:
  web:
    build: .
    ports:
      - "5000:5000"
  redis:
    image: "redis:alpine"
```



## 4단계, docker-compose 실행

```bash
$ docker-compose up -d
```



## 추가 1단계, docker-compose 중단 (수정을 위한)

```bash
$ cd visitcount
# Container를 삭제까지 한다
$ docker-compose down
```



## 추가 2단계, docker-compose.yml 수정

> Container의 /code 디렉토리를 host의 /visitcount로 변경,해서 개발 중 소스코드를 host에서 제어가 가능하도록 한다.

```bash
$ cat docker-compose.yml
version: "3.9"
services:
  web:
    build: .
    ports:
      - "5000:5000"
    volumes:
      - .:/code 
    environment:
      FLASK_ENV: development
  redis:
    image: "redis:alpine"
```



## 추가 3단계, docker-compose 실행

```bash
$ docker-compose up -d
```



## 추가 파일

```bash
$ cat requirements.txt
flask
redis

$ cat app.py
import time

import redis
from flask import Flask

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)

@app.route('/')
def hello():
    count = get_hit_count()
    return 'Hello World! I have been seen {} times.\n'.format(count)
```

