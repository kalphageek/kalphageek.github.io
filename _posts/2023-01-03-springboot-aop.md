---
layout: single
title: "Springboot AOP"
categories: springboot
tag: [aop, proxy, aspect, stopwatch, around]
toc: true
toc_sticky: true
#author_profile: false

---



> AOP를 이용해 Method의 실행시간을 측정해서 Log로 출력하는 Annotation 만들기

### 1) Annotation 선언

```java
@Target(ElementType.METHOD)  // Method에 적용한다
@Retention(RetentionPolicy.RUNTIME)  // Runtime동안 적용한다
public @interface LogExecutionTime {
}
```



### 2) Aspect 적용

```java
@Component
@Aspect
public class LogAspect {
    //Slf4j Logger 생성
    Logger logger = LoggerFactory.getLogger(LogAspect.class);
    
    @Around("@annotation(LogExecutionTime)")
    public Object logExecutionTime(ProceedingJoinPoint jointPoint) throws Throwable {
        StopWatch stopWatch = new StopWatch();
        stopWatch.start();
        
        Object proceed = jointPoint.prceed();
        
        stopWatch.stop();
        logger.info(stopWatch.prettyPrint());
        
        return proceed;
    }
    
}
```



### 3) 테스트 코드

```java
public class LogAspectTest() {
    @Test
    @LogExecutionTime
    public void aspectTest() {
        System.out.println("테스트");
    }
}
```



### * Advice 적용 포맷

```java
@Component
@Aspect
public class LogAspect {
    
    /* 업무코드 */
    
    // @Around를 적용하면 ProceedingJointPoint를 받을 수 있다. jointPoint는 LogExecutionTime Annotation이 적용된 Method를 가리킨다
    @Around("@annotation(LogExecutionTime)")
    public Object logExecutionTime(ProceedingJoinPoint jointPoint) throws Throwable {
        
        /* 업무코드 */        
        
        Object proceed = jointPoint.prceed();
        
        /* 업무코드 */    
        
        return proceed;
    }
    
}
```

