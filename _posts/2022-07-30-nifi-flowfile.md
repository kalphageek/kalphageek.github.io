---
layout: single
title: "Nifi FLOWFILE"
categories: nifi
tag: [nifi, flowfile, processor]
toc: true
toc_sticky: true
#author_profile : false
---



### 1. QueryRecord

> GetFile 등 FlowFile에서 만들어진 데이터를 Query로 Filter할 수 있다. FlowFile은 FLOWFILE이라는 데이터베이스 테이블인 것처럼 처리됩니다. 이전 FlowFile (UpdateAttribute)에서 schema.name 속성을 정의해야 한다. 

* Ref : [https://www.youtube.com/watch?v=_SABMAiJ5Hg](https://www.youtube.com/watch?v=_SABMAiJ5Hg) (46:25)
* Property
  - Record Reader : CSVReader Controller
  - Record Writer : JSONRecordSetWriter Controller
  - hkfilter : select * from FROWFILE <Shift+Enter>where ct_mgr = 'HK' <-- 사용자 정의 (Queue에 fail/success같은 필터로 나타난다)
  - non_hkfilter : select * from FROWFILE <Shift+Enter>where ct_mgr <> 'HK' <-- 사용자 정의 (Queue에 fail/success같은 필터로 나타난다)



### 2. UpdateRecord

> FlowFile의 데이터를 수정하거나, 컬럼을 추가하는 등의 작업을 할 수 있다.  UpdateAttribute에서 생성된 table속성의 값을 FLOWFILE의 m이라는 컬럼으로 추가 한다

* Ref : [https://www.youtube.com/watch?v=0U_nlLoHw_k&t=1864s](https://www.youtube.com/watch?v=0U_nlLoHw_k&t=1864s) (12:12)
* Property
  - Record Reader : CSVReader Controller
  - Record Writer : AvroRecordSetWriter Controller
  - /m : ${table}
