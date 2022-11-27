---
layout: single
title: "K8S Readness, Liveness"
categories: k8s
tag: [readness, liveness, probe]
#author_profile: false

---



> K8S는 Container가 정상인지만 확인한다. Container의 Service가 비정상인 경우 확인하지 못하며, 이 경우를 대비해 Readness, Liveness 설정이 필요하다.<br>
>
> Readness와 Liveness는 설정방법은 동일하면 적용시점만 다르다.

## 1. Readness, Liveness가 필요한 시점

1. Readness : Pod가 Failed된 후 새로운 Pod가 시작될때 Container는 올라왔지만 Serviced가 Booting되기 직전의 순간
2. Liveness : Pod, Container는 정상이지만 Service가 비정상적인 동작(500 error 등)하는 경우

## 2. 설정 방법

* Exec
* httpGet

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



