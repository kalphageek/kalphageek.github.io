---
layout: single
title: "Springboot K8S configMap 연동"
categories: springboot
tag: [k8s, configmap]
#author_profile: false

---



## 1. 설정방법

https://github.com/whiteship/demo-springboot23/tree/springboot24

* configmap.yaml

> k8s-configmap이름으로 ConfigMap 생성.<br>그  ConfigMap의 파일이름은 application.properties 이고,  내용은 "my.message: hello kubernetes" .

```json
apiVersion: v1
kind: ConfigMap
metadata:
  name: k8s-configmap
data:
  application.properties: |
    my.message: hello kubernetes
```



* apps.yaml

> Deployment와 Service 생성. Pod는 3개.<br>여기에 각각  사전 생성된 k8s-configmap라는 ConfigMap을 Volume으로 정의하고  /etc/config 경로에 mount한다

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
      volumes:
        - name: k8s-configmap-volume
          configMap:
            name: k8s-configmap
      containers:
        - name: app-demo
          image: demo-springboot23:0.0.1-SNAPSHOT
          volumeMounts:
            - mountPath: /etc/config
              name: k8s-configmap-volume
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



* application.properties

> optional keyword는 해당 값이 없어도 동작하도록 한다<br>/etc/config/아래의 application[-profile].properties 파일을 읽어라는 의미 (optional)<br>K8S 환경에서만 정확하게 동작한다 

```properties
spring.config.import=optional:/etc/config/
```



* MyProperties.java

> applicaiton.properties를 읽어 들인다

```java
@ConstructorBinding
@ConfigurationProperties("my")
public class MyProperties {

    private String message;

    public MyProperties(String message) {
        this.message = message;
    }

    public String getMessage() {
        return message;
    }
}
```



* HelloController.java

> MyProperties 정보를 사용한다

```java
@RestController
public class HelloController {

    @Autowired
    ApplicationAvailability availability;

    // Host정보
    @Autowired
    LocalHostService localHostService;

    @Autowired
    MyProperties myProperties;

    @GetMapping("/hello")
    public String hello() {
        return "Application is now " + availability.getLivenessState()
                + " " + availability.getReadinessState()
                + " " + localHostService.getLocalHostInfo()
                + " " + myProperties.getMessage();
    }

}
```



## 2. 확인

```bash
$ kubectl apply -f configmap.yaml
$ kubectl apply -f apps.yaml
$ # app 실행
# service 확인 (localhost:8080에 서비스 기동)
$ kubectl get service
$ kubectl get pods # Pod 이름 확인
$ kubectl exec --stdin --tty [Pod 이름] -- /bin/bash
$ cat /etc/config/application.properties
```



