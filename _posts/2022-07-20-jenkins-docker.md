---
layout: single
title: "Jenkins - Docker 연동"
categories: jenkins
tag: [docker, jenkins]
toc: true
#author_profile : false
---



## 1. Docker Repository (Nexus) 확인

> http://nexus-host:5001

## 2. Jenkins에 "Docker Pipeline" Plugin 설치

## 3. Docker Registry의 인증정보 등록

> Dashboard > Credentials > System > Global Credentials (unrestricted)

1. Add Credentials
2. Username with password 등록
   - 계정명 : dockerhub
   - 비밀번호 : dockerhubpwd

## 4. Git 설정(기 존재하면 Skip)

```bash
$ sudo yum install git
$ git --exec-path # git 실행 경로 확인
/usr/lib/git-core
```

> Dashboard > Global tool configuration > Git

1. Git 설정
   - Path to Git executable : /usr/lib/lgit-cord/git

##  5. Docker 사용 권한 설정

```bash
$ ls -l /var/run/docker.sock
srw-rw---- 1 root docker 0 Jun 22 12:32 /var/run/docker.sock

$ sudo chmod 666 /var/run/docker.sock
```

## 6. Jenkins Item 생성

1. Pipeline Type (Scripted pipeline)

2. 매개변수

   - BUILD_NUMBER : 0.1
   - appName : manager-api

3. Pipeline

   - Pipeline script from SCM

     - Script Path : Jenkinsfile

     ```Jenkinsfile
     node {
     	stage('Clone Repository') {
     		checkout scm
     	}
     	stage('Build image') {
     		app = docker.build("kalphageek/${env.appName}")
     	}
     	stage('Push image') {
     		docker.withRegistry('http://nexus-host:5001', dockerhub)
     			app.push("${env.BUILD_NUMBER}")
     			app.push("latest")
     	}
     }
     ```

## 7. Nexus 확인

> http://nexus-host:5001

- 검색 : kalphageek