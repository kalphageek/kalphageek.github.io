---
layout: single
title: "Springboot Security"
categories: springboot
tag: [security, basic, withmockuser, mocmvc]
toc: true
toc_sticky: true
#author_profile: false

---



#### 1. Basic Authentication 활성화

* pom.xml

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<!-- @Test에서 @WithMockUser를 사용하기 위한 라이브러리 -->
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-test</artifactId>
    <version>${spring-security.version}</version>
    <scope>test</scope>
</dependency>

```

#### 2. 기본 사용자 생성

> 기본제공된 UserDetailsServiceAutoConfiguration클래스가 InMemoryUserDetailsManager 메소드를 이용해 제공하는 기능이다.<br>properties를 설정하지 않으면 "user"라는 이름의 User를 자동으로 제공한다. (패스워드는 Console에서 확인 할 수 있다)

* Application.yml

```yaml
spring:
	security:
		user:
			name:
			password:
```

#### 3. 인증 테스트

> @WithMockUser 어노테이션을 통해 가짜 User를 인증정보로 제공할 수 있다

```java
@Test
@WithMockUser
public void my() throws Exception {
    mocMvc.perform(get("/my"))
        .andDo(print())
        .andExpect(status().isOk())
}

@Test
public void my_without_user() throws Exception {
    mocMvc.perform(get("/my"))
        .andDo(print())
        .andExpect(status().isUnauthorized())
}
```

