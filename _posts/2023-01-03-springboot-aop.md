---
layout: single
title: "Springboot AOP"
categories: springboot
tag: [aop, proxy, aspect, stopwatch, around, annotation, execution]
toc: true
toc_sticky: true
#author_profile: false

---



## 1. 특정 어노테이션에 적용하는 AOP

> AOP를 이용해 Method의 실행시간을 측정해서 Log로 출력하는 AOP 만들기<br>어노테이션을 사용하거나, Package 적용범위를 설정한 후 일괄 적용 할 수 있다.

### 1) 어노테이션 선언

```java
@Target(ElementType.METHOD)  // Method에 적용한다
@Retention(RetentionPolicy.RUNTIME)  // Runtime동안 적용한다
public @interface LogExecutionTime {
}
```

### 2) AOP Class

```java
@Component
@Aspect
public class StopWatchAOP {
    //Slf4j Logger 생성
    Logger logger = LoggerFactory.getLogger(LogAspect.class);
    
    @Around("@annotation(LogExecutionTime)") //@LogExecutionTime이 설정된 메소드에 적용하라
    public Object execute(ProceedingJoinPoint jointPoint) throws Throwable {
        StopWatch stopWatch = new StopWatch();
        stopWatch.start();
        
        try {
        	 return jointPoint.prceed();
        } finally {            
        	stopWatch.stop();
        	logger.info(stopWatch.prettyPrint());
        }
    }
    
}
```

### 3) Test Class

```java
public class StopWatchAOPTest() {
    @Test
    @LogExecutionTime
    public void aspectTest() {
        System.out.println("테스트");
    }
}
```

### * Aspect 적용 템플릿

> @Around를 적용하면 ProceedingJointPoint를 받을 수 있다. jointPoint는 LogExecutionTime Annotation이 적용된 Method를 가리킨다

```java
@Component
@Aspect
public class AOP {
    /* 업무코드 */
    @Around("execution(* me.kalpha.event..*(..))") 
    public Object execute(ProceedingJoinPoint jointPoint) throws Throwable {
        /* 업무코드 */    
        try {
            return jointPoint.prceed();   
        } finally {
            /* 업무코드 */    
        }
    }
    
}
```



## 2. Package Path와 Method Parameter의 패턴에 따른 AOP 적용

### 1) AOP Class

```java
@Component
@Aspect
public class TimeTraceAOP {
    //Slf4j Logger 생성
    Logger logger = LoggerFactory.getLogger(TimeTraceAspect.class);
    
    @Around("execution(* me.kalpha.event..*(..))") 
    public Object execute(ProceedingJoinPoint jointPoint) throws Throwable {
        long start = System.currentTimeMillis();
        logger.info("START: " + jointPoint.toString())
        
        try {
            return jointPoint.prceed();
        } finally {
            long finish = System.currentTimeMillis();
            long ms = finish - start;
            logger.info("END: " + jointPoint.toString() + " " + ms + "ms");
        }
    }
    
}
```

### * Aspect 적용 템플릿

> 적용범위를 @Acound로 명시 - me.kalpha.event Package아래에 있는 모든 유형의 Method에 모두 적용한다

```java
@Component
@Aspect
public class AOP {
    /* 업무코드 */
    @Around("execution(* me.kalpha.event..*(..))") 
    public Object execute(ProceedingJoinPoint jointPoint) throws Throwable {
        /* 업무코드 */      
        Object proceed = jointPoint.prceed();        
        /* 업무코드 */    
        return proceed;
    }
}
```

