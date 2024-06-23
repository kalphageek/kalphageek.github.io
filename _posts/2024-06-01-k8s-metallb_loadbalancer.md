---
layout: single
title: "K8S loadbalancer"
categories: k8s
tag: [loadbalancer, metallb, ingress, controller]
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



## 2. service 와 deployment 구성

```bash
#/ : deploy-nginx.yaml (https://github.com/sysnet4admin/_Lecture_k8s_learning.kit/blob/main/ch4/4.8/deploy-nginx.yaml)
#/ip : deploy-ip.yaml (https://github.com/sysnet4admin/_Lecture_k8s_learning.kit/blob/main/ch4/4.8/deploy-ip.yaml)
#/hn : deploy-hn.yaml (https://github.com/sysnet4admin/_Lecture_k8s_learning.kit/blob/main/ch4/4.8/deploy-hn.yaml)
# pod와 service생성, service는 ClusterIp타임으로 생성

k apply -f deploy-nginx.yaml
k apply -f deploy-ip.yaml
k apply -f deploy-hn.yaml
k get svc
---
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
ing-default   ClusterIP   10.96.243.0     <none>        80/TCP    2m35s
ing-hn        ClusterIP   10.100.27.34    <none>        80/TCP    2m48s
ing-ip        ClusterIP   10.104.223.39   <none>        80/TCP    2m22s
```



## 3. ingress 구성

```bash
# ingress.yaml (https://github.com/sysnet4admin/_Lecture_k8s_learning.kit/blob/main/ch4/4.8/ingress.yaml)
# /, /ip, /hn에 대한 rounting설정

cat ingress.yaml
--
# /로 request되면 svc중 ing-default가 동작한다.
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ing-default

k apply -f ingress.yaml
k get ingress
--
NAME            CLASS    HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   <none>   *                 80      8s
```



## 3. ingress controller (LoadBalancer) 구성

```bash
# metallb가 미리 설치되어 있어야 한다.
k get po -n metallb-system
--
NAME                          READY   STATUS    RESTARTS       AGE
controller-6658b8446c-w4gsh   1/1     Running   10 (24h ago)   22d
speaker-6s7g4                 1/1     Running   8 (24h ago)    22d
speaker-7jqwj                 1/1     Running   9 (24h ago)    22d
speaker-p8msh                 1/1     Running   9 (24h ago)    22d
```

```bash
# metallb 설치시 할당한 ip range로 부터 External-IP가 하나 설정된다. 이걸통해 ingress.yaml에 설정된 uri를 routing한다
k apply -f ingress_ctrl_loadbalancer.yaml
k get svc -n ingress-nginx 
--
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.106.1.75     192.168.10.11   80:30032/TCP,443:30486/TCP   19s
ingress-nginx-controller-admission   ClusterIP      10.101.137.86   <none>          443/TCP                      19s

# EXTERNAL-IP를 통해 service 접근
curl 192.168.10.11
curl 192.168.10.11/ip
curl 192.168.10.11/hn
```



## * Ingress Controller YAML

```yaml
# ingress_ctrl_loadbalancer.yaml (https://github.com/sysnet4admin/_Lecture_k8s_learning.kit/blob/main/ch4/4.8/ingress_ctrl_loadbalancer.yaml)
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
    app.kubernetes.io/version: 1.3.1
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - appProtocol: http
    name: http
    port: 80
    protocol: TCP
    targetPort: http
  - appProtocol: https
    name: https
    port: 443
    protocol: TCP
    targetPort: https
  selector:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  type: LoadBalancer
---
```



