---
layout: single
title: "K8S loadbalancer"
categories: k8s
tag: [loadbalancer, metallb]
toc: true
toc_sticky: true
#author_profile: false


---



## 1. MetalLb 설치 및 LoadBalancer 테스트

```bash
ssh m-k8s
# metallb 설치
k apply -f _Lecture_k8s_starter.kit/ch2/2.4/metallb.yaml
# deployment 생성
k create deployment chk-hn --image=sysnet4admin/chk-hn
# deployment의 pod를 3개 생성
k scale deployment chk-hn replicas=3
# LoadBalancer를 이용해 virtual ip (192.168.10.11)로 서비스 노출
k expose deployment chk-hn --type=LoadBalancer --port=80
k get svc
NAME           TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)        AGE
chk-hn         LoadBalancer   10.103.175.120   192.168.10.11   80:30685/TCP   8s
kubernetes     ClusterIP      10.96.0.1        <none>          443/TCP        4d8h
exit

--
curl 192.168.10.11
chk-hn-7c4c768876-5ckt6
```



## 2. 삭제하기

```bash
k delete svc chk-hn
k delete deploy chk-hn
#k delete po nginx
k delete -f _Lecture_k8s_starter.kit/ch2/2.4/metallb.yaml
```

