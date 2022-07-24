---
layout: single
title: "Kafka - 이벤트 브로커와 메시지 브로커 차이"
categories: kafka
tag: [kafka, streams, springboot]
toc: true
toc_sticky: true
#author_profile : false
---


참조 : [https://www.youtube.com/watch?v=H_DaPyUOeTo](https://www.youtube.com/watch?v=H_DaPyUOeTo)

## 1. 메시지 Broker

> 메시지를 받아서 처리하고, 삭제되는 구조. 1회만 전달 보장

- RabbitMQ
- Redis



## 2. 이벤트 Broker

> 이벤트(또는 메시지)를 받아서 처리한 후에도 삭제하지 않고 유지 되는 구조. 이벤트를 1개만 보관하고, 인덱스를 통해 개별 엑세스를 관리, 업무상 필요한 시간 만큼 이벤트를 보관한다. 장애시 재처리 가능

- Kafka
- AWS Kinesis

