---
layout: single
title: "Kafka Connect - Spooldir"
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
    "error.path": "/home/confluent/test_source/error",
    "finished.path": "/home/confluent/test_source/finished",
    "empty.poll.wait.ms": 30000,
    "halt.on.error": "false",
    "topic": "spooldir-test-source-topic",
    "csv.first.row.as.header": "true",
    "schema.generation.enabled": "true"
  }
}
```

* Parameters

| 파라미터명                | 설명                                                         | 예시                                          |
| ------------------------- | ------------------------------------------------------------ | --------------------------------------------- |
| tasks.max                 | 최대 task thread의 개 수                                     | 3                                             |
| error.path                | 파일을 읽어 들일때 파일 포맷 등의 오류가 발생할때 해당 오류들을 저장하는 디렉토리 | /home/confluent/connect/spooldir_log/error    |
| finished.path             | Source Connector가 Kafka Topic으로 메시지 전송이 완료된 후 원래 파일을 이동 시키는 디렉토리 | /home/confluent/connect/spooldir_log/finished |
| empty.poll.wait.ms        | input.path를 모니터링 하는 주기 (ms단위). 3000은 3초         | 30000                                         |
| halt.on.error             | 에러 났을 때 중단할 지 여부                                  | false                                         |
| schema.generation.enabled | Topic에 schema를 추가 할 지 여부. true이면 Converter가 Topic에 schema,  payload로 만들고, schema에는 컬럼명과 타입 정보를, payload에는 기존 데이터를 위치 시킨다.<br>Converter에 대한 기본설정은 connect-distributed..properties에서 변경 가능하다 | true                                          |



### 3) 확인

```bash
# connectors 보기
$ curl -X GET http://localhost:8083/connectors
spooldir_test_source
# connector 상태 보기
$ curl -X GET http://localhost:8083/connectors/spooldir-test-source/status | jq "."
# topic 데이터 보기 (key값까지 print)
$ consumer spooldir-test-source-topic --from-beginning --property print.key=true | jq "."
```

