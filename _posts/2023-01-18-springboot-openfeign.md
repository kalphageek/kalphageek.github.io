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

```java
@EnableFeignClients
public class UserServiceApplication {    
}
```

#### 3. Interface 선언

> @FeignClient의 속성 중 name은 app name을 입력한다. uri로 ip를 설정할 수도 있다.

```java
@FeignClient(name = "order-service", uri = "http://10.20.30.41:8080")
public interface OrderServiceClient {
    @GetMapping("/order-service/{userId}/orders")
    List<ResponseOrder> getOrders(@PathVariable String userId);
}
```

#### 4. Method 호출

```java
@Autowired
private OrderServiceClient orderServiceClient;
...
/* ErrorDecorder 이용*/
List<ResponseOrder> orderList=orderServiceClient.getOrders(userId);
```

#### 5. Logging

> 설정하는것 만으로 충분한 log를 확인할 수 있다.

```yaml
# application.yml
# 3. Interface가 선언된 위치
logging:
    level:
        me.kalpha.userservice.client: DEBUG
```

```java
public class UserServiceApplication {
    @Bean
	public Logger.Level getFeignLoggerrLevel() {
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

