---
layout: single
title: "Docker 미사용 Object 삭제"
categories: docker
tag: [prune, docker, delete, container, image, network, volume]
toc: true
toc_sticky: true
#author_profile : false
---



## Docker Prune

* docker container prune : 중지된 모든 컨테이너를 삭제한다.
* docker image prune : 이름 없는 모든 이미지를 삭제한다.
* docker network prune : 사용되지 않는 도커 네트워크를 모두 삭제한다.
* docker volume prune : 도커 컨테이너에서 사용하지 않는 모든 도커 볼륨을 삭제한다.
* docker system prune -a :  중지된 모든 컨테이너, 사용되지 않은 모든 네트워크, 하나 이상의 컨테이너에서 사용되지 않는 모든 이미지를 삭제한다. 따라서 남아있는 컨테이너 또는 이미지는 현재 실행 중인 컨테이너에서 필요하다.



## Docker Image 삭제

* docker rmi [Image ID]



## Docker Container 삭제

* docker rm -f [Container 명]



## Docker Volume 삭제

* docker volume rm [Volume 명]
