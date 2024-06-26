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

> default Profiles가 적용 된다. 운영서버에 적용할 수 있다

* H2 운영DB 설정
  * H2 Download (https://h2database.com/html/main.html)
  * 파일생성 및 H2 실행

```bash
$ cd ~/workspace/h2/
$ mkdir data
$ touch data/querydsl.mv.db
$ chmod 755 bin/h2.sh
$ bin/h2.sh # Web Browser 자동실행
```

* main/resources/application.yml

```json
server:
  port: 8080

spring:
  datasource:
    url: jdbc:h2:tcp://localhost/~/workspace/h2/data/querydsl
    username: sa
    password:
    driver-class-name: org.h2.Driver
  jpa:하기 위한 용도로 사용할 수 있다. h2를 이용해 초기데이터를 생성해서 사용할 수 있다.
    hibernate:
      ddl-auto: validate
    database-platform: org.hibernate.dialect.H2Dialect

logging.level:
  org.hibernate.SQL: info
```



### 2. Local Profile 설정

> 운영서버의 설정을 변경하지 않고, 개발검증을 위한 용도로 PC에 DB등 실행 환경을 설정할 수 있다.

* IntelliJ IDEA 설정

  > Edit Configurations -> Build and run -> VM Option란에 **-Dspring.profiles.active=local** 설정

* H2 Local DB 설정

  * 파일생성

```bash
$ cd ~/workspace/h2
$ touch data/local.mv.db
```

* main/resources/application-local.yml

```json
server:
  port: 8081

spring:
  datasource:
    url: jdbc:h2:tcp://localhost/~/workspace/h2/data/local
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

* 적용 클래스

> Local 환경에서 사용할 클래스에 @Profile("local") 적용. 

```java
@Profile("local")
public class InitMember {
    ...
}

/**
 * 사용 사례 :
 * Local환경에서만 실행되는 테스트용 데이터를 생성하는 코드.
 */
@Profile("local")
@RequiredArgsConstructor
@Component
public class InitMember {
    private final InitMemberService initMemberService;

    @PostConstruct
    public void init() {
        initMemberService.init();
    }

    @Component
    static class InitMemberService {
        @PersistenceContext
        private EntityManager em;

        @Transactional
        public void init() {
            Team teamA = new Team("teamA");
            Team teamB = new Team("teamB");
            em.persist(teamA);
            em.persist(teamB);

            for(int i=0; i < 100; i++) {
                Team selectedTeam = i % 2 == 0 ? teamA : teamB;
                em.persist(new Member("member"+i, i, selectedTeam));
            }
        }
    }
}

```



### 3. Test Profile 설정

> Junit 테스트를 위해 Memory DB를 사용한다

* test/resources/application.yml

```json
# H2 설정 예제
spring:
  profiles:
    active: test
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
