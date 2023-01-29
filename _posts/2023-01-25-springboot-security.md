---
layout: single
title: "Springboot Security"
categories: springboot
tag: [security, basic, withmockuser, mocmvc]
toc: true
toc_sticky: true
#author_profile: false

---



### * InMemory에 설정된 사용자를 이용한 Security 설정

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

> Spring Security를 Import하면 자동으로 Login 엔드포인트를 제공된다<br>http://localhost:8080/login

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

#### 4. 로그인 제외

```java
@Configuration
public class WebSecurity extends WebSecurityConfigurerAdapter {
    
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        /**
         * http.csrf().disable();
         * CSRF(Cross site Request forgery로 사이트간 위조 요청) protection은 spring security에서 default로 설정된다.
         * 즉, protection을 통해 GET요청을 제외한 상태를 변화시킬 수 있는 POST, PUT, DELETE 요청으로부터 보호한다.
         * rest api를 이용한 서버라면, session 기반 인증과는 다르게 stateless하기 때문에 서버에 인증정보를 보관하지 않는다.
         * rest api에서 client는 권한이 필요한 요청을 하기 위해서는 요청에 필요한 인증 정보를(OAuth2, jwt토큰 등)을 포함시켜야 한다.
         * 따라서 서버에 인증정보를 저장하지 않기 때문에 굳이 불필요한 csrf 코드들을 작성할 필요가 없다.
         */

        http.authorizeRequests()
                .antMatchers("/my/**").authenticated()
                .antMatchers("/**").permitAll();

//        http.csrf().disable();
        http.authorizeRequests().antMatchers("/actuator/**").permitAll();
    }
    
    /**
     * 인증 설정
     * @param auth
     * @throws Exception
     */
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userService).passwordEncoder(passwordEncoder);
    }
}
```

#### 5. PasswordEncoder 설정

```java
@SpringBootApplication
public class UserServiceApplication {
	...
    @Bean
	public BCryptPasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
}
```

