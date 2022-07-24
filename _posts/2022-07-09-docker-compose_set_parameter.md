---
layout: single
title: "Docker-compose 파라미터 전달 방법"
categories: docker-compose
tag: [docker, compose, parameter, shell]
toc: true
toc_sticky: true
#author_profile : false
---



> service-service.sh에게 전달한 파라미터를 환경변수로 설정하고, docker-compose에서 이것을 읽어들인다



##  Docker-compose 파라미터 전달 예

```
$ cat docker-compose.yaml
version: '3'
services:  
    connect:    
        image: connect-service:1.0    
        environment:
            manage-service-ip: ${MANAGE_SERVICE_IP}
			
$ cat connect-service.sh
#!/bin/bash
if [ -z $1 ]
then
    echo "Usage : service.sh [manage-service IP]"
    exit 1
fi

MANAGE_SERVICE_IP=$1
RESULT=$(ping -w 3 $MANAGE_SERVICE_IP | grep "100% packet loss" | wc -l)
if [ $RESULT -eq 1 ]
then
    echo 'Your manage-service IP is not connecting...'
    exit 1
fi        
export $MANAGE_SERVICE_IP
echo $MANAGE_SERVICE_IP
docker-compose config
docker-compose up -d
:wq

$ connect-service.sh 127.0.0.1
```

```bash
---
version: '3'
services:  
    connect:    
        image: connect-service:1.0    
        environment:
            manage-service-ip: 127.0.0.1
```

