---
layout: single
title: "Jenkins - NodeJS Build - Docker Push"
categories: jenkins
tag: [nodejs, jenkins, docker,]
toc: true
#author_profile : false
---



## Jenkins Pipeline Item

1. Item Type (Scripted pipeline)

2. 매개변수

   - appName : manage-front
   - BUILD_NUMBER : 1.0

3. Pipeline script

   ```groovy
   node {
       def nodeHome
       stage('Checkout') {
           git 'git@github.com:kalphageek/spring-cloud.git'
           nodeHome = tool 'NodeJS'
       }
       stage ('Install Dependencies') {
           sh "${nodeHome}/bin/npm install --registry http://nexus-host/repository/npm-group"
       }
       stage ('NodeJS Build') {
           sh "CI=false;${nodeHome}/bin/npm run build"
       }
       stage ('Docker Build') {
           app = docker.build("kalphageek/${env.appName}")
       }
       stage ('Docker Push') {
           docker.withRegistry('http://nexus-host:5001', 'dockerhub') { // (nexus repository, jenkins docker credential)
               app.push("${env.BUILD_NUMBER}")
               app.push("latest")
           }
       }
   }
   ```

   