---
layout: single
title: "Nifi Command"
categories: nifi
tag: [nifi, command, processor]
toc: true
toc_sticky: true
#author_profile : false
---



### 1. ExecuteStreamCommand
** 외부 프로세서를 실행시키고 외부 프로세서가 받는 STDIN으로 FlowFile의 Contents를 넘겨주는 작업
> Python script 실행. 특적 Directory의 파일을 하나씩 전달하는 것으로 보임.

* Ref : [https://www.youtube.com/watch?v=mxnYWTabqqQ&t=987s](https://www.youtube.com/watch?v=mxnYWTabqqQ&t=987s ) (43:02)
* Property
  - Command Arguments : /root/TFOS/TFOS_data.py;/tmp/mnist_image/;${filename}
  - Command Path : /usr/bin/python3
  - Argument Delimiter : ;

> Python script 실행 

* Ref : [https://github.com/kalphageek/apache-nifi-templates/tree/master/Execute%20Python%20Script](https://github.com/kalphageek/apache-nifi-templates/tree/master/Execute%20Python%20Script)
* Property
  - Command arguments : script/pandas_script.
  
  

### 2. ExecuteScript
> Shell, Python, Groovy 등의 Script를 실행한다

1. Python Script
* Ref : [https://www.youtube.com/watch?v=mxnYWTabqqQ&t=987s](https://www.youtube.com/watch?v=mxnYWTabqqQ&t=987s) (37:57)
* Property
  - Script Engine : python
  - Command path : python
  - Working directory : C:/Workspace/nifi/apache-nifi-templates/Execute Python Script
  - Argument delimiter : ;
  - Script File : /workspace/script/python01.py
```bash
$ vi python01.py
now_time = str(datetime.datetime.now())
flowFile = session.get()
filename = frowFile.getAttribute('filename')
f = open('/workspace/result/file_list.txt', 'a')
f.write(filename + '-' + now_time)
f.write('\n')
f.close()
session.transfer(frowFile, REL_SUCCESS)
```
> Encoding (cp949 -> utf-8)

* Ref : [https://gist.github.com/cheerupdi/4c9014022df5fa09ea4fcffe5396add5](https://gist.github.com/cheerupdi/4c9014022df5fa09ea4fcffe5396add5)
* Property
  - Command arguments : encoding.py --decode="cp949" --encode="utf-8"
  - Command path : python
  - Working directory : 
  
  
### 3. InvokeHTTP
> RestAPI 호출

* Ref : [https://blog.naver.com/oper13357799/220939422191](https://blog.naver.com/oper13357799/220939422191)
* Property
  - HTTP Method : GET
  - Remote URL : [http://api.sunrise-sunset.org/json?lat=37.366&lng=127.108](http://api.sunrise-sunset.org/json?lat=37.366&lng=127.108)
  - Put response boy in attribute : $.response   <-- 설정되면 response값이 다음 processor로 넘어가지 않는다. 지우면 앞processor의 결과값에 포함되서 다음 processor로 넘어간다
  - Content-typ : ${mime.type}
  
  