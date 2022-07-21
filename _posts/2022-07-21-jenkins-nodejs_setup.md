---
layout: single
title: "Jenkins - NodeJS 설치"
categories: jenkins
tag: [nodejs, jenkins]
toc: true
#author_profile : false
---



## 1. Jenkins를 위한 NodeJS 설치 (Jenkins에서 자동설치 안되는 경우 )

```bash
$ wget https://nodejs.org/dist/v16.16.0/node-v16.16.0-linux-x64.tar.xz
$ tar xvf node-v16.16.0-linux-x64.tar.xz
$ sudo mv ./node-v16.16.0-linux-x64.tar.xz /usr/local/lib/
$ sudo ln -s /usr/local/lib/node-v16.16.0-linux-x64 /usr/local/lib/nodejs
$ sudo ln -sf "$(which node)" /usr/bin/node
```



## 2. Shell 적용 및 테스트

``` bash
$ vi .bashrc
export NODE_HOME=/usr/local/lib/nodejs
export PATH=$NODE_HOME/bin:$PATH
$. .basrc
# Proxy 설정
$ npm config set registry http://nexus-host/repository/npm-group/
# ssl false
$ npm confgi set strict-ssl false
$ npm config list
$ node -v
$ npm -v
```



## 3. NodeJS Plugin 설정

> Dashboard > Global Tool Configuration > Add NodeJS

1. 파라미터
   - Name : NodeJS
   - Installation Directory : /usr/local/lib/nodejs



## 4. Docker Hub Credential 생성

> Jenkins 관리 > Manage Credentials > System > Global credentials (unrestricted) 

1. Add Credentials
   - Kind : Username with password
   - Username : jenkins_docker
   - Password : ****
   - ID : dockerhub