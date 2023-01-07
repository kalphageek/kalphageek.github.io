---
layout: single
title: "Springboot Bean 설정 방법"
categories: springboot
tag: [bean, setup]
toc: true
toc_sticky: true
#author_profile: false

---



## 1. Bean 설정 파일 이용

> Bean설정파일을 이용해서 임의의 Class를 Bean을 지정하려면, Dependency Injection에 의해 IoC Container에 Bean으로 등록되게 된다

```java
// Bean Class
public class SampleComponent {
    
}

---
// Bean 설정 - Configuration과 Bean 어노테이션을 둘다 써야 한다..
@Configuration
public class SampleConfig {
    @Bean
    public SampleComponent sampleComponent() {
        return new SampleComponent();
    }
}

---
// Bean 설정 여부 테스트
@SpingBootTest
public class SampleComponentTest {
	@Autowired
    ApplicationContext context;
    
    @Test
    public void testDI() {
        SampleComponent bean = context.getBean(SampleController.class)
        assertIsNotNull(bean);
    }
}    
```

