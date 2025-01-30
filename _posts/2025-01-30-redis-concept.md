---
layout: single
title: "Redis 개요"
categories: redis
tag: [session, token, 인증, sentinel, cluster, 비교]
toc: false
toc_sticky: true
#author_profile : false
---





* Redis Cluster / Sentinel
  * Redis Sentinel : 1G ~ 10G의 비교적 저용량의 데이터를 저장하거나 가벼운 Cache용도로 활용하는 서비스
  * Redis Cluster : Redis Sentinel에서 운영하기 어려운 대용량의 데이터를 저장하거나 Sharding이 필요한 서비스
* Redis Sentinel / Cluster on Kubernetes 구성

​	> 참고자료 : https://tech.kakaopay.com/post/kakaopaysec-redis-on-kubernetes/

*  고성능 Redis Session

> Redis는 입력값을 hash값으로 변환 후 그렇게 나온 값을 메모리주소값으로 사용한다. (hash값은 알고리즘이 동일하면 항상 동일한 값을 제공한다)



* Redis session

| 순서 | Client                   | Redis      | Server        |
| ---- | ------------------------ | ---------- | ------------- |
| 1    | 로그인 with ID/PWD       |            |               |
| 2    |                          |            | 인증          |
| 3    |                          |            | Token 발급    |
| 4    | Http Header에 Token 저장 | Token 저장 |               |
| 5    | Request with Token       |            |               |
| 6    |                          |            | Token 질의    |
| 7    |                          | Token 확인 |               |
| 8    |                          |            | Repsonse      |
| 9    | Response Accept          |            |               |
| 10   |                          |            | Token Timeout |
| 11   |                          | Token 삭제 |               |