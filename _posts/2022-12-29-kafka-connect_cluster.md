---
layout: single
title: "Kafka Connect Cluster 구성"
categories: kafka
tag: [confluent, connect, cluster, 8083]
toc: true
toc_sticky: true
#author_profile : false


---



### 1-1) 동일 서버 : connect-properties 파일 추가

```bash
$ cd $CONFLUENT_HOME/etc/kafka
$ cp connect-distributed.properties connect-distributed-8084.properties
$ vi connect-distributed-8084.properties
/listener
# Port 변경
listeners=HTTP://localhost:8084
:wq
```

### 1-2) 다른 서버 

```bash
$ cd $CONFLUENT_HOME/etc/kafka
$ vi connect-distributed.properties
/bootstrap
# Kafka Broker 주소 변경
bootstrap.servers=broker:9092
:wq
```



### 2) 추가된 Properties를 이용해 connect-distributed 하나더 실행

```bash
$ connect-distributed $CONFLUENT_HOME/etc/kafka/connect-distributed-8084.properties
```

