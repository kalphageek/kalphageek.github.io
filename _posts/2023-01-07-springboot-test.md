---
layout: single
title: "Springboot Test"
categories: springboot
tag: [webmvctest, test, mockmvc, webmvctest, objectmapper, andexpect, mockbean, perform, jsonpath, mockito, displayname]
toc: true
toc_sticky: true
#author_profile: false

---



## 1. 슬라이스 테스트

### 1) Create Test Example

* application-test.propertiess

```properties
spring.datasource.username=sa
spring.datasource.password=
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driver-class-name=org.h2.Driver

spring.datasource.hikari.jdbc-url=jdbc:h2:mem:testdb
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.H2Dialect
```

* Test Class

```java
//test Profiles 사용하기;
@ActiveProfiles("test")
@WebMvcTest
public class EventControllerTest {
    @Autowired
    MockMvc mockMvc;

    @Autowird 	
    // Object를 JacksonJson을 이용해 JSON형태로 변경해준다
    ObjectMapper objectMapper;

    @MockBean
    EventRepository eventRepository;

    @Test
    @DisplayName("Event Create 테스트")
    public void createTest() {
        // Given
        Event event = Event.build()
            ...
            build();

        // 가상객체라 ID가 자동으로 생성되지 않아서 수동으로 등록해야한다
        event.setId(10);
        // eventRepository.save(event)가 호출되면 event를 리턴하라
        Mockito.when(eventRepository.save(event)).thenReturn(event);

        // When & Then
        mockMvc.perform(post("/api/events")
                       .contentType(MediaType.APPLICATION_JSON)
                       .accept(MediaTypes.HAL_JSON)
                       .content(objectMapper.writeValueAsString(event)))
            .andDo(print())
            .andExpect(status().isCreated())
            // print()을 통해 Console로 output되는 JSON을 볼 수 있다.
            .andExpect(jsonPath("id").exists())
            .andExpect(jsonPath("free").value(false))
            .andExpect(jsonPath("content[0].objectName").exists())
            // header 테스트
            .andExpect(header().exists(HttpHeaders.LOCATION));
            .andExpect(header().string("Content-Type", "application/hal+json;charset=UTF-8")) // 아래줄과 동일 의미
            .andExpect(header().string(HttpHeaders.CONTENT_TYPE, HttpHeaders.HAL_JSON_VALUES));
    }
}
```



### 2) @WebMvcTest

> Web관련 빈만 등록하며, MockMvc 빈을 자동 등록해준다.



### 3) MockMvc

> MVC 테스트의 핵심클래스. 웹서버를 구동하지 않고 MVC (Dispatch Servlet) 요청을 처리하는 과정을 확인할 수 있도록 해준다<br>@WebMvcTest (Web테스트), @SpringBootTest (Application테스트)



### 4) @MockBean

> Mockito를 이용해 mock(가상) 객체를 만들고 빈으로 등록해준다 <br>(주의) 기존빈을 테스트용 빈이 대체한다



### 5) @DisplayName

> Test Method의 설명을 Name으로 보여준다