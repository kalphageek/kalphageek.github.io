---
layout: single
title: "K8S Node Scheduling"
categories: k8s
tag: [affinity, anti affinity, node, pod, matchExpressions, required, perpered, sample]
#author_profile: false

---



> Pod를 원하는 Node에 배포하기 위해 필요하다.

## 1. Node Affinity

> nodeSelector외에 matchExpressions를 통해 원하는 node에 배포할 수 있다.

* required : Label이 일치하는 Node가 없으면 에러가 난다.
* preperred : Label이 일치하지 않으면, k8s 내부 가중치에 따라 Node가 정해진다.

### 1) matchExpressions, required Sample

* ch라는 label이 설정되지 않은 상태에서 진행

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: pod-required
spec:
 affinity:
  nodeAffinity:
   requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
    - matchExpressions:
      - {key: ch, operator: Exists}
 containers:
 - name: container
   image: kubetm/app
 terminationGracePeriodSeconds: 0
```

### 3) matchExpressions, prepered Sample

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: pod-preferred
spec:
 affinity:
  nodeAffinity:
   preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 1
      preference:
       matchExpressions:
       - {key: ch, operator: Exists}
 containers:
 - name: container
   image: kubetm/app
 terminationGracePeriodSeconds: 0
```



## 2. Pod Affinity

> 어떤 Pod가 다른 특정한 Pod가 위치한 Node에 배포되야 할 때 사용한다.

### 1) Sample

* server1 Pod는 web1 Pod가 배포된 동일한 Node에 배포된다.

```bash
$ kubectl label nodes k8s-node1 a-team=1
$ kubectl label nodes k8s-node2 a-team=2
```

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: web1
 labels:
  type: web1
spec:
 nodeSelector:
  a-team: '1'
 containers:
 - name: container
   image: kubetm/app
 terminationGracePeriodSeconds: 0
 ---
 
apiVersion: v1
kind: Pod
metadata:
 name: server1
spec:
 affinity:
  podAffinity:
   requiredDuringSchedulingIgnoredDuringExecution:   
   - topologyKey: a-team
     labelSelector:
      matchExpressions:
      -  {key: type, operator: In, values: [web1]}
 containers:
 - name: container
   image: kubetm/app
 terminationGracePeriodSeconds: 0
```



## 3. Pod Anti-Affinity

> 어떤 Pod가 다른 특정한 Pod가 위치하지 않은 Node에 배포되야 할 때 사용한다. 예) Master - Slave 관계

### 1) Sample

> slave Pod는 master Pod와는 다른 Node에 배포된다.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: master
  labels:
     type: master
spec:
  nodeSelector:
    a-team: '1'
  containers:
  - name: container
    image: kubetm/app
  terminationGracePeriodSeconds: 0
  ---
  
apiVersion: v1
kind: Pod
metadata:
 name: slave
spec:
 affinity:
  podAntiAffinity:
   requiredDuringSchedulingIgnoredDuringExecution:   
   - topologyKey: a-team
     labelSelector:
      matchExpressions:
      -  {key: type, operator: In, values: [master]}
 containers:
 - name: container
   image: kubetm/app
 terminationGracePeriodSeconds: 0
```

