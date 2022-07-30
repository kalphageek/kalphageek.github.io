---
layout: single
title: "Nifi Example #1"
categories: nifi
tag: [nifi, example]
toc: true
toc_sticky: true
#author_profile : false
---



### 1. csv파일조인

csv파일 2개를 조인해서 새로운 결과셋을 만든다

 [csv파일조인.xml](../../../Downloads/csv파일조인.xml) 

Input 1 :

```
ct_id, ct_amount, ct_mgr_id
1, 10000, 100
2, 15000, 200
3, 20000, 100
4, 13000, 300
```

Input 2 :

```
mgr_id, mgr_name
100, Jeong
200, Hong
300, Kang
400, Choi
```

Output : 

```
ct_id,ct_amount,mgr_name
1,10000,Jeong
2,15000,Hong
3,20000,Jeong
4,13000,Kang 
```



