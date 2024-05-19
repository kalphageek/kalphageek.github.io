---
layout: single
title: "K8S version upgrade"
categories: k8s
tag: [upgrade, plan]
toc: true
toc_sticky: true
#author_profile: false

---



```
upgrade plan -> kubeadm upgrade -> kubelet upgrade -> restart
```

### 1. Upgrade plan

```bash
# version 확인
kubectl get nodes
NAME         STATUS   ROLES           AGE    VERSION
k8s-master   Ready    control-plane   142d   v1.27.2
k8s-node1    Ready    <none>          142d   v1.27.2
k8s-node2    Ready    <none>          142d   v1.27.2

# plan : 현재버전과 목표버전을 보여준다
kubeadm upgrade plan
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: v1.27.9
[upgrade/versions] kubeadm version: v1.27.2
I0519 21:33:14.145625   30592 version.go:256] remote version is much newer: v1.30.1; falling back to: stable-1.27
[upgrade/versions] Target version: v1.27.14
[upgrade/versions] Latest version in the v1.27 series: v1.27.14
...

```



### 2. Master upgrade

```bash

# kubeadm upgrade
yum upgrade kubeadm-1.27.14 -y
kubeadm upgrade apply 1.27.14
kubectl version
kubelet version

# kubelet upgrade
yum upgrade kubelet-1.27.14 -y

# kubelet restart
systemctl restart kubelet
systemctl daemon-reload

# upgrade 확인
kubectl get nodes
NAME         STATUS   ROLES           AGE    VERSION
k8s-master   Ready    control-plane   142d   v1.27.14
k8s-node1    Ready    <none>          142d   v1.27.2
k8s-node2    Ready    <none>          142d   v1.27.2

# worker node에 반복적용
```



### 3. Worker upgrade (모든 node에 동일 적용)

```bash
# kubeadm upgrade
# apply --> node
yum upgrade kubeadm-1.27.14 -y
kubeadm upgrade node 1.27.14
# kubeadm으로 클러스터 환경을 변경한적이 있으면 반드시 아래 명령어를 실행해야 한다.
kubectl -n kube-system get cm kubeadm-config -o yaml
kubelet version

# kubelet upgrade
yum upgrade kubelet-1.27.14 -y

# kubelet restart
systemctl restart kubelet
systemctl daemon-reload
```



### 4. Upgrade 확인

```bash
kubectl get nodes
NAME         STATUS   ROLES           AGE    VERSION
k8s-master   Ready    control-plane   142d   v1.27.14
k8s-node1    Ready    <none>          142d   v1.27.14
k8s-node2    Ready    <none>          142d   v1.27.14
```

