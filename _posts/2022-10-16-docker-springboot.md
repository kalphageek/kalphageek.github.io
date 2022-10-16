---
layout: single
title: "Springboot Docker Image Build"
categories: docker
tag: [docker, maven, springboot]
toc: true
toc_sticky: true
#author_profile : false

---



### Springboot Docker Image Build

> pom.xml의 spring-boot-maven-plugin에 속성을 추가하면 mvn build 시 자동으로 docker image도 생성된다. 

- Springboot에서 Docker를 직접 지원하기 때문에 Dockerfile은 없어도 된다.
- Layer별로 구성하고 변경되지 않은 Layer는 Reuse하기 때문에 재생성되는 Image가 최소화 된다.

```xml
	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
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

