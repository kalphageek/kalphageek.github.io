---
layout: single
title: "Spark 설치"
categories: spark
tag: [spark, install]
toc: true
#author_profile : false
---



## Scala 설치

```bash
$ sudo yum install scala

# 만일 Download버전으로 설치시 환경변수 설정
# export SCALA_HOME=/usr/local/scala
# export PATH=$SCALA_HOME/bin:$PATH
```



## Spark 설치

```bash
# spark 설치
$ wget https://archive.apache.org/dist/spark/spark-2.4.8/spark-2.4.8-bin-hadoop2.7.tgz
$ tar xvf spark-2.4.8-bin-hadoop2.7.tgz
$ sudo mv spark-2.4.8-bin-hadoop2.7.tgz /usr/local/lib/
$ ln -s spark-2.4.8-bin-hadoop2.7 spark

# spark 환경변수 설정
$ export SPARK_HOME=/usr/local/scala
$ export PATH=$SPARK_HOME/bin:$PATH

# spark 실행 및 테스트
$ spark-shell
sc
spark
```

