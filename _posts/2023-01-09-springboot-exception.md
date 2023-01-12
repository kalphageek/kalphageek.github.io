---
layout: single
title: "Springboot Exception"
categories: springboot
tag: [advice, controlleradvice, restcontrolleradvice, exceptionhandler]
toc: true
toc_sticky: true
#author_profile: false

---



## 1. ExceptionHandler 우선 순위

### 1) Controller내부 Exception 처리

> hello Method에서 [Exception타입] Exception이 발생하면, @ExceptionHandler(value = [Exception타입]) 어노테이션에서 처리한다.<br>Controller내부의 @ExceptionHandler가 전역 @ExceptionAdvice 보다 우선해서 처리된다.

* Sample Code

```java
public class HelloController {
    @GetMapping("/hello")
    public void hello() throws Exception {
        throw new Exception();
    }

    @ExceptionHandler(value = Exception.class)
    public ResponseEntity<Map<String, String>> ExceptionHandler(Exception e) {
        HttpHeaders responseHeaders = new HttpHeaders();
        //responseHeaders.add(HttpHeaders.CONTENT_TYPE, "application/json");
        HttpStatus httpStatus = HttpStatus.BAD_REQUEST;

        log.info(e.getMessage());
        log.info("Controller내 ExceptionHandler 호출")

        Map<String, String> map = new Hashap();
        map.put("error Type", httpStatus.getReasonPhrase());
        map.put("code", "400");
        map.put("message", "예외 발생");

        return new ResponseEntity<>(map, responseHeaders, httpStatus);
    }
}
```

### 2) 별도 클래스 Exception Handler

> @RestControllerAdvice를 별도의 클래스로 정의할 수 있다

* Sample Code

```java
@RestControllerAdvice
public class EventExceptionHandler {
    private final Logger log = LoggerFactory.getLogger(ExceptionHandler.class);
    
    @ExceptionHandler(value = Exception.class)
    public ResponseEntity<Map<String, String>> ExceptionHandler(Exception e) {
        HttpHeaders responseHeaders = new HttpHeaders();
        HttpStatus httpStatus = HttpStatus.BAD_REQUEST;

        log.info(e.getMessage());
        log.info("Advice내 ExceptionHandler 호출")

        Map<String, String> map = new Hashap();
        map.put("error Type", httpStatus.getReasonPhrase());
        map.put("code", "400");
        map.put("message", "예외 발생");

        return new ResponseEntity<>(map, responseHeaders, httpStatus);
    }
}
```



## 2. Advice

### 1) @ControllerAdvice, @RestControllerAdvice 

* 발생하는 예외를 한곳에서 관리하고 처리할 수 있게 하는 어노테이션
* 설정을 통해 범위 지정 가능

```java
// 예외발생 시 json형태로 결과를 반환한다 
@RestControllerAdvice(basePackages = "me.kalpha.event")
```
