---
layout: single
title: "Dockerfile 명령어"
categories: docker
tag: [dockerfile]
toc: true
toc_sticky: true
#author_profile : false
---

## Dockerfile 명령어

> 참조 : https://velog.io/@tjdwns2243/dockerfile-%EB%AC%B8%EB%B2%95-%EC%9E%91%EC%84%B1%EB%B2%95

* FROM : Base Image

* LABEL : Imgae Label 설정

* WORKDIR : 작업시작 Directory 설정

* VOLUME : 외부 Volume Mount

* COPY : Host로 부터 Image로 파일을 복사한다.

* ADD  : Host로 부터 Image로 파일을 복사한다.

* ENV : 환경변수 설정

* RUN : Image내 에서 실행되는 추가 명령어

* EXPOSE :노출 포트 설정

* ENTRYPOINT : 실행 명령어, 1번만 가능

* CMD : 실행 명령어, 여러번 가능, ENTRYPOINT가 앞에 있으면, 그것의 파라미터로만 동작한다
