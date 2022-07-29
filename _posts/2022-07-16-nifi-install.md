---
layout: single
title: "Nifi 설치"
categories: nifi
tag: [nifi, install, docker]
toc: true
toc_sticky: true
#author_profile : false
---



## Docker 설치

```bash
$ docker run --name nifi \
  -p 8443:8443 \
  -d \
  -e SINGLE_USER_CREDENTIALS_USERNAME=admin \
  -e SINGLE_USER_CREDENTIALS_PASSWORD=ctsBtRBKHRAx69EqUghvvgEvjnaLjFEB \
  apache/nifi:latest
```



## Nifi 접속

> https://localhost:8443/nifi



## Nifi Administrator

> [https://eyeballs.tistory.com/320?category=875897](https://eyeballs.tistory.com/320?category=875897)



## Nifi Expression Language

> [https://nifi.apache.org/docs/nifi-docs/html/expression-language-guide.html](https://nifi.apache.org/docs/nifi-docs/html/expression-language-guide.html)



## Nifi Clustering Management

> [https://gist.github.com/cheerupdi/bffb331447abc78934ad5a40feb83f16#terminology](https://gist.github.com/cheerupdi/bffb331447abc78934ad5a40feb83f16#terminology)



## JSONPath Online Evaluator

> [http://jsonpath.com/](http://jsonpath.com/)
