---
layout: single
title: "Springboot K8S Readness/Liveness 연동"
categories: springboot
tag: [k8s, readness, liveness, link]
toc: true
toc_sticky: true
#author_profile: false

---



## 1. 설정 방법

> K8S의 [readness, liveness]({{http://kalphageek.github.io}}{% link _posts/2022-11-26-k8s-readness_liveness.md %}) 적용은 Springboot의 Actuator 기능으로 구현가능하며, 아래와 같은 설정이 필요하다

* Dependencies

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

* application.properties

```properties
management.endpoint.health.probes.enabled=true
```

* YAML

> Container에 livenessProbe, readinessProbe 정의한다
>
> 1. initialDelaySeconds: 10 - 시작하고 10초 후 연결
> 2. periodSeconds: 3 - 3초 마다 연결
> 3. failureThreshold: 2 - 2회 실패하면 Pod재생성

```json
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-demo
spec:
  selector:
    matchLabels:
      app: app-demo
  replicas: 3
  template:
    metadata:
      labels:
        app: app-demo
    spec:
      containers:
        - name: app-demo
          image: demo-springboot23:0.0.1-SNAPSHOT
          ports:
            - containerPort: 8080
          livenessProbe:
            httpGet:
              port: 8080
              path: /actuator/health/liveness
            initialDelaySeconds: 10
            periodSeconds: 3
            failureThreshold: 2
          readinessProbe:
            httpGet:
              port: 8080
              path: /actuator/health/readiness
            initialDelaySeconds: 10
            periodSeconds: 3
---
apiVersion: v1
kind: Service
metadata:
  name:  app-demo
spec:
  selector:
    app:  app-demo
  type:  LoadBalancer
  ports:
    - port: 8080
      targetPort: 8080
```

