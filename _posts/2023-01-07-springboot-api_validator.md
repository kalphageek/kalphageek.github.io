---
layout: single
title: "Springboot API 입력값 검증 및 에러처리"
categories: springboot
tag: [api, test, validator, errors, webmvctest, isbadrequest, mockmvc, objectmapper, andexpect, requestbody]
toc: true
toc_sticky: true
#author_profile: false

---



### 1. 입력값 에러 처리 및 테스트

* Controller Class

```java
@RestController
public class EventContoller {
    private final EventValidator eventValidator;
    
    @Autowired
    public EventContoller(EventValidator eventValidator) {
        this.eventValidator = eventValidator;
    }
    
	@PostMapping
    public ResponseEntity createEvent(//test Profiles 사용하기;@RequestBody @Valid EventDto eventDto, Errors errors) {
        /* RequestBody에 들어오는 값을 EventDto의 어노테이션에서 자동으로 에러를 검출
           (@NotNull, @NotEmpty, @Min, @Max 등 ...)
        */
        if (errors.hasErrors()) {
            return ResponseEntity.badRequest().build();
        }
        // 별도로 생성한 Validator에서 로직 에러 검증
        eventValidator.validate(eventDto, errors);
        if (errors.hasErrors()) {
            return ResponseEntity.badRequest().build();
        }
    }
}    
```

* Validator Class

``` java
@Component
public class EventValidator {
    public void validate(EventDto eventDto, Errors errors) {
        LocalDateTime endEventDateTime = eventDto.getEndEventDateTime();
        if (endEventDateTime.isBefore(eventDto.getBeginEventDateTime) {
            errors.rejectValue("endEventDateTime", "wroneValue");
        }
            
        // TODO
    }
}
```

* Test Class

```java
@ActiveProfiles("test")
@WebMvcTest
public class EventControllerTest {
    @Autowired
    MockMvc mockMvc;

    @Autowird 	
    ObjectMapper objectMapper;

    @Test
    public void createTest_isBadRequest() {
        // Given
        EventDto eventDto = Event.build()
            .beginEventDateTime(2020, 11, 20)
            .endEventDateTime(2020, 11, 18)
            ...
            build();

        // When & Then
        mockMvc.perform(post("/api/events")
                       .contentType(MediaType.APPLICATION_JSON)
                       .content(objectMapper.writeValueAsString(eventDto)))
            .andDo(print())
            .andExpect(status().isBadRequest());
    }
}
```

