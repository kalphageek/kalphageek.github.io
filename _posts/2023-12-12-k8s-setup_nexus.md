---
layout: single
title: "K8S Setup (Nexus)"
categories: k8s
tag: [nexus, setup, containerd, reset]
toc: true
toc_sticky: true
#author_profile: false

---



```
- Container Engine으로 containerd를 사용하도록 한다. Docker는 Image build용으로 사용하기 때문에 그 용도가 없으면 설치하지 않아도 됨
- Centos 8.4
- Master 3대, Worker 5대
```



### 1. Docker 재설치

```bash
# docker 관련 정보 확인
docker ps -a
docker images

# docker 관련 reset - 필요시 
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
docker system prune

# docker 삭제 / 설치
dnf remove -y docker-ce docker-ce-cli
dnf install -y docker-ce docker-ce-cli

# Docker 외부 접근을 위한 Service 파일 설정 변경
#========== 수정 내용 ==========
#ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
#-> "-H fd://" 제거
#===========================
sed -i 's/-H fd:\/\/ //g' /usr/lib/systemd/system/docker.service

#Docker 외부 접근 및 registry 설정을 위한 daemon 파일 생성
vi /etc/docker/daemon.json
#========== 수정 내용 ==========
{
  "hosts" : ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2375"],
  "insecure-registries" : ["nexus.jjd.com:5000", "nexus.jjd.com:5001","nexus.jjd.com:5002", "nexus.jjd.com:5003", "nexus.jjd.com:5004"],
  "registry-mirrors" : ["http://nexus.jjd.com:5000"],
  "exec-opts" : ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "bip": "10.251.0.1/16"
}
#===========================

systemctl daemon-reload
systemctl restart docker.service
systemctl enable --now docker

# 설치버전 확인
dnf list docker-ce docker-ce-cli

# 일반 사용자에 대한 docker 사용 권한 추가
usermod -aG docker jjd
```



## 2. Kerbernetes 재설치

```bash
#전체 Node
kubeadm reset
dnf erase -y kubeadm kubelet kubectl
dnf remove -y containerd.io
rm -rf /etc/cni/net.d/*
iptables -F; iptables -t nat -F; iptables -t mangle -F

# containerd 설치 (docker 는 사실상 무의미 하지만 Image build 할때 필요할 수 있으므로...)
dnf install -y containerd.io
systemctl enable --now containerd
systemctl restart containerd 

# 설치버전 확인
dnf list containerd.io

# containerd 시스템 변수 설정
echo "overlay" > /etc/modules-load.d/containerd.conf
echo "br_netfilter" >> /etc/modules-load.d/containerd.conf
modprobe overlay
modprobe br_netfilter
echo "net.bridge.bridge-nf-call-iptables = 1" > /etc/sysctl.d/99-kubernetes-cri.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/99-kubernetes-cri.conf
echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/99-kubernetes-cri.conf
sysctl --system

# containerd 설정 (registries 등)
mkdir /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd

## containerd의 systemd cgroup 드라이버의 사용[전체 node](/etc/containerd/config.toml)
#========== 수정 내용 ==========
#[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
#  ...
#  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#    SystemdCgroup = true
#===========================
sed -i 's/systemd_cgroup = true/systemd_cgroup = false/g' /etc/containerd/config.toml

## k8s pause 이미지 변경
sed -i 's/registry.k8s.io\/pause:3.6/registry.k8s.io\/pause:3.9/g' /etc/containerd/config.toml

## registry-mirrors 추가 설정
vi /etc/containerd/config.toml
#========== 수정 내용 ==========
    [plugins."io.containerd.grpc.v1.cri".registry]
      config_path = ""
      [plugins."io.containerd.grpc.v1.cri".registry.auths]
      [plugins."io.containerd.grpc.v1.cri".registry.configs]
      [plugins."io.containerd.grpc.v1.cri".registry.headers]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["http://nexus.jjd.com:5000"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."nexus.jjd.com:5001"]
          endpoint = ["http://nexus.jjd.com:5001"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."quay.io"]
          endpoint = ["http://nexus.jjd.com:5002"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"]
          endpoint = ["http://nexus.jjd.com:5003"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."k8s.gcr.io"]
          endpoint = ["http://nexus.jjd.com:5004"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."registry.k8s.io"]
          endpoint = ["http://nexus.jjd.com:5007"]
#===========================

systemctl restart containerd

# crictl을 위한 설정 파일 생성
vi /etc/crictl.yaml
#========== 수정 내용 ==========
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: true
#===========================

# k8s pkg 설치
dnf install -y kubeadm-1.28.2-0 kubelet-1.28.2-0 kubectl-1.28.2-0 --disableexcludes=kubernetes

#Master#1
# Image 정상적으로 받아지는지 확인
kubeadm config images pull
crictl images

kubeadm init --control-plane-endpoint=k8s.jjd.com:6443 --service-cidr=192.168.0.0/24 --pod-network-cidr=10.252.0.0/16 --upload-certs
>kubeadm join l4.jjd.com:6443 --token ocyga0.hmghb1j1gmm0uluk \
        --discovery-token-ca-cert-hash sha256:ebe35614fb87ca936e0f86ad130bf7cf41023b38b6d70662d82b74176daba1d5 \
        --control-plane --certificate-key fe1223fd6319534a3b7642f4c6befee609676a00b7948b38cbe93a7744bb8880
>kubeadm join l4.jjd.com:6443 --token ocyga0.hmghb1j1gmm0uluk \
        --discovery-token-ca-cert-hash sha256:ebe35614fb87ca936e0f86ad130bf7cf41023b38b6d70662d82b74176daba1d5        

#kubectl 실행할 환경 변수 설정 등
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

# 네트워크 추가 (calico-3.26.4.yaml 미리 준비)
kubectl apply -f calico.yaml 

# node ready 상태 확인
kubectl get pods -o wide


#Master#2,3
kubeadm join l4.jjd.com:6443 --token ocyga0.hmghb1j1gmm0uluk \
        --discovery-token-ca-cert-hash sha256:ebe35614fb87ca936e0f86ad130bf7cf41023b38b6d70662d82b74176daba1d5 \
        --control-plane --certificate-key fe1223fd6319534a3b7642f4c6befee609676a00b7948b38cbe93a7744bb8880


#Worker
kubeadm join ... <--- worker 추가 스크립트
kubeadm join l4.jjd.com:6443 --token ocyga0.hmghb1j1gmm0uluk \
        --discovery-token-ca-cert-hash sha256:ebe35614fb87ca936e0f86ad130bf7cf41023b38b6d70662d82b74176daba1d5

#Worker Node Label 설정
#Master#1
kubectl label node worker1 node-role.kubernetes.io/worker=
kubectl label node worker2 node-role.kubernetes.io/worker=
kubectl label node worker3 node-role.kubernetes.io/worker=
kubectl label node worker4 node-role.kubernetes.io/worker=
kubectl label node worker5 node-role.kubernetes.io/worker=

kubectl label node worker1 cpuspec=core48
kubectl label node worker2 cpuspec=core48
kubectl label node worker3 cpuspec=core48
kubectl label node worker4 cpuspec=core48
kubectl label node worker5 cpuspec=core48
```



