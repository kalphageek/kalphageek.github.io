---
layout: single
title: "Springboot On Cloud Platform"
categories: springboot
tag: [k8s, properties, cloud, platform, kubernetes]
#author_profile: false


---



## Kubernetes

https://github.com/whiteship/demo-springboot23/tree/springboot24-config

* application.properties

> k8s-test.properties는 8s환경에서만 사용된다. local에서는 인식못함

```properties
spring.config.activate.on-cloud-platform=kubernetes
spring.config.import=classpath:k8s-test.properties
```



* k8s-test.properties

```bash
$ cat resources/k8s-test.properties
```

