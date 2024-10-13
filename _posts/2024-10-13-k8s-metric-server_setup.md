---
layout: single
title: "K8S Metrics Server setup"
categories: k8s
tag: [metric, hpa]
toc: true
toc_sticky: true
#author_profile: false

---



# 1. Node Level Logging

### 1. 강의

> [https://kubetm.github.io/k8s/08-intermediate-controller/hpa/#1-1-metrics-server-%EB%8B%A4%EC%9A%B4-%EB%B0%8F-%EC%84%A4%EC%B9%98](https://emea01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fkubetm.github.io%2Fk8s%2F08-intermediate-controller%2Fhpa%2F%231-1-metrics-server-%EB%8B%A4%EC%9A%B4-%EB%B0%8F-%EC%84%A4%EC%B9%98&data=05|02||474f809495fa486fd7c908dceb7bff22|84df9e7fe9f640afb435aaaaaaaaaaaa|1|0|638644164990259946|Unknown|TWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D|0|||&sdata=z3UsKNaHJL4Y2NR2zoDrKPMsYoui8gtWYx8VOJEjPco%3D&reserved=0)

### 2. 설치

```bash
kubectl apply -f https://raw.githubusercontent.com/k8s-1pro/install/main/ground/k8s-1.27/metrics-server-0.6.3/metrics-server.yaml
```

### 3. 설치 확인

```bash
$ kubectl get apiservices |egrep metrics

------------------------
v1beta1.metrics.k8s.io kube-system/metrics-server True 28m
------------------------

# node에 대한 metric 정보 확인 (1~2분후)
$ kubectl top node

------------------------
NAME CPU(cores) CPU% MEMORY(bytes) MEMORY%
k8s-master 485m 9% 4852Mi 32%
k8s-node1 413m 8% 4929Mi 33%
k8s-node2 554m 11% 4672Mi 31%
------------------------

```



# 2. HPA

### 1. HPA에 대한 metric 정보 확인

```bash
kubectl get hpa -w 
```