## 3. Kubernetes Reset

```bash
# 전체 Node
kubeadm reset
rm -rf /etc/cni/net.d/*
iptables -F; iptables -t nat -F; iptables -t mangle -F

# L4 Switch 통한 연결 : l4.jjd.com:6443
kubeadm init --control-plane-endpoint=l4.jjd.com:6443 --service-cidr=192.168.0.0/24 --pod-network-cidr=10.252.0.0/16 --upload-certs
>kubeadm join l4.jjd.com:6443 --token ocyga0.hmghb1j1gmm0uluk \
        --discovery-token-ca-cert-hash sha256:ebe35614fb87ca936e0f86ad130bf7cf41023b38b6d70662d82b74176daba1d5 \
        --control-plane --certificate-key fe1223fd6319534a3b7642f4c6befee609676a00b7948b38cbe93a7744bb8880
>kubeadm join l4.jjd.com:6443 --token ocyga0.hmghb1j1gmm0uluk \
        --discovery-token-ca-cert-hash sha256:ebe35614fb87ca936e0f86ad130bf7cf41023b38b6d70662d82b74176daba1d5

#환경 변수 설정 등
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

# 네트워크 추가 (calico-3.26.4.yaml 미리 준비)
kubectl apply -f calico.yaml

# node ready 상태 확인
kubectl get pods -o wide

#Master#2,3
kubeadm join l4.jjd.com:6443 --token ocyga0.hmghb1j1gmm0uluk \
        --discovery-token-ca-cert-hash sha256:ebe35614fb87ca936e0f86ad130bf7cf41023b38b6d70662d82b74176daba1d5 \
        --control-plane --certificate-key fe1223fd6319534a3b7642f4c6befee609676a00b7948b38cbe93a7744bb8880

#Worker
kubeadm join l4.jjd.com:6443 --token ocyga0.hmghb1j1gmm0uluk \
        --discovery-token-ca-cert-hash sha256:ebe35614fb87ca936e0f86ad130bf7cf41023b38b6d70662d82b74176daba1d5

#Worker Node Label 설정
#Master#1
kubectl label node worker1 node-role.kubernetes.io/worker=
kubectl label node worker2 node-role.kubernetes.io/worker=
kubectl label node worker3 node-role.kubernetes.io/worker=
kubectl label node worker4 node-role.kubernetes.io/worker=
kubectl label node worker5 node-role.kubernetes.io/worker=

kubectl label node worker1 cpuspec=core48
kubectl label node worker2 cpuspec=core48
kubectl label node worker3 cpuspec=core48
kubectl label node worker4 cpuspec=core48
kubectl label node worker5 cpuspec=core48
```

