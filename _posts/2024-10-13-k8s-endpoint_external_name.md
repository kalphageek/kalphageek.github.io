---
layout: single
title: "Create Monitor by Headless"
categories: k8s
tag: [pod,endpoint,external,name]
toc: true
toc_sticky: true
#author_profile: false

---



# 1. Headless로 모니터 pod생성하기

### 1. Endpoint

> Pod에서 특정 IP접근하기

```bash
vi endpoint2.yaml
---
apiVersion: v1
kind: Endpoints
metadata:
name: endpoint2
subsets:
- addresses:
- ip: 20.109.5.12
ports:
- port: 8080

$ curl endpoint2:8080/hostname
```



### 2. External Name

> Pod에서 특정 도메인접근하기

```bash
vi externalname1.yaml
---
apiVersion: v1
kind: Service
metadata:
name: externalname1
spec:
type: ExternalName
externalName: github.github.io

$ curl -O externalname1/kubetm/kubetm.github.io/blob/master/sample/practice/intermediate/service-sample.md 
```

