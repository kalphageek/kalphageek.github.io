---

layout: single
title: "Kafka Connect 명령어"
categories: kafka
tag: [confluent, connect, plugins, curl, rest-api, jq, http, link, curl]
toc: true
toc_sticky: true
#author_profile : false

---



> [jq / http]({{http://kalphageek.github.io}}{% link _posts/2022-12-18-utility-tools.md %})

## 1. GET

### 1) Connectors

```bash
# plugins 보기
$ curl http://localhost:8083/connector-plugins | jq "."
# connectors 보기
$ curl http://localhost:8083/connectors
spooldir-test-source
# connector 상태 보기
$ curl http://localhost:8083/connectors/spooldir-test-source/status | jq "."
# 또는
$ http http://localhost:8083/connectors/spooldir-test-source/status
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
# 등록하기 전에 소스에 파일이 없으면 에러가 발생한다.
```



## 3. PUT

### 1) Connectors

```bash
# connector 중지
$ http PUT http://localhost:8083/connectors/spooldir-test-source/pause
# connector 다시 시작
$ http PUT http://localhost:8083/connectors/spooldir-test-source/resume
```

> **Resume 후에도 connector의 status가 'FAILD' 인 경우 삭제 후 재생성 한다. 그렇게 해도 connect에서 offset을 관리하기 때문에 문제없다.**



## 4. DELETE

### 1) Connectors

```bash
# connectors 보기
$ curl -X GET http://localhost:8083/connectors
spooldir_test_source
# connector 삭제
$ http DELETE http://localhost:8083/connectors/spooldir-test-source
```

