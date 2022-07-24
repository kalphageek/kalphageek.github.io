---
layout: single
title: "Jenkins 설치"
categories: jenkins
tag: [jenkins, install]
toc: true
toc_sticky: true
#author_profile : false
---



## Ubuntu에 설치

```bash
$ wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | 
  sudo apt-key add -
$ sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
/etc/apt/sources.list.d/jenkins.list'
$ sudo apt-get update
$ sudo apt-get install jenkins
```



## 설정 변경

```bash
$ vi /etc/default/jenkins

[Service]
Environment="JENKINS_PORT=9000"
```



## 재 기동 및 서비스 확인

```bash
$ sudo service jenkins restart
$ sudo systemctl status jenkins
```



## Jenkins 자동실행 중지

```bash
$ sudo systemctl disable jenkis
```



##  Jenkins 초기 비밀번호 확인

```bash
$ sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

