---
layout: single
title: "Confluent Kafka Install"
categories: kafka
tag: [confluent, install, alias, connect, log, suffix, tee]
toc: true
toc_sticky: true
#author_profile : false

---



> [샘플소스](https://github.com/chulminkw/KafkaConnect)

### 1) Download

[Previous Connect Download](https://www.confluent.io/previous-versions/). 사전에 Java Runtime이 설치되어 있어야 한다.

### 2) Install

```bash
$ cd download
$ tar xvf confluent-community-7.1.4.tar
$ sudo mv confluent-7.1.4 /usr/local/
$ chown confluent:confluent /usr/local/confluent-7.1.4

# link 설정
$ cd
$ ln -s /usr/local/confluent-7.1.4 confluent

# 환경변수 설정
$ vi .bashrc
export CONFLUENT_HOME=/home/cloggingonfluent/confluent
export PATH=.:$CONFLUENT_HOME/bin:$PATHlogging
:wq
$ . .bashrc
```

### 3) Alias 설정

```bash
$ vi .bashrc
alias zookeeper-start='zookeeper-server-start $CONFLUENT_HOME/etc/kafka/zookeeper.properties'
alias kafka-start='kafka-server-start $CONFLUENT_HOME/etc/kafka/server.properties'
alias kafka-stop='kafka-server-stop'
alias connect_start='connect-distributed $CONFLUENT_HOME/etc/kafka/connect-distributed.properties'

alias topic-create='kafka-topics --create --bootstrap-server localhost:9092 --partitions 1 --topic'
alias topic-list='kafka-topics --list --bootstrap-server localhost:9092'
alias topic-delete='kafka-topics --delete --bootstrap-server localhost:9092 --topic'
alias topic-describe='kafka-topics --describe --bootstrap-server localhost:9092 --topic'
alias producer='kafka-console-producer --bootstrap-server localhost:9092 --topic'
alias consumer='kafka-console-consumer --bootstrap-server localhost:9092 --topic'
alias registry-start='schema-registry-start $CONFLUENT_HOME/etc/schema-registry/schema-registry.properties'
alias connect-start='connect-distributed $CONFLUENT_HOME/etc/kafka/connect-distributed.properties'

export log_suffix=`date +"%Y%m%d%H%M%S"`
alias connect-start-log='connect-distributed $CONFLUENT_HOME/etc/kafka/connect-distributed.properties 2>&1 | tee -a ~/connect_console_log/connect_console_$log_suffix.log'
```



