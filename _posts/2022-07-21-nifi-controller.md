---
layout: single
title: "Nifi Controller"
categories: nifi
tag: [nifi, controller, component]
toc: true
#author_profile : false
---



### 1. DBCPConnectionPool
> Database 연결

* Ref : https://www.youtube.com/watch?v=_SABMAiJ5Hg (45:28)
* Property
  - Database Connection URL : jdbc:postgresql://db.deogi:5432/postgres
  - Database Driver Class Name : org.postgresql.Driver
  - Database Driver Location(s) : $NIFI_HOME/lib  <-- postgresql-42.2.19.jar 저장
  - Database User : pgadmin
  - Password : pgadmin
  
  
### 2. CSVReader
> 특정위치로 파일을 복사한다. GetFile에서 success인 파일을 저장하도록 구성할 수 있다

* Ref : https://www.youtube.com/watch?v=_SABMAiJ5Hg (19:16)
* Property
  - Schema Access Strategy : Use 'Schema Name' Property
  - Schema Registry : AvroSchemaRegistry Controller
  - schema.name : ${schema.name}
  - schema.text : ${avro.schema}
  - Treat First Line as Header : true <- 첫번째 행 skip
  
  
### 3. AvroSchemaRegistry
> CSV의 ,(콤마) 기반 컬럼에 스키마를 정의할 수 있다

* Ref : https://www.youtube.com/watch?v=_SABMAiJ5Hg (21:52)
* Property
  - schema : <-- 사용자 정의
  ```json
  {
    "name": "hkschema",
    "type": "record",
    "namespace": "nifi",
    "fields": [
      {"name": "ct_no", "type": "string"},
      {"name":  "ct_mgr", "type": "string"}
    ]
  }
  ```



### 4. CSVRecordSetWriter

> CSV Record를 Write한다.

* Ref : https://www.youtube.com/watch?v=_SABMAiJ5Hg (24:02)
* Property
  - Schema Writer Strategy : Set 'schema.name' Attribute
  - Schema Access Stragegy : Set 'schema.name' Property
  - Schema Registry : AvroSchemaRegistry Controller
  - schema.name : ${schema.name}
  - schema.text : ${avro.schema}
  
  