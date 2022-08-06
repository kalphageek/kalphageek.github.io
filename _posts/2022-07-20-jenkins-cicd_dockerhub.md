---
layout: single
title: "Jenkins - Docker CI/CD to Docker Hub"
categories: jenkins
tag: [docker, jenkins, maven, dockerhub]
toc: true
toc_sticky: true
#author_profile : false
---



1. Pipeline Type : Scripted pipeline
2.  매개변수
   - appName : manager-api
   - BUILD_NUMBER :1.0

3. Pipeline

   Definition : Pipeline script

   ```groovy
   node {
       def mvnHome
       stage('Checkout') {
           get 'git@github.com:kalphageek/spring-cloud.git'
           mvnHome = tool 'M3'
       }
       stage('Maven Build') {
           sh "'${mvnHome}/bin/mvn' -Dmaven.test.failure.ignore -Dmaven.test.skip=true clean package"
       }
       stage('Docker Build') {
           app = docker.build("creadential_name/${env.appName}")    
       }    
       stage('Docker Build') {
           docker.withRegistry('http://docker-hub:5001','creadential_name') {
               app.push("${env.BUILD_NUMBER}")
               app.push("latest")
           }
       }
   }
   ```

   

