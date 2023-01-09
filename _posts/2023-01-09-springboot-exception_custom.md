---
layout: single
title: "Springboot Custorm Exception"
categories: springboot
tag: [advice, datahubexception, restcontrolleradvice, exceptionhandler, constants]
toc: true
toc_sticky: true
#author_profile: false

---



## 1. Exception Type 정의

```java
package common;

public class Constants {
    public enum ExceptionClass {
        PRODUCT("Product"), SIGN("Sign");
        
        private String exceptionClass;

        ExceptionClass(String exceptionClass) {
            this.exceptionClass = exceptionClass;
        }

        public String getExceptionClass() {
            return exceptionClass;
        }

        @Override
        public String toString() {
            return getExceptionClass() + " Exception.";
        }
    }
}
```



## 2. Custom Exception 정의

```java
package common.exception;

public class DatahubException extends Exception {

    private static final long serialVersionUID = 4663380430591151694L;

    private Constants.ExceptionClass exceptionClass;
    private HttpStatus httpStatus;

    public DatahubException(Constants.ExceptionClass exceptionClass, HttpStatus httpStatus,
        String message) {
        super(exceptionClass.toString() + message);
        this.exceptionClass = exceptionClass;
        this.httpStatus = httpStatus;
    }

    public Constants.ExceptionClass getExceptionClass() {
        return exceptionClass;
    }

    public int getHttpStatusCode() {
        return httpStatus.value();
    }

    public String getHttpStatusType() {
        return httpStatus.getReasonPhrase();
    }

    public HttpStatus getHttpStatus() {
        return httpStatus;
    }

}
```



## 3. Exception Handler 정의

```java
package common.exception;

@RestControllerAdvice
public class DatahubExceptionHandler {

    private final Logger log = LoggerFactory.getLogger(DatahubExceptionHandler.class);

    @ExceptionHandler(value = Exception.class)
    public ResponsPeEntity<Map<String, String>> ExceptionHandler(Exception e) {
        HttpHeaders responseHeaders = new HttpHeaders();
        //responseHeaders.add(HttpHeaders.CONTENT_TYPE, "application/json");
        HttpStatus httpStatus = HttpStatus.BAD_REQUEST;

        log.error("Advice 내 ExceptionHandler 호출, {}, {}", e.getCause(), e.getMessage());

        Map<String, String> map = new HashMap<>();
        map.put("error type", httpStatus.getReasonPhrase());
        map.put("code", "400");
        map.put("message", "에러 발생");

        return new ResponseEntity<>(map, responseHeaders, httpStatus);
    }

    @ExceptionHandler(value = DatahubException.class)
    public ResponseEntity<Map<String, String>> ExceptionHandler(DatahubException e) {
        HttpHeaders responseHeaders = new HttpHeaders();

        Map<String, String> map = new HashMap<>();
        map.put("error type", e.getHttpStatusType());
        map.put("error code",
            Integer.toString(e.getHttpStatusCode())); // Map<String, Object>로 설정하면 toString 불필요
        map.put("message", e.getMessage());

        return new ResponseEntity<>(map, responseHeaders, e.getHttpStatus());
    }

}
```



## 4. Test 코드

```java
@Test
public void exceptionTest() throws DatahubException {
    throw new DatahubException(ExceptionClass.PRODUCT, HttpStatus.BAD_REQUEST, "의도한 에러가 발생했습니다.");
}
```

