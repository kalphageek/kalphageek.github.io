---
layout: single
title: "Kafka Connect Cluster 구성"
categories: kafka
tag: [confluent, connect, cluster, "8083"]
toc: true
toc_sticky: true
#author_profile : false

---



### * 동일 서버에 추가  Connect (Worker) 실행

```bash
# connect-distributed.properties 복제해서 Port 변경
$ cd $CONFLUENT_HOME/etc/kafka
$ cp connect-distributed.properties connect-distributed-8084.properties
$ vi connect-distributed-8084.properties
/listener
# Port 변경
listeners=HTTP://localhost:8084
:wq

# 추가된 Properties를 이용해 connect-distributed를 실행
$ connect-distributed $CONFLUENT_HOME/etc/kafka/connect-distributed-8084.properties
```



### * 다른 서버에 추가  Connect (Worker) 실행

```bash
$ cd $CONFLUENT_HOME/etc/kafka
$ vi connect-distributed.properties
/bootstrap
# Kafka Broker 주소 변경
bootstrap.servers=broker:9092
:wq

# 추가 서버에서 connect-distributed 실행
$ connect-distributed $CONFLUENT_HOME/etc/kafka/connect-distributed.properties
```
