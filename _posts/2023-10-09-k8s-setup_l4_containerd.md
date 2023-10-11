---
layout: single
title: "K8S Setup (Manual)"
categories: k8s
tag: [setup, k8s, l4, containerd]
toc: true
toc_sticky: true
#author_profile: false


---



# * Containerd 기반 Kubernetes 설치

### 1. 서버 환경 설정

- 마스터 노드 3대와 워커 노드 5대를 구성한다.
- 하드웨어 레벨 4(L4) 로드 밸런서를 사용하여 마스터 노드 앞에 로드 밸런서를 구성한다.

### 2. 마스터 노드 설정

마스터 노드에 Kubernetes를 설치합니다.

```bash
# 마스터 노드에서 필요한 도구 설치
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

# Kubernetes 설치
sudo apt-get install -y kubelet kubeadm kubectl
```

Kubernetes 초기화를 수행합니다.

```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

마스터 노드에 kubeconfig 파일을 설정합니다.

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Calico 네트워크 플러그인을 설치합니다. 

```
kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml
```

### 3. 워커 노드 설정

각 워커 노드에서 Kubernetes 도구를 설치합니다.

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
```

마스터 노드에서 발급한 `kubeadm join` 명령을 실행하여 워커 노드를 클러스터에 추가합니다.

### 4. Containerd 설치

모든 노드에 Containerd를 설치합니다.

```bash
sudo apt-get update && sudo apt-get install -y containerd
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

### 5. 클러스터 상태 확인

마스터 노드에서 다음 명령을 사용하여 클러스터 상태를 확인합니다.

```bash
kubectl get nodes
```

워커 노드들이 모두 Ready 상태로 나타나면 Kubernetes 클러스터가 성공적으로 설정된것 입니다.



# * K8S 클러스터에 Worker노드 추가

### 1. 마스터 노드에서 워커 노드 가입 명령 생성

마스터 노드에서 클러스터에 워커 노드를 추가하기 위해 다음 명령을 생성합니다.  이 명령을 실행하면 출력으로 `kubeadm join` 명령어가 생성됩니다.

```bash
sudo kubeadm token create --print-join-command
```

### 2. 워커 노드에서 `kubeadm join` 명령 실행

워커 노드로 이동하고, 마스터 노드에서 생성한 `kubeadm join` 명령을 실행합니다. 이렇게 하면 워커 노드가 마스터 노드와 클러스터에 가입합니다.

```bash
sudo kubeadm join <마스터_노드_IP>:<포트> --token <토큰> --discovery-token-ca-cert-hash sha256:<해시>
```

   여기서 다음과 같은 변수를 채워 넣어야 합니다:

- `<마스터_노드_IP>`: 마스터 노드의 IP 주소 또는 호스트 이름.
- `<포트>`: 마스터 노드에서 사용 중인 Kubernetes API 서버 포트 (기본값은 6443).
- `<토큰>`: `kubeadm token create` 명령으로 생성한 토큰.
- `<해시>`: `kubeadm token create` 명령으로 생성한 토큰의 해시.

### 3. 워커 노드 가입 확인

`kubeadm join` 명령이 성공적으로 실행되면, 마스터 노드에서 다음 명령을 실행하여 워커 노드의 가입 상태를 확인할 수 있습니다.

```bash
kubectl get nodes
```

워커 노드가 Ready 상태로 나타나면 클러스터에 성공적으로 가입한 것입니다.



# * L4 domain을 통한 kubernetes api server 연결 구성

### 1. Kubernetes API 서버 구성 변경

마스터 노드의 Kubernetes API 서버 구성 파일을 편집하여 도메인 이름을 수용하도록 설정을 변경합니다.

- Kubernetes API 서버 구성 파일을 엽니다. 기본적으로 `/etc/kubernetes/manifests/kube-apiserver.yaml` 경로에 위치합니다. 다음과 같이 명령을 실행하여 편집합니다.

  ```bash
  sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
  ```

- `kube-apiserver.yaml` 파일 내에서 `--bind-address` 및 `--insecure-bind-address` 플래그를 모두 0.0.0.0으로 변경합니다. 이렇게 하면 API 서버가 모든 IP 주소에서 요청을 수락합니다.

  ```yaml
  spec:
    containers:
    - command:
      - kube-apiserver
      - --bind-address=0.0.0.0
      - --insecure-bind-address=0.0.0.0
      ...
  ```

- 또한 `--advertise-address` 플래그를 사용하여 API 서버가 도메인 이름을 사용하도록 설정합니다. 여기서 "dkalphageek-k8s.domain.pe"은 사용하려는 도메인 이름입니다.

  ```yaml
  spec:
    containers:
    - command:
      - kube-apiserver
      - --bind-address=0.0.0.0
      - --insecure-bind-address=0.0.0.0
      - --advertise-address=kalphageek-k8s.domain.pe
      ...
  ```

### 2. Kubernetes API 서버 재시작

API 서버 구성을 변경한 후에는 Kubernetes API 서버를 재시작해야 합니다.

```bash
sudo systemctl restart kubelet
```

### 3. DNS 설정

"kalphageek-k8s.domain.pe" 도메인이 올바르게 해석되도록 DNS 서버에 등록되어 있는지 확인합니다. DNS 레코드가 올바르게 구성되어 있어야 합니다.

### 4. Kubectl 구성 파일 수정

`kubectl` 명령을 사용하여 Kubernetes 클러스터에 연결할 때도 "kalphageek-k8s.domain.pe" 도메인을 사용할 수 있도록 `~/.kube/config` 파일을 편집합니다. 다음과 같이 클러스터에 대한 서버 URL을 도메인으로 변경합니다.

```yaml
clusters:
- cluster:
    certificate-authority-data: <certificate_authority_data>
    server: https://kalphageek-k8s.domain.pe:6443  # 도메인으로 변경
  name: kubernetes
```

`<certificate_authority_data>` 부분은 클러스터 구성에 따라 다를 수 있습니다. `kubectl` 구성 파일을 변경한 후에는 `kubectl`을 사용하여 클러스터에 액세스할 때 도메인을 사용할 수 있습니다.

이제 "kalphageek-k8s.domain.pe" 도메인을 통해 Kubernetes API 서버에 접속할 수 있어야 합니다. 이 설정을 사용하여 클러스터에 연결하고 명령을 실행할 수 있습니다.



# * Kubernetes 클러스터 동작 테스트

### 1. kubectl 설정 확인

먼저, `kubectl` 설정 파일 (`~/.kube/config`)을 열어서 도메인 이름이 올바르게 설정되었는지 확인합니다. 이미 앞서 수정하였지만, 한 번 더 확인하는 것이 좋습니다.

### 2. Kubernetes 클러스터에 연결 확인

다음 명령을 사용하여 Kubernetes 클러스터에 연결합니다.

```bash
kubectl cluster-info
```

이 명령을 실행하면 클러스터의 상태와 관련된 정보가 표시됩니다. 마스터 노드의 API 서버 URL이 "[https://kalphageek-k8s.domain.pe:6443"](https://kalphageek-k8s.domain.pe:6443") 로 표시되어야 합니다.

### 3. 노드 목록 확인

다음 명령을 사용하여 클러스터의 노드 목록을 확인합니다.

```bash
kubectl get nodes
```

이 명령을 실행하면 클러스터에 등록된 모든 노드의 목록이 표시됩니다. 노드가 올바르게 표시되고 상태가 "Ready"로 나타나야 합니다.

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