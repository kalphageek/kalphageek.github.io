---
layout: single
title: "Springboot Configuration에서 env값 읽기"
categories: springboot
tag: [properties, env]
toc: true
toc_sticky: true
#author_profile: false

---

####  1. application.yml

```yaml
spring:
    datasource:
        username: ${USERNAME}
        password: ${PASSWORD}
```

#### 2. 실행스크립트

```bash
$ cat service-start.sh
#!/bin/bash
USERNAME=${env | grep USER_NAME= | cut -c 11-20}
PASSWORD=${env | grep PWD= | cut -c 5-20}
...
java -jar target/*.jar
```

