---
layout: single
title: "Confluent Connectors"
categories: confluent
tag: [connect, kafka, connector, jdbc, source]
toc: true
toc_sticky: true
#author_profile: false

---



## SMT 적용

> ValueToKey : DB의 record value 중 pk value를 topic message의 key로 전환한다

### 1. 단일컬럼 Key 적용

```bash
$ http http://localhost:8083/connectors
$ http POST http://localhost:8083/connectors @configs/jdbc_om_src_03.json
```

**jdbc_om_source_03.json**

```json
{
    "name": "jdbc_om_src_03",
    "config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
        "tasks.max": "1",
        "connection.url": "jdbc:mysql://localhost:3306/om",
        "connection.user": "connect_dev",
        "connection.password": "connect_dev",
        "topic.prefix": "om_smt_key_",
        "table.whitelist": "customers",
        "poll.interval.ms": 10000,
        "mode": "timestamp+incrementing",
        "incrementing.column.name": "customer_id",
        "timestamp.column.name": "system_upd",
        
        "transforms": "create_key, extract_key",
        "transforms.create_key.type": "org.apache.kafka.connect.transforms.ValueToKey",
        "transforms.create_key.fields": "customer_id",
        
        "transforms.extract_key.type": "org.apache.kafka.connect.transforms.ExtractField$Key",
        "transforms.extract_key.field": "customer_id"
    }
}
```



###  2. 다중컬럼 Key 적용

```bash
$ http POST http://localhost:8083/connectors @configs/jdbc_om_src_04.json
```

**jdbc_om_src_04.json**

```json
{
    "name": "jdbc_om_src_04",
    "config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
        "tasks.max": "1",
        "connection.url": "jdbc:mysql://localhost:3306/om",
        "connection.user": "connect_dev",
        "connection.password": "connect_dev",
        "topic.prefix": "om_smt_mkey_",
        "table.whitelist": "order_items",
        "poll.interval.ms": 10000,
        
        "mode": "timestamp",
        "timestamp.column.name": "system_upd",

        "transforms": "create_key",
        "transforms.create_key.type": "org.apache.kafka.connect.transforms.ValueToKey",
        "transforms.create_key.fields": "order_id, line_item_id"
     }
}
```



### 3. 토픽 데이터 보기

```bash
# 자동생성된 Topic명 확인 (topic.prefix + 테이블명)
$ cd /tmp/kafka_logs
$ ls -tr
om_smt_key_customers-0	om_smt_mkey_order_items-0

# Topic 데이터 확인
$ kcat -C -t om_smt_key_customers | jq '.'
```

