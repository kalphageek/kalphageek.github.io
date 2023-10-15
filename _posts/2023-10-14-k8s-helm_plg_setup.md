---
layout: single
title: "K8S PLG(Promtail, Loki, Grafana) 스택 설치"
categories: k8s
tag: [promtail, loki, grafana, logging]
toc: true
toc_sticky: true
#author_profile: false

---



# 1. PLG 설치

```bash
$ curl -O https://get.helm.sh/helm-v3.13.0-linux-amd64.tar.gz
$ tar -xf helm-v3.13.0-linux-amd64.tar.gz
$ cd linux-amd64/
$ cp helm /usr/local/bin/
$ helm version
$ helm helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update
```

https://artifacthub.io/packages/helm/grafana/loki-stack

Namespace 생성

```bash
$ kubectl create ns loki-stack
```



Helm 설치 - loki-stack

```bash
$ helm upgrade --install loki-stack --namespace=loki-stack grafana/loki-stack \
    --set fluent-bit.enabled=false,promtail.enabled=true,grafana.enabled=true 
$ helm uninstall loki-stack -n loki-stack
```



Grafana Service

```bash
$ kubectl edit -n loki-stack svc loki-stack-grafana
----
type: NodePort
nodePort : 30000
----
$ kubectl get secret --namespace loki-stack loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
XGc7VpUqTCc9x2E6CrA8AKmypy8naxqIz2RAFA58
# http://master:30000
# admin / XGc7VpUqTCc9x2E6CrA8AKmypy8naxqIz2RAFA58
$ # kubectl port-forward --namespace loki-stack service/loki-stack-grafana 30000:80
```

