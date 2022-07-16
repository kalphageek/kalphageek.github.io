---
layout: single
title: "Spark 설치"
categories: spark
tag: [spark, install, pyspark, python]
toc: true
#author_profile : false
---



## Scala 설치

```bash
$ sudo yum install scala

# 만일 Download버전으로 설치시 환경변수 설정 필요
# export SCALA_HOME=/usr/local/scala
# export PATH=$SCALA_HOME/bin:$PATH
```



## Spark 설치

```bash
# Spark 설치
$ wget https://archive.apache.org/dist/spark/spark-3.3.0/spark-3.3.0-bin-hadoop2.tgz

$ tar xvf spark-3.3.0-bin-hadoop2.tgz
$ sudo mv spark-3.3.0-bin-hadoop2.tgz /usr/local/lib/
$ ln -s spark-2.4.8-bin-hadoop2.7 spark

# Spark 환경변수 설정
$ vi .bashrc
export SPARK_HOME=/usr/local/spark
export PATH=$SPARK_HOME/bin:$PATH
$ . .bashrc 
```



## Spark 실행 및 테스트

```bash
$ spark-shell
sc
spark
```



## PySpark 설치 및 테스트

```bash
$ pip3 import pyspark

$ ipython
[1] import pyspark
[2] pyspark.__version__
Out[3] '3.3.0'
[3] sc = pyspark.SparkContext(appName="myAppName")
```



## PySpark 에러 조치

```bash
# 1.
[0] import pyspark
Py4JError: org.apache.spark.api.python.PythonUtils.getPythonAuthSocketTimeout이 JVM에 존재하지 않습니다.
...

# Python의 pyspark 및 spark 클러스터 버전이 일치하지 않으며 이 오류가 보고됩니다. 
$ pip3 uninstall pysparkdocker run --name nifi \
  -p 8443:8443 \
  -d \
  -e SINGLE_USER_CREDENTIALS_USERNAME=admin \
  -e SINGLE_USER_CREDENTIALS_PASSWORD=ctsBtRBKHRAx69EqUghvvgEvjnaLjFEB \
  apache/nifi:latest
$ pip3 install pyspark==3.3.0

# 2. 
[0] import pyspark
py4j.protocol.Py4JError: org.apache.spark.api.python.PythonUtils.getEncryptionEnabled does not exist in the JVM

export SPARK_HOME=/usr/local/lib/spark
export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip:$PYTHONPATH
export PATH=$SPARK_HOME/bin:$SPARK_HOME/python:$PATH
```



## Jupyter Notebook 사용 설정

```bash
# Pyspark가 Jupyter notebook으로 실행되도록 환경변수 설정 
$ sudo vi /etc/profile
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS='notebook'

# Jupyter Password 설정
$ python3
>>> from notebook.auth import passwd
>>> passwd()
'sha1:4a9...'
$ jupyter notebook --generate-config
$ sudo vi ~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.allow_origin = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.password = 'sha1:4a9...'
```



## Pyspark (Jupyter) 실행

```bash
$ pyspark
```



## Jupyter Notebook 접속

> http://localhost:8888



## Jupyter Port / 시작폴더 변경

```bash
$ sudo vi ~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.port = 8888 #default 8888
c.NotebookApp.notebook_dir = 'workspace/jupyter' #Notebook의 시작폴더 변경
```

