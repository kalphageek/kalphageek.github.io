---
layout: single
title: "Linux (K8S) Tools"
categories: utility
tag: [k8s, dive, http, watch, tee, jq]
toc: true
toc_sticky: true
#author_profile: false

---



## 1. Dive

> K8S Image 내부구조를 볼수 있다. 이를 통해 Layer가 얼마나 효율적으로 적층되었는지 판단가능하다

* 설치

https://gochronicles.com/dive/

* 실행

```bash
$ docker images
$ dive [Images ID]
```



## 2. Watch

> Command Line을 초단위로 재실행

* 사용법

```bash
# 1초마다 http://localhost:8080/actuator/health/liveness 실행
$ watch -n1 "http http://localhost:8080/actuator/health/liveness"
```



## 3. Httpie

> Command Line Http 테스팅 툴<br>curl | jq와 유사한 결과를 보여주지만, 보다 단순하고, 보기 좋은 결과를 만든다.

* 설명

https://httpie.io/cli

* 사용법

```bash
$ http://localhost:8080/actuator/health/liveness
```



## 4. Tee

> tee 는 표준 입력(standard input)에서 읽어서 표준 출력(standard output) 과 파일에 쓰는 명령어입니다.

* 사용법

```bash
# sudo echo 명령어 사용시 Permission denied 문제 해결하기
$ echo "validate_password.policy=LOW" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf 
```



## 5. Jq

> [jq](https://stedolan.github.io/jq/)는 command line 용 json processor 로 [curl](https://www.lesstif.com/software-architect/curl-http-get-post-rest-api-14745703.html) 이나 [httpie](https://www.lesstif.com/software-architect/httpie-curl-http-client-28606741.html) 등의 명령행 http 처리기와 연계하여 JSON 기반의 REST API 를 디버깅할 때 유용한 툴입니다.

[튜토리얼](https://stedolan.github.io/jq/tutorial/)

* 설치

```bash
$ apt install jq
```

* 사용법

```bash
$ curl 'https://api.github.com/repos/stedolan/jq/commits?per_page=5' | jq '.'
# array 원소 접근
$ curl 'https://api.github.com/repos/stedolan/jq/commits?per_page=5' | jq '.[1]'
# filter 사용 - 연산자로 결과를 필터에 전달하여 처리할 수 있습니다. 아래는 가장 최근 커밋 정보에서 커밋 메시지, 커미터, 날자를 출력합니다.  
$  curl 'https://api.github.com/repos/stedolan/jq/commits?per_page=5' |jq '.[0] | {message: .commit.message, name: .commit.committer.name, date: .commit.author.date}' 
```

