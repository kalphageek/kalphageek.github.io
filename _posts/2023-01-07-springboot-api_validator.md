---
layout: single
title: "Springboot API 입력값 검증 및 에러처리"
categories: springboot
tag: [api, test, validator, errors, webmvctest, isbadrequest, mockmvc, objectmapper, andexpect, requestbody, jsoncomponent]
toc: true
toc_sticky: true
#author_profile: false

---



***<참조> Spring Validation VS Java Bean Validation***

- 다양한 Spring Validation Annotation
- Service 에서도 @Valid 사용할 수 있음
- 사용자정의 제약조건 사용 가능
- Role별로 다른 제약조건 사용 가능

https://velog.io/@rjsdn04111/Spring-Validation-VS-Java-Bean-Validation-%EC%B0%A8%EC%9D%B4-%EA%B7%B8%EB%A6%AC%EA%B3%A0-%EA%B0%81%EA%B0%81%EC%9D%98-%EA%B5%AC%ED%98%84-%EB%B0%A9%EC%8B%9D



## 1. 입력값 에러 처리 및 테스트

### 1) Controller Class

> 1.Method의 파라미터로 @Valid 어노테이션을 사용해서 RequestBody를 받으면, Errors 객체에 검출된 에러가 담겨서 함께 넘어온다 <br>2.사용자의 Validator 에서 Errors 객체에 등록된 rejectValue도 동일하게 hasErrors를 통해 확인할 수 있다.<br>어떤 경우라도 에러가 있으면 ResponseEntity.badRequest()를 리턴한다.

```java
@RestController
public class EventContoller {
    private final EventValidator eventValidator;
    
    @Autowired
    public EventContoller(EventValidator eventValidator) {
        this.eventValidator = eventValidator;
    }
    
	@PostMapping
    public ResponseEntity createEvent(@RequestBody @Valid EventDto eventDto, Errors errors) {
        /* RequestBody에 들어오는 값을 EventDto의 어노테이션에서 자동으로 에러를 검출
           (@NotNull, @NotEmpty, @Min, @Max 등 ...)
        */
        if (errors.hasErrors()) {
            // Errors 객체는 Java빈 표준을 따르지 않기 때문에 ResponseEntity에 담으려면 ErrorsSerializer를 구현해줘야 한다.
            return ResponseEntity.badRequest().body(errors);
        }
        // 별도로 생성한 Validator에서 로직 에러 검증
        eventValidator.validate(eventDto, errors);
        if (errors.hasErrors()) {
            return ResponseEntity.badRequest().body(errors);
        }
    }
}    
```

### 2) Validator Class

> 별도로 빈으로 등록된 Vailidator에서 로직 에러를 체크해서, 에러가 있으면 rejectValue에 등록한다 <br>에러는 Global 또는 Field에 설정될 수 있다. 

``` java
@Component
public class EventValidator {
    public void validate(EventDto eventDto, Errors errors) {
        if (eventDto.getBasePrice() > eventDto.getMaxPrice()) {
            // Global error에 설정
            errors.reject("wrongPrices", "Value of prices is wrong");
        }
        
        LocalDateTime endEventDateTime = eventDto.getEndEventDateTime();
        if (endEventDateTime.isBefore(eventDto.getBeginEventDateTime) {
            // Field error에 설정
            errors.rejectValue("endEventDateTime", "wroneValue");
        }
            
        // TODO
    }
}
```

### 3) Test Class

> status().isBadRequest() 를 통해 Controller에서 리턴한 badRequest를 확인할 수 있다.

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
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$[0].objectName").exists())
            // Global error로 등록된 경우 아래 jsonPath는 깨짐
            .andExpect(jsonPath("$[0].field").exists())
            .andExpect(jsonPath("$[0].code").exists())
            .andExpect(jsonPath("$[0].defaultMessage").exists())
            // Global error로 등록된 경우 아래 jsonPath는 깨짐
            .andExpect(jsonPath("$[0].rejectdValue").exists());
    }
}
```

### 4) ErrorsSerializer Class

> Errors 객체는 Java빈 표준을 따르지 않기 때문에 ResponseEntity에 담으려면 ErrorsSerializer를 구현해줘야 한다.<br>Global / Field error를 모두 Json으로 매핑해줘야 한다<br>ObjectMapper에 ErrorsSerializer를 등록하기 위해서 @JsonComponent를 사용한다 -> Errors를 serialize할 때 ObjectMapper가 ErrorsSerializer를 사용한다
>
> Field Error는 Controller에서 Dto객체를 검증할때 사용한다. 

```java
// ObjectMapper에 ErrorsSerializer를 등록한다
@JsonComponent
public class ErrorsSerializer extends JsonSerializer<Errors> {

    @Override
    public void serialize(Errors errors, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException {
        jsonGenerator.writeStartArray();
        errors.getFieldErrors().stream().forEach(e -> {
            try {
                jsonGenerator.writeStartObject();
                jsonGenerator.writeStringField("objectName", e.getObjectName());
                jsonGenerator.writeStringField("code", e.getCode());
                jsonGenerator.writeStringField("field", e.getField());
                jsonGenerator.writeStringField("defaultMessage", e.getDefaultMessage());

                Object rejectedValue = e.getRejectedValue();
                if (rejectedValue != null) {
                    jsonGenerator.writeStringField("rejectedValue", rejectedValue.toString());
                } else {
                    jsonGenerator.writeStringField("rejectedValue", "");
                }
                jsonGenerator.writeEndObject();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        });
        errors.getGrobalErrors().stream().forEach(e -> {
            try {
                jsonGenerator.writeStartObject();
                jsonGenerator.writeStringField("code", e.getCode());
                jsonGenerator.writeStringField("objectName", e.getObjectName());
                jsonGenerator.writeStringField("defaultMessage", e.getDefaultMessage());
                jsonGenerator.writeEndObject();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        });
        jsonGenerator.writeEndArray();
    }
}
```

