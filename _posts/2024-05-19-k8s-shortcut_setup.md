---
layout: single
title: "K8S Shortcut Setup"
categories: k8s
tag: [shortcut, bash-completion]
toc: true
toc_sticky: true
#author_profile: false

---



```
kubectl 명령어와 옵션을 shortcut으로 사용할 수 있도록 bash-completion기능을 사용해 자동완성을 설정한다
```



### 1. k get pods

```bash
# install bash-completion for kubectl
yum install bash-completion -y

# kubectl completion on bash-completion dir
kubectl completion bash > /etc/bash_completion.d/kubectl

# alias kubectl to k
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
```


