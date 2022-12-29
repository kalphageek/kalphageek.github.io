---
layout: single
title: "K8S Volume - StorageOS"
categories: k8s
tag: [volume, storage, dynimic, provisioning, pv, pvc]
toc: true
toc_sticky: true
#author_profile: false

---



> StorageOS는 Dynamic Provisioning을 지원하며, pvc를 생성하면 자동으로 pv가 생성된다.

https://kubetm.github.io/k8s/07-intermediate-basic-resource/volume/

## 1. StorageOS 설치

### 1) StorageOS Operator 설치

> StorageOS 관리용 툴

```bash
# 1. 설치
$ kubectl apply -f https://github.com/storageos/cluster-operator/releases/download/1.5.0/storageos-operator.yaml
# 2. 설치 확인
$ kubectl get all -n storageos-operator
# 3. Depolyment 수정 -> PVC생성시 StorageName: "" 인식할 수 있도록 함
$ kubectl edit deployments.apps storageos-cluster-operator -n storageos-operator
spec:
  containers:
  - command:
    - cluster-operator
    env:
    - name: DISABLE_SCHEDULER_WEBHOOK
      value: "false"    #true 로 변경
    image: storageos/cluster-operator:1.5.0
    imagePullPolicy: IfNotPresent
    
# 4. 관리 계정을 위한 Secret 생성 (username 및 password를 Base64문자로 만들기)
$ echo -n "admin" | base64
$ echo -n "1234" | base64
# 5. apiUsername 및 apiPassword 부분에 4.의 결과로 나온 문자 넣기
$ kubectl create -f - <<END
apiVersion: v1
kind: Secret
metadata:
  name: "storageos-api"
  namespace: "storageos-operator"
  labels:
    app: "storageos"
type: "kubernetes.io/storageos"
data:
  apiUsername: YWRtaW4=  # admin
  apiPassword: MTIzNA==  # 1234
END
```

### 2) StorageOS 설치

```bash
# 1. StorageOS 설치 트리거 생성
$ kubectl apply -f - <<END
apiVersion: "storageos.com/v1"
kind: StorageOSCluster
metadata:
  name: "example-storageos"
  namespace: "storageos-operator"
spec:
  secretRefName: "storageos-api" # Reference the Secret created in the previous step
  secretRefNamespace: "storageos-operator"  # Namespace of the Secret
  k8sDistro: "kubernetes"
  images:
    nodeContainer: "storageos/node:1.5.0" # StorageOS version
  resources:
    requests:
    memory: "512Mi"
END
# 2. 설치 확인
$ kubectl get all -n storageos
# 3. Dashboard 접속을 위한 Service 수정
$ kubectl edit service storageos -n storageos
# 4. type을 NodePort로 변경
spec:
  ports:
  - name: storageos
    port: 5705
    protocol: TCP
    targetPort: 5705
    nodePort: 30705  # port 번호 추가https://kubetm.github.io/k8s/07-intermediate-basic-resource/volume2/
  type: NodePort     # type 변경
```

### 3) StorageOS Dashboard 접속

> http://192.168.0.30:30705/ -> admin/1234

### 4) Default StorageClass 추가

```bash
$ kubectl apply -f - <<END
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: default
  annotations: 
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/storageos
parameters:
  adminSecretName: storageos-api
  adminSecretNamespace: storageos-operator
  fsType: ext4
  pool: default
END
# 2. StorageClass 확인
$ kubectl get storageclasses.storage.k8s.io
```



## 2. Dynamic Provisioning

### 1) PVC 생성

> 자동으로 PV도 함께 생성되며, StorageOS Dashboard에서 확인 가능. PVC를 삭제하면 PV도 자동 삭제 된다.

```yaml
# 1. storageClassName: "fast"
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-fast1
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1G
  storageClassName: "fast"
  
---
# 2. storageClassName: default
apiVersion: v1https://kubetm.github.io/k8s/07-intermediate-basic-resource/volume2/
kind: PersistentVolumeClaim
metadata:
  name: pvc-default1
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 2G
```



## 3. Pod 생성

### 1) Pod 생성

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-hostpath1
spec:
  nodeSelector:
    kubernetes.io/hostname: k8s-node1
  terminationGracePeriodSeconds: 0
  containers:
  - name: container
    image: kubetm/init
    volumeMounts:
    - name: hostpath
      mountPath: /mount1
  volumes:
  - name: hostpath
    persistentVolumeClaim:
      claimName: pvc-hostpath1
```

### 2) Pod의 CLI

```bash
# 파일 생성
$ cd /mount1
touch file.txt
```

### 3) Dashboard 확인

http://192.168.0.30:30705/ 
