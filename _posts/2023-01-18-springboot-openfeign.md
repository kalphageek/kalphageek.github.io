---
layout: single
title: "Springboot Cloud Openfeign"
categories: springboot
tag: [feign, cloud, feignerrordecoder]
toc: true
toc_sticky: true
#author_profile: false

---



#### 1. Dependency 추가

> Springboot Version에 따라 spring-cloud.version을 맞춰야 한다.

```xml
# pom.xml
	<properties>
		<spring-cloud.version>2020.0.1</spring-cloud.version>
	</properties>
	<properties>
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

#### 2. Enable 설정

> App 전체에 영향을 미치지 않도록 별도의 Configuration 클래스에 적용 가능<br>더불어 ErrorDecode 를 빈으로 등록한다

```java
@Configiration
@EnableFeignClients(basePackages = "me.kalpha.userservice.feign")
public class FeignConfiguration {
    @Bean
    publi FeignErrorDecode decoder() {
        return new FeignErrorDecode();
    }
}
```



#### 3. FeignClient 선언

> @FeignClient의 속성 중 name은 app name을 입력한다. uri로 ip를 설정할 수도 있다.

```java
@FeignClient(name = "order-service", uri = "http://10.20.30.41:8080", configuration = {FeignConfiguration.class})
public interface OrderServiceClient {
    @GetMapping("/order-service/{userId}/orders")
    List<ResponseOrder> getOrders(@PathVariable("userId") String userId);
}
```

#### 4. FeignClient 호출

```java
public class UserServiceImpl {
    @Autowired
    private OrderServiceClient orderServiceClient;

    ...
	/* ErrorDecorder 이용*/
    public List<ResponseOrder> getOrders(userId) {}
        List<ResponseOrder> orderList=orderServiceClient.getOrders(userId);
		return orderList;
	}
}
```

#### 5. Logging

> 설정하는것 만으로 충분한 log를 확인할 수 있다.

```yaml
# application.yml
# 3. Interface가 선언된 위치
logging:
    level:
        me.kalpha.userservice.feign.client: DEBUG
```

```java
public class FeignConfiguration {
    ...
        
    @Bean
	public Logger.Level getFeignLoggerLevel() {
		return Logger.Level.FULL;
}
```

#### 6. Exception 처리

> FeginException을 직접사용해서 try catch하는 것이 아니라, FeignErrorDecorder를 활용해서 에러처리.

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

#### 기타 2. (부록) Spring Cloud 와 Boot 의 Version 궁합

> 아래 링크의 하단에 버전의 궁합을 표시하고 있습니다.

| Release Train        | Boot Version                          |
| -------------------- | ------------------------------------- |
| 2021.0.x aka Jubilee | 2.6.x, 2.7.x (Starting with 2021.0.3) |
| 2020.0.x aka Ilford  | 2.4.x, 2.5.x (Starting with 2020.0.3) |
| Hoxton               | 2.2.x, 2.3.x (Starting with SR5)      |

