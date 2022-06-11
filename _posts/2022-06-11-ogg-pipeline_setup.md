---
layout: single
title: "OGG Pipeline Setup 방법"
categories: ogg
tag: [ogg, setup, extract, pump, example]
toc: true
#author_profile : false
---

## 1. Supplemental Log 설정 (소스DB)
### 1. Supplemental log 설정 

```sql
$ sqlplus / as sysdba
> show parameter enable_goldengate;
> alter system set enable_goldengate_replication=true scope=both;
> show parameter enable_goldengate
> select supplemental_log_data_min, force_logging from v$database;
> alter database add supplemental log data;
> alter database force logging;
> alter system switch logfile;
> select supplemental_log_dadevta_min, force_logging from v$database;
```
### , sample2. DB User

* Extract 용 계정 생성 : c##OGG_Admin
* OGG 권한 설정
```sql
> exec dbms_goldengate_auth.grant_admin_privilege('C##OGG_ADMIN', container=>'all');
```

### 3. Schmatrandata 적용

```
> ggsci
> DBLogin UserID c##OGG_Admin@amer, Password oracle_4U
> add schematrandata west [allcols]
> info schematrandata west
```

## 2. Downstream 구축

### 1. Manager 설정

- 소스DB (Downstream DB)

```
> ggsci
> edit param mgr
PORT 7809
DynamicPortList 20000-20099
PurgeOldExtracts ./dirdat/*, UseCheckPoints, MinKeepHours 2
Autostart Extract E*Ctrl+2

AUTORESTART Extract *, WaitMinutes 1, Retries 3
:wq

> stop mgr
> start mgr
```

- 타겟DB (Trail Server)

```
PORT 7909
DynamicPortList 20100-20199
PurgeOldExtracts ./dirdat/pe*, UseCheckPoints, MinKeepHours 2
Autostart Replicat R*
AUTORESTART Replicat *, WaitMinutes 1, Retries 3
:wq

> stop mgr
> start mgr
```

### 2. Add Extract, sample

```sql
-- 소스DB에 접속 (Alias 이용)
> DBLogin UserIdAlias oggalias
> Edit Param myext
-- Extract를 소스DB에 먼저 등록, Integratpipelined 방식인 경우 필요 
> Register Extract myext database
# Redolog를 현재 redolog가 만들어지는 지점부터 capture하겠다는 의미
> Add Extract myext, Integrated TranLog, Begin Now
# Local Trail을 lt라는 이름으로 만든다. default 500MB
> Add ExtTrail /ggs/dirdat/lt, Extract myext, Megabytes 10
-- Extract 실행
> start Extract myext
-- 일련의 명령을 스크립트로 실행
> obey myscript.oby
```
### 3. Add Pump

```sql
-- Pump를 생성할 때는 Local Trail의 위치를 지정한다
> Add Extract mypump, ExtTrailSource /ggs/dirdat/lt
```
### 4. Add Initial Load Extract

```sql
-- Initial Load Extract는 타Supplemental log 설정 입이 SourceIsTable이다
> Add Extract myload, SourceIsTable
```

## dev3. 타겟DB
### 1. DB User

* Replicat 용 계정 생성

##  4. 기타 - DB계정 필요 권한

|                               |                  |                    |
| ----------------------------- | ---------------- | ------------------ |
| User Privilege                | Extract (Source) | Replicate (Target) |
| CREATE SESSION, ALTER SESSION | X                | X                  |
| RESOURCE                      | X                | X                  |
| CONNECT                       | X                | X                  |
| ALTER ANY TABLE               | X                |                    |
| ALTER SYSTEM                  | X                |                    |
| DBA                           | X                | X                  |
| INSERT, UPDATE, DELETE ON     |                  | X                  |
| LOCK ANY TABLE                |                  | X                  |
| SELECT ANY TRANSACTION        | X                |                    |

---