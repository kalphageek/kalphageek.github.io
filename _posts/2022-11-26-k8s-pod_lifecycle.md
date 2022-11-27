---
layout: single
title: "K8S Pod Lifecycle"
categories: k8s
tag: [pod, phase, initContainers, imageID, CrashLoopBackOff, Conditions, Lifecycle]
#author_profile : false
---



> Pod와 Container Lifecycle에 따른 상태

## 1. Pod

### 1) Phase

> Pod의 상태 

```bash
$ kubectl describe pod <name-of-pod> 
```

* **Pending** : 파드가 쿠버네티스 클러스터에서 승인되었지만, 하나 이상의 컨테이너가 설정되지 않았고 실행할 준비가 되지 않았다. 여기에는 파드가 스케줄되기 이전까지의 시간 뿐만 아니라 네트워크를 통한 컨테이너 이미지 다운로드 시간도 포함된다.
* **Running** : 파드가 노드에 바인딩되었고, 모든 컨테이너가 생성되었다. 적어도 하나의 컨테이너가 아직 실행 중이거나, 시작 또는 재시작 중에 있다.
* **Succeeded** : 파드에 있는 모든 컨테이너들이 성공적으로 종료되었고, 재시작되지 않을 것이다.
* **Failed** : 파드에 있는 모든 컨테이너가 종료되었고, 적어도 하나 이상의 컨테이너가 실패로 종료되었다. 즉, 해당 컨테이너는 non-zero 상태로 빠져나왔거나(exited) 시스템에 의해서 종료(terminated)되었다.
* **Unknown** : 어떤 이유에 의해서 파드의 상태를 얻을 수 없다. 이 단계는 일반적으로 파드가 실행되어야 하는 노드와의 통신 오류로 인해 발생한다.

### 2) Conditions

> Pod는 하나의 PodStatus를 가지며, 그것은 파드가 통과했거나 통과하지 못한 [PodConditions](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.25/#podcondition-v1-core) 배열을 가진다.

* **PodScheduled** : 파드가 노드에 스케줄되었다.
* **ContainersReady** : 파드의 모든 컨테이너가 준비되었다.
* **Initialized** : 모든 [초기화 컨테이너](https://kubernetes.io/ko/docs/concepts/workloads/pods/init-containers/)가 성공적으로 완료(completed)되었다.
* **Ready** : 파드는 요청을 처리할 수 있으며 일치하는 모든 서비스의 로드 밸런싱 풀에 추가되어야 한다

### 3) Conditions : Reason

> Pod Conditions의 마지막 전환에 대한 이유

* ContainersNotReady
* PodCompleted

## 2. Container

### 1) State

> Container 상태

* Waiting
* Running
* Terminated

### 2) State : Reason

> Container 상태의 원인

* ContainerCreating
* CrashLoopBackOff
* Error
* Completed

## 3. Lifecycle Sample

* 예) #1 (Pod와 Container 기동 중인 상태)
  * Pod : Phase -> Pending 
  * Container : State -> Creating 
  * Container : State : Reason -> ContainerCreating
* 예)  #2 (기동 중 Container가 에러가 난 상태)
  * Pod : Phase -> Running 
  * Container : State -> Waiting 
  * Container : State : Reason -> CrashLoopBackOff
* 예)  #3 (Pod, Container 모두 정상 기동 된 상태)
  * Pod : Phase -> Running 
  * Container : State -> Running 
* 예)  #4 (**Job에 에러가 발생한 상태**)
  * Pod : Phase -> Failed 
  * Container : State -> Terminated 
  * Container : State : Reason -> Error
* 예)  #5 (Job이 정상적으로 완료된 상태)
  * Pod : Phase -> Succeeded 
  * Container : State -> Terminated 
  * Container : State : Reason -> Completed

## 4. 기타

* ImageID가 없으면 Image를 download 중이라는 의미
* initContainers : Container보다 먼저 실행되서 Container를 초기화 시키는 등의 일을 한다.

```json
...
spec:
  containners:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers: 
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', 'until nslookup service; do echo waiting for my service; sleep 2; done;']
  - name: init-mydb
    image: busybox:1.28'
    command: ['sh', '-c', 'until nslookup mydb; do echo waiting for mydb; sleep 2; done;']
...
```



