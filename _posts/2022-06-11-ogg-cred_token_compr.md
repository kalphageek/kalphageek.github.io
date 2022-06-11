---
layout: single
title: "OGG Credential, Token, Compress"
categories: ogg
tag: [ogg, common, example]
toc: true
#author_profile : false
---

## Credential

```sql
> Create Wallet # (Downstream DB)
> Add CredentialStore
-- 소스DB 접속
> Alter CredentialStore Add User c##OGG_Admin@amer Password oracle_4U Alias oggadmin_amer
-- 타겟DB 접속
> Alter CredentialStore Add User c##OGG_Admin@euro Password oracle_4U Alias oggadmin_euro
--- Container DB 접속
> Alter CredentialStore Add User c##OGG_Admin Password oracle_4U Alias oggadmin_root
> Info CredentialStore
> DBLogin UserIDAlias oggadmin_amer
> exit
-- Walet 과 Credential store를 타겟DB에 
$ cp -fr ./dirwlt ../oggtrg/
$ cp -fr ./dircrd ../oggtrg/
```

## Token

1. Set Sample

```sql
Extract extdemocommon
Table SALES.PRODUCT, TOKENS (
    (Token name) TKN-OSUSER = @GETENV ('GGENVIRONMENT', 
    'OSUSERNAMEsalesrpt'), 
    TKN-DOMAIN = @GETENV ('GcdcGENVIRONMENT', 'DOMAINNAME'), 
    TKN-COMMIT-TS = @GETENV ('GGHEADER', 'COMMITTIMESTAMP'), 
    TKN-BA-IND = @GETENV ('GGHEADER', 
    'BEFOREAFTERINDICATOR'), 
    TKN-TABLE = @GETENV ('GGHEADER', 'TABLENAME'), 
    TKN-OP-TYPE = @GETENV ('GGHEADER', 'OPTYPE'), 
    TKN-LENGTH = @GETENV ('GGHEADER', 'RECORDLENGTH'), 
    TKN-DB-VER = @GETENV ('DBENVIRONMENT', 'DBVERSION')
); 
```

2. Use Sample

```sql
Map SALES.ORDER, Target REPORT.ORDER_HISTORY,
    ColMap (USEDEFAULTS,
        TKN_NUMRECS = @TOKEN ('TKN-NUMRECS');cdc
Map SALES.CUSTOMER, Target REPORT.CUSTOMER_HISTORY,
    ColMap (USEDEFAULTS,
        TRAN_TIME = @TOKEN ('TKN-COMMIT-TS'),
OP_TYPE = @TOKEN ('TKN-OP-TYPE'), 
    BEFORE_AFTER_IND = @TOKEN ('TKN-BA-IND'),
        TKN_ROWID = @TOKEN ('TKN-ROWID'));
```

## Compression

```
--750 byte가 넘을 때만 압축하도록 한다
RmtHost newyork, MgrPort 7809, Compress, CompressThreshold 750
```

