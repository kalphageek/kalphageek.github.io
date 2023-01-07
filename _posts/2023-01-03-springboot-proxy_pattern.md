---
layout: single
title: "Springboot Proxy 패턴"
categories: springboot
tag: [aop, proxy, payment, store, stopwatch]
toc: true
toc_sticky: true
#author_profile: false

---



## 1. Proxy 패턴

> payment.pay가 여러곳서 사용되는 경우 기존 코드의 변경없이 pay의 내용을 변경하거나 추가 코드를 삽입할 수 있다.

### 1) Proxy Interface

```java
public interface Payment {
    public void pay();
}
```

### 2) Business Class

```java
public class Store {
    Payment payment;
    
    public Store(Payment payment) {
        this.payment = payment
    }
    
    public void buySomething(int amount) {
        payment.pay(amount);
    } 
}
```

### 3)  Proxy Implement #1

```java
public class Cash implements Payment {
    @Override
    public void pay(int amount) {
        System.out.println(amount + " 현금 결제");
    }
}
```

### 4) Proxy Implement #2

```java
public class CashPerf implements Payment {    
    @Override
    public void pay(int amount) {
        StopWatch stopWatch = new StopWatch();
        stopWatch.start();
        
        cash.pay(amount);
        
        stopWatch.stop();
        System.out.println(stopWatch.prettyPrint());
    }
}
```

### 5) Client 코드

> Client에 기존 코드 대신 Proxy코드를 사용하도록 변경 한다. 기존 Business 코드 (Store)는 변경하지 않았다

```java
public class StoreTest {    
    // 기존 코드
    @Test
    public void testCash() {
        Payment payment = new Cash();
        Store store = new Store(payment);
        store.buySomething();
    }
    
    // Proxy 적용 코드
    @Test
    public void testCashPerf() {
        Payment payment = new CashPerf();
        Store store = new Store(payment);
        store.buySomething();
    }
    
}
```

