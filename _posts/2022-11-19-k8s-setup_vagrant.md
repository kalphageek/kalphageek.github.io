---
layout: single
title: "K8S Setup (Vagrant)"
categories: k8s
tag: [vagrant, setup, vm]
toc: true
toc_sticky: true
#author_profile: false

---



## * KVM을 이용한 설치가이드
https://www.inflearn.com/course/%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4-%EA%B8%B0%EC%B4%88/lecture/24556?tab=curriculum&volume=0.44

## * Vagrant를 통한 설치가이드 (k8s)
1. XShell 설치 : 생성될 Master/Woker Node에 접속할 툴 (기존에 쓰고 있는게 있으면 생략가능)
2. VirtualBox 설치 : VM 및 내부 네트워크 생성 툴
3. Vagrant 설치 및 k8s 설치 스크립트 실행 : 자동으로 VirtualBox를 이용해 VM들을 생성하고, K8S관련 설치 파일들이 실행됨
4. Worker Node 연결 : Worker Node들을 Master에 연결하여 쿠버네티스 클러스터 구축
5. 설치 확인 : Node와 Pod 상태 조회
6. 대시보드 접근 : Host OS에서 웹 브라우저를 이용해 클러스터 Dashboard에 접근
![Installation Step Case6 for Kubernetes](https://raw.githubusercontent.com/kalphageek/image_repo/main/img/Installation%20Step%20Case6%20for%20Kubernetes.jpg?token=AHE3DGDJAH53KRWWRZRUZTTEC3DYM)

### 1. XShell 설치
* 다운로드 url : https://www.netsarang.com/en/free-for-home-school/

* 설치 후 k8s-master(192.168.56.30:22), k8s-node1(192.168.56.31:22), k8s-node2(192.168.56.32:22) IP 등록


### 2. VirtualBox 설치
* 6.1.26 버전 다운로드 : https://download.virtualbox.org/virtualbox/6.1.26/VirtualBox-6.1.26-145957-Win.exe
* 다운로드 사이트 : https://www.virtualbox.org/wiki/Downloads

### 3. Vagrant 설치 및 k8s 설치 스크립트 실행
#### 3-1) 설치
* 2.2.18 버전 다운로드 : https://releases.hashicorp.com/vagrant/2.2.18/vagrant_2.2.18_x86_64.msi
** 다운로드 사이트 : https://www.vagrantup.com/downloads

#### 3-2) Vagrant 명령 실행
* 윈도우에서 cmd 실행
* k8s 폴더 생성 및 이동
* Vagrantfile 파일 다운로드
```sh
C:\Users\사용자>mkdir k8s
C:\Users\사용자>cd k8s 
C:\Users\사용자\k8s> curl -O https://kubetm.github.io/yamls/k8s-install/Vagrantfile
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

### 4. Worker Node 연결
* 4-1) XShell을 통해 master 접속 (id/pw: root/vagrant)
* 4-2) cat 명령으로 자신에 master 접근 token 확인 및 복사
```sh
[root@k8s-master ~]# cat ~/join.sh
kubeadm join 192.168.56.30:6443 --token bver73.wda72kx4afiuhspo --discovery-token-ca-cert-hash sha256:7205b3fd6030e47b74aa11451221ff3c77daa0305aad0bc4a2d3196e69eb42b7
```
* 4-3) worker node1 접속 후 토큰 붙여놓기 (id/pw: root/vagrant)
```sh
[root@k8s-node1 ~]# kubeadm join 192.168.56.30:6443 --token bver73.wda72kx4afiuhspo --discovery-token-ca-cert-hash sha256:7205b3fd6030e47b74aa11451221ff3c77daa0305aad0bc4a2d3196e69eb42b7
```
* 4-4) worker node2 접속 후 토큰 붙여놓기 반복
```sh
[root@k8s-node2 ~]# kubeadm join 192.168.56.30:6443 --token bver73.wda72kx4afiuhspo --discovery-token-ca-cert-hash sha256:7205b3fd6030e47b74aa11451221ff3c77daa0305aad0bc4a2d3196e69eb42b7
```
### 5. 설치 확인
* 5-1) XShell을 통해 master 접속 (id/pw = root/vagrant)
* 5-2) kubectl 명령어
```sh
[root@k8s-master ~]# kubectl get pod -A
[root@k8s-master ~]# kubectl get nodes
```
### 6. 대시보드 접근
```sh
http://192.168.56.30:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/workloads?namespace=default
```



## * 참고

### 1. Version 정보
* Vagrant : 2.2.19
* Virtualbox : 6.1.32
* Docker :20.10.14
* Kubernetes : 1.22.8

![Installation Version Case6 for Kubernetes1](https://raw.githubusercontent.com/kalphageek/image_repo/main/img/Installation%20Version%20Case6%20for%20Kubernetes1.jpg?token=AHE3DGDBMYN2LEDKVTVDYYDEC3D24)

### 2. Network 구성도
![Installation Network Case6 for Kubernetes2](https://raw.githubusercontent.com/kalphageek/image_repo/main/img/Installation%20Network%20Case6%20for%20Kubernetes2.jpg?token=AHE3DGGYZJAJFNNS7VDUMUDEC3D3U)
### 3. QnA
#### 3.1) vagrnat up 시 VM기동이 안될경우
* 에러 메세지
```txt
There was an error while executing `VBoxManage`, a CLI used by Vagrant
for controlling VirtualBox. The command and stderr is shown below.

Command: ["startvm", "8a9490a5-bbe4-4bac-9043-de39b93cf6b3", "--type", "headless"]

Stderr: VBoxManage.exe: error: The VM session was closed before any attempt to power it on
VBoxManage.exe: error: Details: code E_FAIL (0x80004005), component SessionMachine, interface ISession
```
* 해결방법 : 작업관리자에 들어가서 VirtualBox 관련 프로세스 모두 죽이고 다시 실행 (VirtualBox Headless Frontend, VirtualBox Interface)
* 추가 커맨트 : 생각보다 자주 이런 현상이 발생하는것 같아요. 설치만 vagrant로하고 이후부터는 vagrant up으로 기동하지 않고, 그냥 virtualbox만 실행해서 UI를 통해 기동시키고 내리는것도 괜찮을것 같습니다. 이때 주의할 점은, virtualbox를 통해 core수나 memory를 직접 변경 했을때 나중에 vagrant up으로 기동할일이 있을 경우 Vagrantfile에 있는 core, memory 스펙으로 다시 업데이트 된다는 점 주의하시기 바랍니다.
#### 3.2) Dashboard 관련
* Master Node 재기동시 Dashboard에 접속하기 위해선 아래 명령어를 실행해서 Proxy 오픈하기
```sh
[root@k8s-master ~]# nohup kubectl proxy --port=8001 --address=192.168.56.30 --accept-hosts='^*$' >/dev/null 2>&1 &
```
* Dashboard 접근시 ServiceUnavailable 에러 발생시 아래 명령을 통해 기동안된 Pod 확인
```sh
[root@k8s-master ~]# kubectl get pods -
```

#### 3.3) Bashboard 로그인 인증
```sh
[root@k8s-master ~] kubectl get serviceaccounts -A
[root@k8s-master ~] kubectl describe serviceaccounts kubernetes-dashboard -n kubernetes-dashboard
...
Tokens:              kubernetes-dashboard-token-ccgb4
...
[root@k8s-master ~] kubectl describe secrets kubernetes-dashboard-token-ccgb4 -n kubernetes-dashboard
...
eyJhbGciOiJSUzI1NiIsImtpZCI6IjQxZW1QZzYya2JsdTBLbmxBZUhPMzI1NW13ZjF4WFltbmNsMUF5SFhSVlUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZC10b2tlbi1jY2diNCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjllODQwMGMwLTQxNzctNDQxMS04NTY2LTkwYzc0MjM4Zjc3ZSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDprdWJlcm5ldGVzLWRhc2hib2FyZCJ9.NkrQir7Aef6rOH87QpAocNCwxvPONt_mHLs8IRI0EeWaf9owari8hYSjStgDzyXBf2Qt9aQjdXwDGLYintr-rQC-cPxtuY5YOU0tpnohup kubectl proxy --port=8001 --address=192.168.56.30 --accept-hosts='^*$' >/dev/null 2>&1 &

