---
layout: single
title: "Spark Example, Hive에서 읽기"
categories: spark
tag: [spark, example, hive, python, pyspark]
toc: true
#author_profile : false
---

[문법 참조](https://sparkbyexamples.com/), [spark-submit](https://12bme.tistory.com/441), [Spark공식사이트]([https://spark.apache.org/docs/latest/submitting-applications.html)

## Hive연결하고 Select하기

```py
from pyspark import SparkContext, SparkConf
from pyspark.conf import SparkConf
from pyspark.sql import SparkSession, HiveContext

sparkSession = (SparkSession
                .builder
                .appName('example-pyspark-read-and-write-from-hive')
                .config("hive.metastore.uris", "thrift://localhost:9083", conf=SparkConf())
                .enableHiveSupport()
                .getOrCreate()
                )
# data = [('First', 1), ('Second', 2), ('Third', 3), ('Fourth', 4), ('Fifth', 5)]
# df = sparkSession.createDataFrame(data)
## Write into Hive
# f.write.saveAsTable('example')

df_load = sparkSession.sql('SELECT * FROM example')
df_load.show()
print(df_load.show())
```

