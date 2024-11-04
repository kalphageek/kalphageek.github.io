---
layout: single
title: "Ansible"
categories: k8s
tag: [ansible, install, yum, nameserver, resolv.conf, shell, copy, user, yum, ansible-playbook, blockinfile]
toc: true
toc_sticky: true
#author_profile: false


---



## 1. Yum 환경 설정

```bash
# dns 설정
vi /etc/resolv.conf
nameserver 168.126.63.1  # KT 공개서버

# ansible을 설시할 epel package 설치
yum repolist
yum install epel-release -y
```



## 2. 테스트(간단 명령어)

```bash
# 대상 노드 ip 등록 (default)
vi /etc/ansible/hosts
[k8s] #그룹명
192.168.56.30
192.168.56.31
192.168.56.32

# hosts전체에 대헤 ping 테스트 (-m:모듈명, -k:ask password)
ansible all -m ping -k
# k8s그룹에 대해 ping 테스트 (-K:sudo권한 적용을 위한 ask password)
ansible k8s -m ping -K

# 신규 inventory file 생성
vi /etc/ansible/worker_hosts
192.168.56.31
192.168.56.32

# inventory file에 대해서만 ping 테스트 (-i:inventory file, --list-hosts:적용된 host목록을 보여줌)
ansible all -m ping -k -i /etc/ansible/worker_hosts
```



## 3. 간단 명령어

```bash
# shell 명령어 : meomory 현황, -a :아규먼트
ansible all -m shell -a "free -h" -k

# user 명령어 - password는 암호화해야 한다.
ansible all -m user -a "name=bloter password=1234" -k	

# copy 명령어 - worker 그룹만 적용
ansible worker -m copy -a "src=/etc/ansible/test/bloter.file dest=/tmp" -k

# yum 명령어
ansible worker -m yum -a "name=httpd state=present" -k
# yum list installed |grep httpd
```



## 4. 간단 Playbook

```bash
vi bloter.yml
---
- name: Ansible_vim
  hosts: localhost #현재 node
  
  tasks:
    - name: Add ansible hosts
      blockinfile: #파일에 그대로 쓰기
          path: /etc/ansible/hosts
          block: | #여기부터 끝까지
              [bloter]
              192.168.1.13
              
ansible-playbook bloter.yml
```



## 5. nginx 설치를 위한 playbook

```bash
# index.html 파일 다운로드
curl -o index.html https://www.nginx.com

vi nginx.yml
---
- hosts: worker
  remote_user: root
  tasks:
    - name: Install epel-release
      yum: name=epel-release state=latest
    - name: Install nginx web server
      yum: name=nginx state=present
    - name Upload index.html for web server
      copy: src=index.html dest=/usr/share/nginx/html/ mode=0644  #보안을 위해 write permission 제거
    - name: Start nginx web server
      service: name=nginx state=started
      
ansible-playbook nginx.yml
# ansible worker -m shell -a "systemctl stop firewalled" -k
```

