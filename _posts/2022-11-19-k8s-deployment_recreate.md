---
layout: single
title: "K8S Deployment - Recreate"
categories: k8s
tag: [deployment, controller, recreate]
#author_profile: false
---



> Deployment는 Software의 자동 Update를 위해 사용한다. ReplicaSet과 동일하게 replicas, selector, template 정의가 필요하며, 추가로 strategy type (Recreate, RollingUpdate 등) 정의가 필요하다. <br>Deployment가 spec에 정의된 ReplicaSet을 자동 생성하는 방식으로 작동한다.<br>
> 기존버전을 중단하고, 신규버전을 생성한다. 서비스 downtime이 발생한다

## 1. spec

> [ReplicaSet]({{https://kalphageek.github.io}}{% link _posts/2022-11-19-k8s-replicaset.md %})의 replicas, selector, template를 의미한다

## 2. stratey의 type: Recreate

1. spec을 기반으로 신규 ReplicaSet을 만든다
2. 기존 ReplicaSet의  pod를 삭제한다.
3. 신규 ReplicaSet의 pod를 생성한다.

## 3. 생성 Example

* revisionHistoryLimits : Backup을 위해 과거버전의  ReplicaSet을 삭제하지 않고 보관하는 갯수 (default 10)

```json
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
    type: Recreate
  revisionHistoryLimit: 1
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
```

## 4. Software Update

> Deployment에 정의된 container image의 version을 update하면 바로 시작된다.

## 5. Test Code
```bash
$ while true; do curl [svc-1 의 Cluster IP]:8080/version; sleep 1; done
```

## 6.  Software Rollback
> 이전 Version으로 되돌아 간다.

```bash
# 기 존재하는 Revision 확인하기
$ kubectl rollout history deployment deployment-1
# Rollback
$ kubectl rollout undo deployment deployment-1 --to-revision=2
```
