---
layout: single
title: "K8S Setup (Vagrant)"
categories: k8s
tag: [vagrant, setup, vm]
toc: true
toc_sticky: true
#author_profile: false

---



### * 설치 후 Dashboard 접근

```sh
https://192.168.56.30:30000/#/login
```



## * v1.27 설치가이드
https://kubetm.github.io/k8s/02-beginner/cluster-install-case6/

## * Vagrant를 통한 설치가이드 (k8s)
1. XShell 설치 : 생성될 Master/Woker Node에 접속할 툴 (기존에 쓰고 있는게 있으면 생략가능)
2. VirtualBox 설치 : VM 및 내부 네트워크 생성 툴
3. Vagrant 설치 및 k8s 설치 스크립트 실행 : 자동으로 VirtualBox를 이용해 VM들을 생성하고, K8S관련 설치 파일들이 실행됨
4. Worker Node 연결 : Worker Node들을 Master에 연결하여 쿠버네티스 클러스터 구축
5. 설치 확인 : Node와 Pod 상태 조회
6. 대시보드 접근 : Host OS에서 웹 브라우저를 이용해 클러스터 Dashboard에 접근
![Installation Step Case6 for Kubernetes](../../k8s-learning/img/Installation Step Case6 for Kubernetes.jpg)

### 1. XShell 설치
* 다운로드 url : https://www.netsarang.com/en/free-for-home-school/

* 설치 후 k8s-master(192.168.56.30:22), k8s-node1(192.168.56.31:22), k8s-node2(192.168.56.32:22) IP 등록


### 2. VirtualBox 설치 (7.0.8 버전)
* Win 버전 : https://download.virtualbox.org/virtualbox/7.0.8/VirtualBox-7.0.8-156879-Win.exe
* Download site : https://www.virtualbox.org/wiki/Downloads
* FAQ : microsoft visual 관련 에러 해결방법 https://cafe.naver.com/kubeops/25

### 3. Vagrant 설치 및 k8s 설치 스크립트 실행
#### 3-1) Vagrant 설치 (2.3.4 버전)
* Win 버전 : https://releases.hashicorp.com/vagrant/2.3.4/vagrant_2.3.4_windows_amd64.msi
* Download site : https://developer.hashicorp.com/vagrant/downloads?product_intent=vagrant

#### 3-2) Vagrant 명령 실행
* Vagrant 설치
```sh
// 폴더 생성
C:\Users\사용자>mkdir k8s
C:\Users\사용자>cd k8s 

// Vagrant 스크립트 다운로드
C:\Users\사용자\k8s> curl -O https://kubetm.github.io/yamls/k8s-install/Vagrantfile

// Rocky Linux Repo 세팅
C:\Users\사용자\k8s> curl -O https://raw.githubusercontent.com/k8s-1pro/install/main/ground/k8s-1.27/vagrant-2.3.4/rockylinux-repo.json
C:\Users\사용자\k8s> vagrant box add rockylinux-repo.json

// Vagrant Disk 설정 Plugin 설치 
C:\Users\사용자\k8s> vagrant plugin install vagrant-vbguest vagrant-disksize
```
* Vagrant 실행 (5~10분 소요)
```sh
C:\Users\사용자\k8s> vagrant up
```
* vagrant 명령어 참고
* vagrant up : 가상머신 기동
* vagrant halt : 가상머신 Shutdown
* vagrant ssh : 가상머신 접속 (vagrant ssh k8s-master)
* vagrant destroy : 가상머신 삭제


