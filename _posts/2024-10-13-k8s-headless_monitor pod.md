---
layout: single
title: "Create Monitor by Headless"
categories: k8s
tag: [monitor, headless, pod]
toc: true
toc_sticky: true
#author_profile: false

---



# 1. Headless로 모니터 pod생성하기

### 1. 방법1

> [https://kubetm.github.io/k8s/08-intermediate-controller/hpa/#1-1-metrics-server-%EB%8B%A4%EC%9A%B4-%EB%B0%8F-%EC%84%A4%EC%B9%98](https://emea01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fkubetm.github.io%2Fk8s%2F08-intermediate-controller%2Fhpa%2F%231-1-metrics-server-%EB%8B%A4%EC%9A%B4-%EB%B0%8F-%EC%84%A4%EC%B9%98&data=05|02||474f809495fa486fd7c908dceb7bff22|84df9e7fe9f640afb435aaaaaaaaaaaa|1|0|638644164990259946|Unknown|TWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D|0|||&sdata=z3UsKNaHJL4Y2NR2zoDrKPMsYoui8gtWYx8VOJEjPco%3D&reserved=0)

1.  daemonset으로 방화벽 테스트(test_firewall) 하는 pod 생성
2.  headless 생성 (subdomain)

- 1번의 pod를 headless에 연결

3. test_firewall을 호출하는 pod/svc생성

- headless에서 pod ip 가져오기 (nslookup headless명)
- loop돌면서 pod_id:8080/test_firewall 호출
- 결과를 가지고 성공/실패 결정



### 2. 방법2

1. daemonset으로 방화벽 테스트(test_firewall) 하는 pod 생성
2. configmap을 테스트할 ip와 port를 1번의 pod에 제공
3. test_firewall은 ip가 들어오면 테스트하고 결과를 log에 남김
4. 3번의 log를 분석하는 pod/svc 생성
5. 4번의 pod/svc가 log를 가지고 성공/실패 결정
