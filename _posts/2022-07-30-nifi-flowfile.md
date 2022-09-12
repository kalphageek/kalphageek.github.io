---
layout: single
title: "Nifi FLOWFILE"
categories: nifi
tag: [nifi, flowfile, processor]
toc: true
toc_sticky: true
#author_profile : false
---



### 1. UpdateRecord

> FlowFile의 데이터를 수정하거나, 컬럼을 추가하는 등의 작업을 할 수 있다.  

* Ref : [https://www.youtube.com/watch?v=0U_nlLoHw_k&t=1864s](https://www.youtube.com/watch?v=0U_nlLoHw_k&t=1864s) (12:12)

* Property

  - Record Reader : CSVReader Controller

  - Record Writer : AvroRecordSetWriter Controller

  - /m :  ${metric} <-- FLOWFILE에 m이라는 컬럼 추가. 앞선 UpdateAttribute에서 ${metric} 속성에 'a' 또는 'b'를 임의로 설정한 상태 이다.


#### 1.1 CSVReader

* Property
  * Schema Access Strategy : Use String Fields From Header
  * Schema Registry : AvroSchemaRegistry Controller
  * Treat Fist Line as Header : True # 첫번째 라인을 헤더로 사용

#### 1.2 AvroSchemaRegistry

* Property

  * Treat Fist Line as Header : True # 첫번째 라인을 헤더로 사용

  * in_schema :   # 사용자 직접 정의

    ```json
    {
      "name": "in_schema",
      "type": "record",
      "namespace": "nifi",
      "fields": [
        {"name": "ct_no", "type": "long"},
        {"name": "m", "type": ["null", "string"]},
        {"name":  "ct_mgr", "type": ["null", "string"]}
      ]
    }
    ```

#### 1.3 AvroRecordSetWriter

* Property
  * Schema Write Strategy : Set 'schema.name' Attribute
  * Schema Registry : AvroSchemaRegistry Controller
  * Schema Access Stragtegy : Use 'Schema Name' Property



### 2. MergeContent

> 2개의  FLOWFILE을 1기로 Merge한다.<br>
> 이때, FOWFILE은 Avro포맷이어야하며, 각각의 FLOWFILE에는 UpdateAttribute를 이용해 ${fragment.index}와 ${fragment.count} 그리고 ${fragment.identifier} (임의의 값) 가 정의되어 있어야 한다.

* Ref : [https://www.youtube.com/watch?v=0U_nlLoHw_k&t=1864s](https://www.youtube.com/watch?v=0U_nlLoHw_k&t=1864s) (23:14)
* Property
  -  Merge Strategy : Defragment



### 3. QueryRecord

> Avro를 읽어서 CSV로 Write하기. FlowFile의 데이터를 수정하거나, 컬럼을 추가하는 등의 작업을 할 수 있다.  

* Ref : [https://www.youtube.com/watch?v=0U_nlLoHw_k&t=1864s](https://www.youtube.com/watch?v=0U_nlLoHw_k&t=1864s) (26:27)

* Property

  - Record Reader : AvroReader Controller

  - Record Writer : CSVRecordSetWriter Controller

  - query : 

    ```sql
    select t1.ct_id, t1.ct_amount, t2.mgr_name
    from 
      (select ct_id, ct_amount, ct_mgr_id from FLOWFILE where m = 'a') t1
      left join 
      (select mgr_id, mgr_name from FLOWFILE where m = 'b') t2
      on t1.ct_mgr_id = t2.mgr_id
    ```

#### 3.1 AvroReader

* Property

  * Schema Write Strategy : Set 'schema.name' Attribute
  * Schema Registry : AvroSchemaRegistry Controller

  

#### 3.2 CSVRecordSetWriter

* Property	

  * Schema Registry : AvroSchemaRegistry Controller

  * Schema Access Strategy : Inherit Record Schema

  * Schema Name : out_schema

    

#### 3.3 AvroSchemaRegistry

* Property

  * out_schema :   # 사용자 직접 정의

    ```json
    {
      "name": "out_schema",
      "type": "record",
      "namespace": "nifi",
      "fields": [
        {"name": "ct_no", "type": "long"},
        {"name":  "ct_mgr", "type": ["null", "string"]}
      ]
    }
    ```

#### 

### 4. QueryRecord

> CSV를 읽어서 CSV로 Write하기.  FLOWFILE에 hkfilter, non_hkfilter 속성 추가. GetFile 등 FlowFile에서 만들어진 데이터를 Query로 Filter할 수 있다. FlowFile은 FLOWFILE이라는 데이터베이스 테이블인 것처럼 처리됩니다. 이전 FlowFile (UpdateAttribute)에서 schema.name 속성을 정의해야 한다. 

* Ref : [https://www.youtube.com/watch?v=_SABMAiJ5Hg](https://www.youtube.com/watch?v=_SABMAiJ5Hg) (26:27)
* Property
  - Record Reader : CSVReader Controller
  - Record Writer : CSVRecordSetWriter Controller
  - hkfilter : select * from FROWFILE <Shift+Enter>where ct_mgr = 'HK' <-- 사용자 정의 (Queue에 fail/success같은 필터로 나타난다)
  - non_hkfilter : select * from FROWFILE <Shift+Enter>where ct_mgr <> 'HK' <-- 사용자 정의 (Queue에 fail/success같은 필터로 나타난다)
