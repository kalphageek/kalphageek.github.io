---
layout: single
title: "K8S Setup RHEL 8.4(Manual)"
categories: k8s
tag: [rhel8, k8s, l4, containerd]
toc: true
toc_sticky: true
#author_profile: false

---



## 1. RHEL 8.4에서 Containerd 기반 Kubernetes 설치

### 1. 서버 환경 설정

- 마스터 노드 3대와 워커 노드 5대를 구성한다.
- 하드웨어 레벨 4(L4) 로드 밸런서를 사용하여 마스터 노드 앞에 로드 밸런서를 구성한다.

### 2. Containerd 설치

Containerd는 RHEL 8의 기본 컨테이너 런타임입니다. 따라서 별도의 설치가 필요하지 않을 수 있습니다. 필요한 경우, 추가 패키지를 설치하십시오.

### 3. Kubernetes 설치

Kubernetes를 설치하는 데 `kubeadm`, `kubelet`, 및 `kubectl`을 사용합니다.

- 마스터 노드에서 다음 명령을 실행하여 Kubernetes 관련 패키지를 설치합니다:

```bash
sudo dnf install -y kubeadm kubelet kubectl
```

- 워커 노드에서도 위의 명령을 실행하여 필요한 패키지를 설치합니다.

### 4. 마스터 노드 설정

마스터 노드에서 Kubernetes를 초기화하고 클러스터를 설정합니다. 마스터 노드 중 하나에서만 실행하십시오.

```bash
sudo kubeadm init --control-plane-endpoint=YOUR_LOAD_BALANCER_IP:6443 --pod-network-cidr=10.244.0.0/16
```

위 명령에서 `YOUR_LOAD_BALANCER_IP`를 로드 밸런서 IP로 대체해야 합니다.

### 5. 마스터 노드 설정 계속

위 명령이 완료되면 출력에 나오는 명령어를 마스터 노드에 실행하여 클러스터를 설정합니다.

### 6. 워커 노드 조인

나머지 워커 노드에서 다음 명령을 실행하여 클러스터에 조인합니다. 마스터 노드에서 제공하는 `kubeadm join` 명령을 사용합니다.

### 7. 네트워크 플러그인 설치

마스터 노드에서 다음 명령을 사용하여 Calico 네트워크 플러그인을 설치합니다. 

```bash
kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml
```

### * Containerd 설치

Containerd를 설치합니다.

```bash
sudo dnf update && sudo dnf install -y containerd
```

Containerd를 구성합니다.

```bash
sudo mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
```

Containerd 서비스를 재시작합니다.

```bash
sudo systemctl restart containerd
```



## 2. Kubernetes 클러스터 동작 테스트

### 1. kubectl 설정 확인

먼저, `kubectl` 설정 파일 (`~/.kube/config`)을 열어서 도메인 이름이 올바르게 설정되었는지 확인합니다. 이미 앞서 수정하였지만, 한 번 더 확인하는 것이 좋습니다.

### 2. Kubernetes 클러스터에 연결 확인

다음 명령을 사용하여 Kubernetes 클러스터에 연결합니다.

```bash
kubectl cluster-info
```

이 명령을 실행하면 클러스터의 상태와 관련된 정보가 표시됩니다. 마스터 노드의 API 서버 URL이 "[https://kalphageek-k8s.domain.pe:6443"](https://kalphageek-k8s.domain.pe:6443") 로 표시되어야 합니다.

### 3. 노드 목록 확인

다음 명령을 사용하여 클러스터의 노드 목록을 확인합니다. 이 명령을 실행하면 클러스터에 등록된 모든 노드의 목록이 표시됩니다. 노드가 올바르게 표시되고 상태가 "Ready"로 나타나야 합니다.

```bash
kubectl get nodes
```

### 4. 파드 배포 및 서비스 테스트

Kubernetes 클러스터가 올바르게 작동하는지 확인하기 위해 간단한 파드를 배포하고 서비스를 생성하여 테스트할 수 있습니다.

예를 들어, 다음 YAML 파일을 사용하여 Nginx 파드와 서비스를 배포할 수 있습니다.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
```

이 YAML 파일을 저장하고 다음 명령을 사용하여 파드와 서비스를 배포합니다.

```bash
kubectl apply -f nginx.yaml
```

그런 다음, 서비스가 완전히 배포되고 외부 IP 주소가 할당되는지 확인하기 위해 다음 명령을 사용합니다.

```bash
kubectl get svc nginx-service
```

외부 IP 주소가 할당되면 웹 브라우저 또는 `curl`과 같은 도구를 사용하여 해당 IP 주소로 접속하여 Nginx 웹 페이지에 액세스할 수 있습니다. 이를 통해 Kubernetes 클러스터가 도메인을 통해 서비스에 접속하는 것을 확인할 수 있습니다.

이러한 단계를 통해 Kubernetes 클러스터가 "kalphageek-k8s.domain.pe" 도메인을 통해 올바르게 동작하는지 확인할 수 있습니다.