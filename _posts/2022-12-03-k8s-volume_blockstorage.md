---
layout: single
title: "K8S Volume - Block Storage"
categories: k8s
tag: [block, storage, pv, pvc]
#author_profile: false

---

> 주로 SAN(Storage Area Network)를 기반으로 생성한다. 동시에 2개이상의 Node에서 연결을 허용하지 않고, 많은 데이터를 처리하는데 잇점이 있어서 DB를 구성하는데 사용된다.

https://kubetm.github.io/k8s/07-intermediate-basic-resource/volume2/

## 1. Longhorn 설치

```bash
# isici Interface - 모든 Node에 설치
$ yum install -y iscsi-initiator-utils7

# Longhorn - Master에만 설치
$ kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/master/deploy/longhorn.yaml

# 확인 - 전체 pod가 Running 상태면 완료 (2-3분 소요)
$ kubectl get pods -n longhorn-system
```



## 2. 개발환경 조정

> Replicas를 3 -> 2로 변경해야 한다. 이를 위해 기존 Storage Class를 삭제하고 다시 생성한다.

```bash
# Pod 확인
$ kubectl get storageclasses.storage.k8s.io -n longhorn-system longhorn
# StorageClass의 상세정보 확인
$ kubectl describe storageclasses.storage.k8s.io -n longhorn-system longhorn
# 삭제
$ kubectl delete storageclasses.storage.k8s.io -n longhorn-system longhorn
# StorageClass의 replicas 변경 생성
$ cat <<EOF | kubectl create -f -
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: longhorn
provisioner: driver.longhorn.io
allowVolumeExpansion: true
parameters:
  numberOfReplicas: "2"
  staleReplicaTimeout: "2880"
  fromBackup: ""
EOF
# Longhorn Dashboard 접속을 위한 Port 변경
$ kubectl edit svc -n longhorn-system longhorn-frontend
spec:
  ports:
  - name: http
    nodePort: 30001 # 추가
type: NodePort # ClusterIP -> NodePort
```



## 3. Pod 생성

> Block Storage를 "/longhorn/data" " 에 Volume mount한 Pod 생성

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-blockstorage
spec:
  containers:
  - name: container
    image: kubetm/init
    volumeMounts:
    - name: volume-blockstorage
      mountPath: /longhorn/data
  volumes:
  - name : volume-blockstorage
    persistentVolumeClaim:
      claimName: longhorn-pvc
```



## 4. Longhorn Volume Attachments 확인

```bash
$ kubectl get -n longhorn-system volumeattachments.storage.k8s.io
```



## 5. Block Storage의 Dashboard 보기

```html
http://192.168.56.30:30001
```



