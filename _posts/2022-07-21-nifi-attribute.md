---
layout: single
title: "Nifi Atributte"
categories: nifi
tag: [nifi, atributte, processor]
toc: true
toc_sticky: true
#author_profile : false
---



> frowFile의 메타속성(Attribute) 을 다룬다.

### 1. UpdateAttribute
** UpdateAttribute는 Flowfile 안에 있는 Attribute를 추가 및 수정 하기 위해 사용된다. 사용자가 속성을 생성하고, 그 값까지 정의해야 한다

> counter  증가<br>FLOWFILE 이 계속 updateAttribute Processor 를 돌면서 counter property 값을 증가시킨다. updateattribute 를 몇 번 통과했는지를 counter 하는 거라고 보면 될 듯.

* Ref : [https://eyeballs.tistory.com/395?category=875897](https://eyeballs.tistory.com/395?category=875897)
* Property
  - counter : ${counter:isNull():not():ifElse('${counter:plus(1)}','${literal("0")}')}   <- 직접생성

> 파일명 변경

* Ref : [https://gist.github.com/cheerupdi/4c9014022df5fa09ea4fcffe5396add5](https://gist.github.com/cheerupdi/4c9014022df5fa09ea4fcffe5396add5), [https://nifi.apache.org/docs/nifi-docs/html/expression-language-guide.html](https://nifi.apache.org/docs/nifi-docs/html/expression-language-guide.html)
* Property
  - filename : ${filename:substringBeforeLast('.')}.json  <- 직접 생성

> date 속성의 format 변경 <br>
> 값이 "12-24-2014"이고, format을 "2014/12/24"로 변경하려는 경우 toDate:format 두 함수를 함께 연결하면됩니다.

* Property
  - date : ${date:toDate('MM-dd-yyyy'):format('yyyy/MM/dd')}

> filename 생성

* Property
  - filename : iski_tweet_${now():toNumber():minus(86400000):format('dd-MM-yyyy'):toString()}.html

> schema.name 생성 <br>Reader나 Writer에서 기본으로 사용할 schema의 이름을 정의한다.<br>
>
> 값으로 정의된 schema는 AvroSchemaRegistry에 그 Spec이 정의 되어야 한다.

* Property
  - schema.name : in_schema

### 2. RouteOnAttribute
** 정규표현식이나 내장함수를 이용하여 True/False를 인지해서 분기할수 있게 하는 Processor

> Event를 체크해서 지정된 시간(10시 49분)에만 다음 작업으로 넘어간다

* Ref : [https://blog.naver.com/oper13357799/220939422191](https://blog.naver.com/oper13357799/220939422191)
* Property
  - EvtSunupdown : ${now():format('hhmm'):equals('1049')}  <- 직접 생성

> Seoul만 분