---
layout: single
title: "Nifi Cluster"
categories: nifi
tag: [nifi, text]
toc: true
toc_sticky: true
#author_profile : false
---



### 1. Sub Project

- Minifi : Lightweight server용 agent 
- Registry : Nifi dataflow를 버전별로 관리 및 User, Group별 권한 관리 기능 제공, Data flow 변경 및 삭제 복구 기능 제공



### 2. Remote Processor Group

> nifi를 수집서버, 분석서버 등으로 나누어 처리할 수 있다. 수집서버에서는 Remote Port로 분석버서로 전달하고, 분석서버에서는 Remote Processor Group을 통해 데이터를 전달 받는다. nifi 서버가 자동으로 인식한다.

* Ref : [https://www.youtube.com/watch?v=mxnYWTabqqQ&t=987s](https://www.youtube.com/watch?v=mxnYWTabqqQ&t=987s) (37:14)
* Property
  - URLs : http://localhost:18080/nifi   <- 분석서버 nifi url
  ![image](https://user-images.githubusercontent.com/29995416/179385128-60800936-9554-4bc5-9a62-2e8266bc151e.png)