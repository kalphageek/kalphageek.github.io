---
layout: single
title: "Private Docker Registry 설치"
categories: docker
tag: [registry, hub, docker, image]
toc: true
#author_profile : false
---

> Private Dockerhub를 구성하고, 필요한 Docker Image를 Push할 수 있다

## Private Docker Registry (Hub) 설치

https://hub.docker.com/  > 검색 : registry > Docker Official Image 선택

[Docker Constainer 재시작 옵션](/docker/docker_container_restart/)

```
# 항상 재시작 하라
$ docker run -d -p 5000:5000 --restart always --name registry registry:2
```



## Local Image 생성 및 확인

private docker hub를 위한 image는 :(private repository url)/image명:tag" 형태로 생성해야한다

```
$ docker images
EPOSITORY                          TAG             IMAGE ID       CREATED        SIZE
registry                            2               773dbf02e42e   4 weeks ago    24.1MB
kalphageek/apigateway-service       1.0.1           94bbeda22e96   7 weeks ago    465MB
...
$ docker tag kalphageek/apigateway-service:1.0.1 localhost:5000/apigateway-service:1.0.1
$ docker images
EPOSITORY                          TAG             IMAGE ID       CREATED        SIZE
registry                            2               773dbf02e42e   4 weeks ago    24.1MB
localhost:5000/apigateway-service   1.0.1           94bbeda22e96   7 weeks ago    465MB
kalphageek/apigateway-service       1.0.1           94bbeda22e96   7 weeks ago    465MB
...
```



## Image Push 및 확인

```
$ docker push localhost:5000/apigateway-service:1.0.1
The push refers to repository [localhost:5000/apigateway-service]
83b5e865ba9b: Pushed 
cb0009e00b93: Pushed 
43015d7c3645: Pushed 
1401df2b50d5: Pushed 
1.0.1: digest: sha256:449a52edb6540c109eb7016843a8570d45f459bc0601515f50d823bd71b498af size: 1165
$ su -
# cd /var/lib/docker/volumes/
# ls -ltr
...
db20d59ee33bd2c9923890c5cfe4b0062f44a2d8dbd0b5f446865c849f00a688
# ls db20d59ee33bd2c9923890c5cfe4b0062f44a2d8dbd0b5f446865c849f00a688/_data/docker/registry/v2/repositories
apigateway-service
```

