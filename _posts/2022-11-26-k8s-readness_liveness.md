---
layout: single
title: "K8S Readness, Liveness"
categories: k8s
tag: [readness, liveness, probe]
toc: true
toc_sticky: true
#author_profile: false

---



> K8S는 Container가 정상인지만 확인한다. Container의 Service가 비정상인 경우 확인하지 못하며, 이 경우를 대비해 Readness, Liveness 설정이 필요하다.<br>
>
> Readness와 Liveness는 설정방법은 동일하면 적용시점만 다르다.

## 1. Readness, Liveness가 필요한 시점

1. Readness : Pod가 Failed된 후 새로운 Pod가 시작될때 Container는 올라왔지만 업무Service가 시작되기 직전의 시간 동안 Pod가 준비되지 않은상태로 표시
2. Liveness : Pod, Container는 정상이지만 Service가 비정상적인 동작(500 error 등)하는 경우 -> Pod 재시작하도록 함

## 2. 설정 방법

* Exec : Command(cat /tmp/ready.txt) 실행해서 그에 따른 결과를 체크해서 설정
* httpGet : Port(8080), Host(localhost), Path(/ready), HttpHeader(language:ko), Schema(http/https) 체크해서 설정
* tcpSocket : Port(8080), Host(localhost) 체크해서 설정
* 위 설정 중 하나는 반드시 설정되어야 한다

## 3. Exec

> Shell command의 정상실행 여부로 판다

```bash
$ cat /tmp/ready.txt
```

## 4. Exec-Sample (Readness)

```yaml
...
spec:
  containers:
  - name: readiness
    image: kubetm/app
    ports:
    - containerPort: 8080	
    readinessProbe:
      exec:
        command: ["cat", "/readiness/ready.txt"]
      initialDelaySeconds: 5
      periodSeconds: 10
      successThreshold: 3
    volumeMounts:
    - name: host-path
      mountPath: /readiness
...      
```

## 4. httpGet

> /health API를 통해 정상실행 여부 판단. 200 ~ 400까지는 성공 그외의 상태코드는 실패

```http
/health
```

## 5. httpGet-Sample (Liveness)

```yaml
...
spec:
  containers:
  - name: liveness
    image: kubetm/app
    ports:
    - containerPort: 8080
    livenessProbe:
      httpGet:
        path: /health
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 10
      failureThreshold: 3
  terminationGracePeriodSeconds: 0
...
```



## 6. 시나리오 (ReadnessProbe)

```yaml
ReadnessProbe
initialDelaySeconds:5
periodSeconds: 10
successThredshold: 3

Container에서 서비스가 정상적으로 기동되면 마지막 단계로 ready.txt를 생성하는 로직을 넣는다. 
그러면 K8S는 Container가 시작된 5초후부터 10초간격으로 ready.txt를 체크해서 3회 정상적으로 확인되면, Pod의 ContainerReady를 true, Ready를 true로 설정한다. 그리고 Endpoint도 Pod의 IP가 NotReadAddr -> Addresses로 위치가 바뀐다. 
```



## 7. 시나리오 (LivenessProbe)

```yaml
LivenessProbe
initialDelaySeconds:5
periodSeconds: 10
failureThredshold: 3

Liveness로 httpGet으로 /health체크
그러면 K8S는 Container가 시작된 5초후부터 10초간격으로 체크해서 3회 실패하면, Pod 재시작 된디ㅏ
```







