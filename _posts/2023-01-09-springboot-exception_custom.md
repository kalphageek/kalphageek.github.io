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
    public static String RESPONSE_MESSAGE = "responseMessage";
    public static String ERROR_MESSAGE = "errorMessage";
    public static String ERROR_CODE = "errorCode";
    public static String ERROR_TYPE = "errorType";

    public enum ExceptionClass {
        HANDLED("Handled"), UNHANDLED("Unhandled");

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

public class CMDException extends Exception {

    private static final long serialVersionUID = 4663380430591151694L;

    private Constants.ExceptionClass exceptionClass;
    private HttpStatus httpStatus;

    public CMDException(Constants.ExceptionClass exceptionClass, HttpStatus httpStatus,
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
public class GlobalExceptionHandler {
    private final Logger log = LoggerFactory.getLogger(this.getClass());

    @ExceptionHandler(Exception.class)
    protected ResponseEntity<Map(String,String)> unhandledException(Exception e) {
        HttpHeaders httpHeaders = new HttpHeaders();
        HttpStatus httpStatus = HttpStatus.BAD_REQUEST;

        Map<String, String> map = new HashMap<>();
        map.put(Constants.ERROR_TYPE, httpStatus.getReasonPhrase());
        map.put(Constants.ERROR_CODE, "400");
        map.put(Constants.ERROR_MESSAGE, e.getMessage());
        log.error("Unhandled Exception 발생 : {}, {}", httpStatus.getReasonPhrase(), e.getMessage());

        return new ResponseEntity<>(map, httpHeaders, httpStatus);
    }

    @ExceptionHandler(CMDException.class)
    protected ResponseEntity<Map(String,String)> customException(CMDException e) {
        HttpHeaders httpHeaders = new HttpHeaders();

        Map<String, String> map = new HashMap<>();
        map.put(Constants.ERROR_TYPE, e.getHttpStatusType());
        map.put(Constants.ERROR_CODE, Integer.toString(e.getHttpStatusCode()));
        map.put(Constants.ERROR_MESSAGE, e.getMessage());
        log.error("Handled Exception 발생 : {}, {}", e.getHttpStatusType(), e.getMessage());

        return new ResponseEntity<>(map, httpHeaders, e.getHttpStatus());
    }
}

```



## 4. Test 코드

```java
@Test
public void exceptionTest() throws CMDException {
    throw new CMDException(ExceptionClass.HANDLED, HttpStatus.BAD_REQUEST, "의도한 에러가 발생했습니다.");
}
```

