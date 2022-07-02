---
layout: single
title: "Docker App구축 Example"
categories: docker
tag: [dockerfile, docker, df.sh, nginx, app]
toc: true
#author_profile : false
---

## Example 1

1. dh.sh에 의해 자동생성된 log파일을 host의 /webdata에 저장하는 container를 Dockerfile기반 생성 (df)
2. df에서 생성된 log를 read only로 열어서 nginx에 의해 web으로 보여주는 container 생성 (nginx)

```bash
$ vi df.sh
#!/bin/bash
mkdir -p /webdata
while true
do
   df -h / > /webdata/index.html
   sleep 10
done
:wq

$ vi dockerfile
FROM ubuntu:20.04
ADD df.sh /bin/df.sh
RUN chmod +x /bin/df.sh
ENTRYPOINT ["/bin/df.sh"]
:wq

$ docker build -t kalphageek/df:latest .

$ docker run -v /webdata:/webdata -d --name df kalphageek/df:latest

$ docker run -v /webdata:/usr/share/nginx/html:ro -p 80:80 --name nginx -d nginx:latest 
```

