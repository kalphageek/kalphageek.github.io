---
layout: single
title: "Maven Docker Build (IntelliJ)"
categories: springboot
tag: [docker, build, intellij, maven]
#author_profile: false

---



## Maven에서 Docker Image 자동 Build

> Springboot 2.3 이상에서 Plugin 설정하고 Packaging하면, 내부적으로 Buildpack이라는 오픈소스를 사용해서 Docker Image를 만들어준다. 이렇게 하면<br>Docker Image에서 Library를 재활용하는 형태로 Layer를 구성한다.<br>이를 위해서 Dockerfile은 필요없으며, 당연히 Docker가 설치되어 있어야 한다.

* pom.xml

```xml
	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
				<version>2.5.8</version>
				<configuration>
					<layers>
						<enabled>true</enabled>
					</layers>
				</configuration>
				<executions>
					<execution>
						<goals>
							<goal>build-image</goal>
						</goals>
					</execution>
				</executions>
			</plugin>
		</plugins>
	</build>
```

* Image 보기

```bash
# REPOSITORY는 <artifactId>, TAG는 <version>으로 생성된다
$ docker image
REPOSITORY			TAG
discovery-service	0.0.3-SNAPSHOT
```

