---
layout: single
title: "Docker-compose Yaml Option"
categories: docker-compose
tag: [docker, compose, option]
toc: true
#author_profile : false
---

## Docker-compose Yaml Option

| Option      | 설명                                                         |
| ----------- | ------------------------------------------------------------ |
| version     | **compose 버전.** <br />version: "2"                         |
| services    | **Compose를 이용해서 실행할 도커 container를 지정**<br />services:<br />  redis:<br />    image: redis<br />  webserver:<br />    image: nginx |
| build       | **Container 빌드**<br />webapp:<br />  build: .              |
| image       | **Compose를 통해 실행할 image를 지정**<br />webapp:<br />  image: centos:7 |
| command     | **Container내에서 실행될 추가 command **<br />app:<br />  image: node:12-alpine<br />    command: sh -c "yarn install && yarn run dev" |
| port        | **Container가 공개하는 port를 나열**<br />webapp:<br />  image: httpd:latest<br />  port:<br />    - 80<br />    - 8443:8443 |
| link        | **다른 container가 가지고 있는 정보가 필요한 경우 container명을 지정**<br />webserver:<br />  image: wordpress:latest<br />  link: <br />    mariadb:mariadb |
| expose      | **Port를 link로 연계된 container에게만 공개 때 사용할 port** |
| volumes     | **Container에 volume을 마운트**<br />webapp:<br />  image: httpd<br />  volumes: <br />    - dbdata:/var/www/html<br />...<br />volumes:<br />  dbdata: {} |
| environment | **Container에 적용할 환경변수를 정의<br />**mariadb:<br />  image: mariadb:5.7<br />    environment: <br />      MYSQL_ROOT_PASSWORD: pass |
| restart     | **Container가 종료될 때 적용될 restart 정책<br />Option:<br />**  no: 재시작되지 않음<br />  always: Container를 수동으로 끄기 전까지 항상 재시작<br />  on-failuer: 오류가 있을때 재시작<br />---<br />mariadb:<br />  image: mariadb:5.7<br />  restart: always |
| depends_on  | **Container간의 종속성 정의. 정의한 Container가 먼저 동작된다**<br />services:<br />  mariadb:<br />    image: mariadb:5.7<br />  web:<br />    image: wordpress:latest<br />    depends_on:<br />      - mariadb |

