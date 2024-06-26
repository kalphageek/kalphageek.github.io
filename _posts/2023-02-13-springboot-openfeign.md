---
layout: single
title: "Springboot Cloud Openfeign"
categories: springboot
tag: [feign, cloud, feignerrordecode, uri, configuration, exception, hoxton, dynamic-url]
toc: true
toc_sticky: true
#author_profile: false

---



> Openfeign의 ErrorDecoder를 이용해서 Exception을 처리한다.

#### 1. pom.xml 설정

> Springboot Version에 따라 spring-cloud.version을 맞춰야 한다.

```xml
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>2.4.2</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>

	<properties>
		<java.version>11</java.version>
		<spring-cloud.version>2020.0.1</spring-cloud.version>
	</properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
    </dependencies>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
```

#### (참조) Spring Cloud 와 Boot 의 Version 호환

> 아래 링크의 하단에 버전의 호환여부를 확인해야 한다.

| Release Train        | Boot Version                          |
| -------------------- | ------------------------------------- |
| 2021.0.x aka Jubilee | 2.6.x, 2.7.x (Starting with 2021.0.3) |
| 2020.0.x aka Ilford  | 2.4.x, 2.5.x (Starting with 2020.0.3) |
| Hoxton               | 2.2.x, 2.3.x (Starting with SR5)      |

#### 2. Enable 설정

> App 전체에 영향을 미치지 않도록 별도의 Configuration 클래스에 적용

```java
@Configiration
@EnableFeignClients(basePackages = "me.kalpha.userservice.feign")
public class FeignConfiguration {
    ...
}
```

#### 3. Remote API Interface 선언

> @FeignClient의 속성 중 name은 app name을 입력한다. url로 host를 설정할 수도 있다.

```java
@FeignClient(name = "order-service", url = "http://10.20.30.41:8080", configuration = {FeignConfiguration.class})
public interface OrderServiceClient {
    @GetMapping("/order-service/{userId}/orders")
    List<ResponseOrder> getOrders(@PathVariable("userId") String userId);
}
```

#### 4. Remote API 호출

```java
public class UserServiceImpl implements UserService {
    @Autowired
    private OrderServiceClient orderServiceClient;

    /* ErrorDecorder 이용*/
    public List<ResponseOrder> getOrders(userId) {
        List<ResponseOrder> orderList=orderServiceClient.getOrders(userId);
        return orderList;
    }
}
```

#### 5. Logging

> 설정하는것 만으로 충분한 log를 확인할 수 있다.

```java
public class FeignConfiguration {
    ...
        
    @Bean
    public Logger.Level getFeignLoggerLevel() {
        return Logger.Level.FULL;
    }
}
```

#### 6. Exception 처리

> FeginException을 직접사    용해서 try catch하는 것이 아니라, FeignErrorDecorder를 활용해서 에러처리.

```java
@Component
public class FeignErrorDecoder implements ErrorDecoder {
    @Override
    public Exception decode(String methodKey, Response response) {
        switch (response.status()) {
            case 400:
                break;
            case 404:
                if (methodKey.contains("getOrders")) {
                    return new ResponseStatusException(HttpStatus.valueOf(response.status()),
                            "User's order is empty");
                }
                break;
            default:
                return new Exception(response.reason());
        }
        return null;
    }
}    
```

```java
public class FeignConfiguration {
    ...
        
    @Bean
    public FeignErrorDecode getFeignErrorDecode() {
        return new FeignErrorDecode();
    }
}
```

#### 기타 1. Url을 동적으로 받도록 수정하기

> Url을 동적으로 받아서 호출시점에 할당할 수 있다 (어노테이션의 url파라미터는 의미 없음)

```java
// FeignClient 선언
@FeignClient(name = "order-service", url = "dynamic-url", configuration = {FeignConfiguration.class})
public interface OrderServiceClient {
    @GetMapping("/order-service/{userId}/orders")
    List<ResponseOrder> getOrders(URI uri, @PathVariable("userId") String userId);
}

// FeignClient 호출
public class UserServiceImpl {}
    @Autowired
    private OrderServiceClient orderServiceClient;

    ...
    public List<ResponseOrder> getOrders(baseUrl, userId) {}
        URI uri = new URI(("http://"+baseUrl+":8080"));
        List<ResponseOrder> orderList=orderServiceClient.getOrders(uri, userId);
        return orderList;
    }
}
```

#### 기타 2. Sprinboot 2.2 / 2.3에서 사용

> spring.boot과 spring-cloud, openfeign의 version을 맞춰야 한다.

```xml
    <properties>
        <spring.boot.version>2.3.1.RELEASE</spring.boot.version>
        <spring-cloud.version>Hoxton.SR12</spring-cloud.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
            <version>2.2.9.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-cirbuitbreaker-resilience4j</artifactId>
            <version>1.0.6.RELEASE</version>
        </dependency>
    </dependencies>
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
```

