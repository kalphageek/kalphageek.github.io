---
layout: single
title: "K8S ReplicaSet"
categories: k8s
tag: [replicaset, controller, replicas, selector, template, example, delete]
#author_profile : false
---



> ReplicaSet은 replicas, selector, template으로 구성되는데, pods의  auto healing/scaling을 가능하게하는 controller이다.

## 1. replicas

> Auto scaleout 갯수를 지정한다. pod가 죽으면 이 갯수를 유지하기 위해 자동으로 새로운 pod가 생성된다. 이때 이름은 [replicaset의 이름-임의의문자] 행태로 생성된다.

## 2. selector

> Label을 선택한다.  matchLabels, matchExprssions를 사용할 수 있다.  selector의 key, value는 반드시 template에 존재해야 한다.

* matchLabels : Label을 key, value의 정확한 값으로 선택한다.
* matchExprssions : Label의  operator [In, Notin, Exists, Notexists]를 통해 value의 값을 선택할 수 있다로 선택할 수 있다 --> 잘 사용안함.

## 3. template

> Pod를 auto healing/scaling하기 위한 구성을 정의한다. pod를 생성하기위해 사용하는 설정과 동일하다.

##  4. 생성 Example

```json
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: replica1
spec:
  replicas: 1
  selector:
    matchLabels:
      type: web
      ver: v1
    matchExpressions:
    - {key: type, operator: In, values: [web]}
    - {key: ver, operator: Exists}
  template:
    metadata:
      labels:
        type: web
        ver: v1
        location: dev
    spec:
      containers:
      - name: container
        image: kubetm/app:v1
      terminationGracePeriodSeconds: 0
```

## 5. ReplicaSet을 이용해 Container를 수동 Upgrade 방법

1. template > image의 version 수정
2. 기존 pod 삭제

## 6. 기타 주의사항

> ReplicaSet을 삭제하면 연결된 모든 pod들도 삭제한다. 만일 pod들이 삭제되지 않도록 하려면 삭제할때 "--cascade=false" 옵션을 사용해야 한다 (cli로만 가능)<br>
>
> ReplicaSet을 동일한 template으로 재생성하면 기존에 만들진 pods를 다시 연결해준다.

```bash
$ kubectl delete replicationcontrollers replica1 --cascade=false
```

##  
