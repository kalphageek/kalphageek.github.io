---
layout: single
title: "Spark Example, Hive에서 읽기"
categories: spark
tag: [spark, example, hive, python, pyspark]
toc: true
#author_profile : false
---

[문법 참조](https://sparkbyexamples.com/), [spark-submit](https://12bme.tistory.com/441), [Spark공식사이트]([https://spark.apache.org/docs/latest/submitting-applications.html)

## Hive 테이블을 읽는 Pyspark 프로그램 => read_hive_table.py

```python
from pyspark.sql import SparkSession
from pyspark.conf import SparkConf
 
#custom function to access Hive Table
def FetchHiveTable():
        fetch_sql = "select * from car_master.electric_cars"
        # collect는 메모리로 모든 데이터를 올리기 때문에 주의해야 함. 
        table_res = spark.sql(fetch_sql).collect()
        print(table_res)
        for row in table_res:
                car_model_name = row["car_model"]
                car_price = row["price_in_usd"]
 
                print("car model name : " + car_model_name)
                print("car price : " + car_price)
        print("for loop is exit")
 
#Main program starts here
if __name__ == "__main__":
        appname = "ExtractCars"
        #Creating Spark Session
        spark = SparkSession.builder.appName(appname)
                .config("hive.metastore.uris", "thrift://localhost:9083", conf=SparkConf())
            	.enableHiveSupport().getOrCreate()
 
        print("Spark application name: " + appname)
        FetchHiveTable()
        spark.stop()
        exit(0)   
```



## Pyspark 프로그램을 호출하는 쉘 스크립트 => test_script.sh

```bash
#!/bin/bash
 
echo "Info: Setting global variables"
 
export SPARK_MAJOR_VERSION=3
export SPARK_HOME=/usr/local/lib/spark 
export PATH=$SPARK_HOME/bin:$PATH
 
spark-submit ./read_hive_table.py
```



## Hive연결하고 Select하기

```py
from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession, HiveContext

sparkSession = (SparkSession
                .builder
                .appName('example-pyspark-read-and-write-from-hive')
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

