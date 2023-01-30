---
layout: single
title: "Springboot 암호화/복호화"
categories: springboot
tag: [encrypt, decrypt, 대칭키, 비대칭키, bootstrap]
toc: true
toc_sticky: true
#author_profile: false

---



### 1. 대칭키를 이용한 암호화

> Bootstrap이 자동으로 '{cipher}'로 시작하는 yaml파일의 text를 decrypt 한다. 이 때 bootstrap.yml에 있는 key를 사용한다

1. Dependency 추가

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bootstrap</artifactId>
</dependency>
```

2. encrypt key 설정

- bootstrap.yml

```yaml
encrypt:
  key: 1234567890
```

3. Encrypt API 호출

```
[POST] http://localhost:8088/encrypt
[body > row > text]
[request body]
password
[return value]
01dc766ab8cdb62c2dc1b30853609965a522962f1fe10d6ad2ad8195fca2cffe
```

4. Decrypt API 호출 테스트

```
[POST] http://localhost:8088/decrypt
[body > row > text]
[request body]
01dc766ab8cdb62c2dc1b30853609965a522962f1fe10d6ad2ad8195fca2cffe
[return value]
password
```

5. 활용

- application.yml

```yaml
spring:
	security:
		user:
			name: admin
			password: '{cipher}01dc766ab8cdb62c2dc1b30853609965a522962f1fe10d6ad2ad8195fca2cffe'
```



### 2. 비대칭키를 이용한 암호화

> JDK의 keytool을 활용해서 private key와 public key 생성한다. 생성된 private key를 이용해 encrypt 하면 public key를 이용해 decrypt한다 (또는 그 반대)

1. Dependency 추가

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bootstrap</artifactId>
</dependency>
```

2. 비대칭키 생성

```bash
# key file 보관할 directory 생성
$cd ~/workspace/spring-learning/spring-cloud
$mkdir keystore
$cd keystore 

#private key 파일 생성
$keytool -genkeypair -alias apiEncryptionKey -keyalg RSA -dname "CN=Kalphageek, OU=API Development, O=me.kalpha, L=Seoul, C=KR" -keypass "test1234" -keystore apiEncryptionKey.jks -storepass "test1234"

#private key 확인
$ls -al
$keytool -list -keystore apiEncryptionKey.jks [-v]
password> test123

#인증서 파일 생성 : 여기서는 사용 안함
$keytool -export -alias apiEncryptionKey -keystore apiEncryptionKey.jks -rfc -file trustServer.cer
$ls -al

#public key 파일 생성 : 여기서는 사용 안함
$keytool -import -alias trustServer -file trustServer.cer -keystore publicKey.jks
password :> test1234
certificate?> yes

#파일 확인
#config-service에서는 private key만 사용
$ls -al
apiEncryptionKey.jks  #private key
publicKey.jks         #public key
trustServer.cer       #인증서
```

3. private key 설정

- bootstrap.yml

```yaml
encrypt:
  location: file:///home/kalphageek/workspace/spring-learning/spring-cloud/keystore/apiEncryptionKey.jks
  alias: apiEncryptionKey
  password: test1234
```

4. Encrypt API 호출 -> ## 대칭키를 이용한 암호화와 동일

5. Decrypt API 호출 -> ## 대칭키를 이용한 암호화와 동일

6. 활용 -> ## 대칭키를 이용한 암호화와 동일