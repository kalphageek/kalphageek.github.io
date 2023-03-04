---
layout: single
title: "Springboot Profiles 설정"
categories: springboot
tag: [profiles, test, local, default, h2, application.yml]
toc: true
toc_sticky: true
#author_profile: false

---



### 1. Default Profile 설정

> default Profiles가 적용 된다.

* main/resources/application.yml

```json
# H2 설정 예제
spring:
  datasource:
    url: jdbc:h2:tcp://localhost/~/workspace/h2/data
    username: sa
    password:
    driver-class-name: org.h2.Driver

  jpa:
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        format_sql: true
    database-platform: org.hibernate.dialect.H2Dialect

logging.level:
  org.hibernate.SQL: info
```



### 2. Local Profile 설정

> 개발검증을 위해 초기데이터를 생성하는 등의 경우에 사용할 수 있다.

* IntelliJ IDEA 설정

  > Edit Configurations -> Build and run -> VM Option란에 **-Dspring.profiles.active=local** 설정

* main/resources/application-local.yml

```json
# H2 설정 예제
spring:
  datasource:
    url: jdbc:h2:tcp://localhost/~/workspace/h2/data/querydsl
    username: sa
    password:
    driver-class-name: org.h2.Driver

  jpa:
    hibernate:
      ddl-auto: create
    properties:
      hibernate:
        format_sql: true
    database-platform: org.hibernate.dialect.H2Dialect

logging.level:
  org.hibernate.SQL: trace
```

* Local에 H2 운영DB 설정
  * H2 Download (https://h2database.com/html/main.html)
  * 파일생성 및 H2 실행

```bash
$ cd ~/workspace/h2/
$ mkdir data
$ touch data/querydsl.mv.db
$ chmod 755 bin/h2.sh
$ bin/h2.sh # Web Browser 자동실행
```

* 적용 클래스

> Local 환경에서 사용할 클래스에 @Profile("local") 적용. 

```java
@Profile("local")
public class InitMember {
    ...
}
```



### 3. Test Profile 설정

> Junit 테스트를 위해 사용한다

* test/resources/application-test.yml

```json
# H2 설정 예제
spring:
  datasource:
    username: sa
    password:
    url: jdbc:h2:mem:testdb
    driver-class-name: org.h2.Driver

  jpa:
    hibernate:
      ddl-auto: create
    properties:
      hibernate:
        format_sql: true
    database-platform: org.hibernate.dialect.H2Dialect

logging:
  level:
    org:
      hibernate:
        SQL: DEBUG
        type.descriptor.sql.BasicBinder: TRACE
```

* 테스트 클래스

> Test Class에 @ActiveProfiles("test") 추가한다

```java
@ActiveProfiles("test")
class MemberTest {
    ...
}
```

