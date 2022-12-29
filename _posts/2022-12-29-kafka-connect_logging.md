---
layout: single
title: "Kafka Connect 별도 Logging 구성"
categories: kafka
tag: [confluent, connect, log, suffix, tee]
toc: true
toc_sticky: true
#author_profile : false

---


### 1) Log파일 자동 생성

```bash
# log dir생성
$ mkdir connect_console_log

# connect 실행
$ export log_suffix=`date +"%Y%m%d%H%M%S"`
$ connect-distributed $CONFLUENT_HOME/etc/kafka/connect-distributed.properties 2>&1 | tee -a ~/connect_console_log/connect_console_$log_suffix.log
```

