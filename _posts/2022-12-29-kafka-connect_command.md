---

layout: single
title: "Kafka Connect 명령어"
categories: kafka
tag: [confluent, connect, plugins, curl, rest-api, jq]
toc: true
toc_sticky: true
#author_profile : false

---



## 1. GET

### 1) Connectors

> jq : json formatter 

```bash
# plugins 보기
$ curl -X GET http://localhost:8083/connector-plugins | jq "."
# connectors 보기
$ curl http://localhost:8083/connectors
spooldir-test-source
# connector 상태 보기
$ curl http://localhost:8083/connectors/spooldir-test-source/status | jq "."
```



## 2. POST

### 1) Connectors

```bash
# connector 등록
$ cd ~/connect/configs
$ ls
spooldir_test_source.json
$ curl -X POST -H "Content-Type: application/json" http://localhost:8083/connectors --data @spooldir_test_source.json
# 또는
$ http POST http://localhost:8083/connectors @spooldir_test_source.json
```



## 3. DELETE

### 1) Connectors

```bash
# connectors 보기
$ curl -X GET http://localhost:8083/connectors
spooldir_test_source
# connector 삭제
$ curl -X DELETE http://localhost:8083/connectors/spooldir-test-source
# 또는
$ http DELETE http://localhost:8083/connectors/spooldir-test-source
```

