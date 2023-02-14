---
layout: single
title: "Springboot Cloud Resilience4J"
categories: springboot
tag: [cloud, resilience4, circuitbreaker, hystrix]
toc: true
toc_sticky: true
#author_profile: false
---



> 호출하는 Local API가 Remote API를 포함하는 경우, Remote API를 호출하는 부분에 CircuitBreaker를 구성하면 Remote API의 실패때문에 Local API까지 실패하는 것을 피할 수 있다<br>이렇게 구성하면 Remot API에서 Exception이 발생하는 경우, 사전 정의된 값으로 Remote API의 return값을 지정할 수 있다

#### 1. pom.xml 설정

```xml
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-circuitbreaker-resilience4j</artifactId>
		</dependency>
```

#### 4. Remote API 호출 코드 수정

```java
public class UserServiceImpl implements UserService {
    @Autowired    
    private CircuitBreakerFactory circuitBreakerFactory;
    
    @Autowired
    private OrderServiceClient orderServiceClient;
    
    /* Circuit Breaker 이용*/
    @Override
    public List<ResponseOrder> getUserByUserId(String userId) {
        CircuitBreaker circuitBreaker = circuitBreakerFactory.create("circuitbreaker");
        
        //getOrders가 에러나면 빈 ArrayList를 반환한다.
        List<ResponseOrder> orderList = circuitBreaker.run(() -> orderServiceClient.getOrders(userId),
                throwable -> new ArrayList<>());
                
        reture orderList;
    }
}
```

