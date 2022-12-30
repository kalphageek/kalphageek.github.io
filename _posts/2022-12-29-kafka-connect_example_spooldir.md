---
layout: single
title: "Kafka Connect 예제 - Spooldir"
categories: kafka
tag: [confluent, connect, example, spooldir]
toc: true
toc_sticky: true
#author_profile : false


---



### 1) 소스 위치

```bash
# Test 소스 파일 download
$ cd ~/test_source
$ wget https://raw.githubusercontent.com/chulminkw/KafkaConnect/main/sample_data/csv-spooldir-source.csv -O csv-spooldir-source-01.csv
```



### 2) Connector 생성

```bash
$ cd ~/connect/configs
$ ls
spooldir_test_source.json
# connector 생성
$ curl -X POST -H "Content-Type: application/json" http://localhost:8083/connectors --data @spooldir_test_source.json
# connector 상태 보기
$ curl -X GET http://localhost:8083/connectors/spooldir-test-source/status | jq "."
```

* Config 파일

```json
$ cat spooldir_test_source.json
{
  "name": "spooldir-test-source",
  "config": {
    "tasks.max": "3",
    "connector.class": "com.github.jcustenborder.kafka.connect.spooldir.SpoolDirCsvSourceConnector",
    "input.path": "/home/confluent/test_source",
    "input.file.pattern": "^.*\\.csv",
    "error.path": "/home/confluent/connect/spooldir_log/error",
    "finished.path": "/home/confluent/connect/spooldir_log/finished",
    "empty.poll.wait.ms": 30000,
    "halt.on.error": "false",
    "topic": "spooldir-test-source-topic",
    "csv.first.row.as.header": "true",
    "schema.generation.enabled": "true"
   }
}
```



### 3) 확인

```bash
# connectors 보기
$ curl -X GET http://localhost:8083/connectors
spooldir_test_source
# connector 상태 보기
$ curl -X GET http://localhost:8083/connectors/spooldir_test_source/status | jq "."
# topic 데이터 보기
$ consumer spooldir-test-source-topic --from-beginnig
```

