---
layout: single
title: "Spark Example, Kafka에 쓰기"
categories: spark
tag: [spark, example, kafka, python, pyspark]
toc: true
#author_profile : false
---

[문법 참조](https://sparkbyexamples.com/), [spark-submit](https://12bme.tistory.com/441), [Spark공식사이트]([https://spark.apache.org/docs/latest/submitting-applications.html)

> test Topic에서 읽어서,  spark.out Topic에 다시 쓰는 코드

```python
from pyspark import SparkConf, SparkContext
from operator import add
import sys
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils
import json
from kafka import SimpleProducer, KafkaClient
from kafka import KafkaProducer

producer = KafkaProducer(bootstrap_servers='localhost:9092')

def handler(message):
    records = message.collect()
    for record in records:
        producer.send('spark.out', str(record))
        producer.flush()

def main():
    sc = SparkContext(appName="PythonStreamingDirectKafkaWordCount")
    ssc = StreamingContext(sc, 10)

    brokers, topic = sys.argv[1:]
    kvs = KafkaUtils.createDirectStream(ssc, [topic], {"metadata.broker.list": brokers})
    kvs.foreachRDD(handler)

    ssc.start()
    ssc.awaitTermination()
if __name__ == "__main__":
       
```



>  Maven Central에서 JAR을 다운로드합니다. (Group ID = org.apache.spark, Artifact ID = spark-streaming-kafka-assembly, 버전 = 1.6.0 이후)

```bash
$ spark-submit --jars spark-streaming-kafka-assembly_2.10-1.6.1.jar s.py localhost:9092 test
```

