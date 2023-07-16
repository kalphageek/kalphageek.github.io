---
layout: single
title: "Confluent Setup"
categories: confluent
tag: [connect, kafka, setup, plugin, httpie, jq, kafkacat, kcat, alias]
toc: true
toc_sticky: true
#author_profile: false

---



## Confluent 설치

* Confluent download
  * 검색 : confluent download previous version > https://www.confluent.io/previous-versions/
  * 7.1.2 click

```bash
$ tar xvf confluent-community-7.1.2.tar
$ mv confluent-community-7.1.2 ~/workspace/
$ cd
$ vi .bashrc
export CONFLUENT_HOME=/home/jjd/workspace/confluent-7.1.2
export PATH=.:$PATH:$CONFLUENT_HOME/bin

alias confl='cd $CONFLUENT_HOME'
alias zookeeper-start='zookeeper-server-start $CONFLUENT_HOME/etc/kafka/zookeeper.properties'
alias kafka-start='kafka-server-start $CONFLUENT_HOME/etc/kafka/server.properties'
alias kafka-stop='kafka-server-stop'
alias topic-create='kafka-topics --create --bootstrap-server localhost:9092 --partitions 1 --topic'
alias topic-list='kafka-topics --list --bootstrap-server localhost:9092'
alias topic-delete='kafka-topics --delete --bootstrap-server localhost:9092 --topic'
alias topic-describe='kafka-topics --describe --bootstrap-server localhost:9092 --topic'
alias producer='kafka-console-producer --bootstrap-server localhost:9092 --topic'
alias avro-producer='kafka-avro-console-producer --bootstrap-server localhost:9092 --topic'
alias consumer='kafka-console-consumer --bootstrap-server localhost:9092 --topic'
alias avro-consumer='kafka-avro-console-consumer --bootstrap-server localhost:9092 --topic'
alias connect-start='connect-distributed $CONFLUENT_HOME/etc/kafka/connect-distributed.properties'
alias registry-start='schema-registry-start $CONFLUENT_HOME/etc/schema-registry/schema-registry.properties'
alias kcat='kafkacat -b localhost:9092 -J -q -u' # | jq '.'
alias httpcon='http http://localhost:8083/connectors'
```



## Plugins 설치

* Connector plugins download
  * https://www.confluent.io/hub
  * 검색 : jdbc connector > download click
* Mysql jdbc driver download
  * 검색 : mysql jdbc driver maven > [MySQL Connector Java - Maven Repository](https://mvnrepository.com/artifact/mysql/mysql-connector-java)
  * 8.0.29 click > Files : jar click

* Jar 복사

```bash
$ cd $CONFLUENT_HOME
$ mkdir configs
$ mkdir -p plugins/jdbc
$ unzip confluentinc-kafka-connect-jdbc-10.7.3.zip
$ cp confluentinc-kafka-connect-jdbc-10.7.3/lib/*.jar $CONFLUENT_HOME/plugins/jdbc/
$ cp mysql-connector-java-8.0.29.jar $CONFLUENT_HOME/plugins/jdbc/
```

* 설정파일 변경 및 Connect 재기동

```bash
$ vi $CONFLUENT_HOME/etc/kafka/connect-distributed.properties
plugin.path=/home/jjd/workspace/confluent-7.1.2/plugins
:wq
```



## 참조 문서

* Inflern 강좌 문서
  * https://github.com/kalphageek/KafkaConnectLearning
* SMT (Single Message Transform)
  * 검색 : kafka connect single message transform > https://docs.confluent.io/platform/current/connect/transforms/overview.html
  * ValueToKey



## Utility

* Httpie

  > curl을 대신해서 간단하게 사용할 수 있다.

  ```bash
  # connectors 보기
  $ http http://localhost:8083/connectors
  # connector 생성
  $ http POST http://localhost:8083/connectors @configs/jdbc_om_src_03.json
  ```

* Kafkacat

  > kafka-console-producer / kafka-console-consumer를 대신해서 간단하게 사용할 수 있다

  ```bash
  # mysql_om_smt_key_customers topic을 보는 consumer
  $ kcat -C -t mysql_om_smt_key_customers
  # alias kcat='kafkacat -b localhost:9092 -J -q -u'
  ```

* jq

  > 결과값을 Json 형태로 보여준다

  ```bash
  $ kcat -C -t mysql_om_smt_key_customers | jq '.'
  ```

  

## Start Shell 생성

```bash
$ vi start.sh
#!/usr/bin/sh

echo "pwd" | sudo --stdin systemctl start mysql
zookeeper-server-start $CONFLUENT_HOME/etc/kafka/zookeeper.properties &
kafka-server-start $CONFLUENT_HOME/etc/kafka/server.properties &
schema-registry-start $CONFLUENT_HOME/etc/schema-registry/schema-registry.properties &
connect-distributed $CONFLUENT_HOME/etc/kafka/connect-distributed.properties &
cd ~/workspace/kalphageek.github.io/
typora . &
cd
```

