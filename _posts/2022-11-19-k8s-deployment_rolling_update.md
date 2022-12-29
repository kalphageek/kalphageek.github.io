---
layout: single
title: "K8S Deployment - Rolling Update"
categories: k8s
tag: [deployment, controller, rollingUpdate]
toc: true
toc_sticky: true
#author_profile: false


---



> Deployment는 Software의 자동 Update를 위해 사용한다. ReplicaSet과 동일하게 replicas, selector, template 정의가 필요하며, 추가로 strategy type (Recreate, RollingUpdate 등) 정의가 필요하다. <br>Deployment가 spec에 정의된 ReplicaSet을 자동 생성하는 방식으로 작동한다.<br>
>
> 신규버전의 pod를 생성하고, 기존버전의 pod를 삭제한다. 서비스 downtime이 발생된다

## 1. [Recreate]({{https://kalphageek.github.io}}{% link _posts/2022-11-19-k8s-deployment_recreate.md %})와 차이점

1. 설정 값 : spec: strategy: type: RollingUpdate, spec: minReadySeconds: 10
2. downtime 없음

## 2. 생성 Example

* revisionHistoryLimits : Backup을 위해 과거버전의  ReplicaSet을 삭제하지 않고 보관하는 갯수 (default 10)

````json
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-1
spec:
  selector:
    matchLabels:
      type: app
  replicas: 2
  strategy:
    type: RollingUpdate
  minReadySeconds: 10
  template:
    metadata:
      labels:
        type: app
    spec:
      containers:
      - name: container
        image: kubetm/app:v1
      terminationGracePeriodSeconds: 10

---
apiVersion: v1
kind: Service
metadata:
  name: svc-1
spec:
  selector:
    type: app
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
````

