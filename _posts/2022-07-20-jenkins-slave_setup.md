---
layout: single
title: "Jenkins - Cluster Setup"
categories: jenkins
tag: [cluster, jenkins]
toc: true
toc_sticky: true
#author_profile : false
---



## Slave Setup

* Name : agent1
* Remote root directory : /usr/local/lib/nifi
* Labels : Agent-1
* Launch method : Launch agent via execution of common on the master
  * Launch command : ssh jenkins@192.168.0.13 java -jar /usr/local/lib/nifi/bin/agent.jar
* Tool Locations
  * Name : (Maven) M3
  * Home : /usr/local/lib/maven