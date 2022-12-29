---
layout: single
title: "Kafka Connect Plugin 설치"
categories: kafka
tag: [confluent, connect, connector, plugin, hub, source, sink, transform, converter]
toc: true
toc_sticky: true
#author_profile : false

---



[http://www.confluent.io/product/connectors](http://www.confluent.io/product/connectors)



### 1) 종류

* Connectors
* Transform
* Converter



### 2) 설치

1. confluent connectors에서 download받은 파일에서 jar library를 추출해서 plugin.path (connect-distributed.properties) 의 위치에 이동한다.
2. Connect를 재기동한다