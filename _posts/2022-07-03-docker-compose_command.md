---
layout: single
title: "Docker-compose 명령어"
categories: docker-compose
tag: [docker, compose, command]
toc: true
#author_profile : false
---

## Docker-compose 명령어

| Command | 설명                                                         |
| ------- | ------------------------------------------------------------ |
| up      | **Container 생성/시작**<br />$ docker-compose up<br />$ docker-compose up -d #detached 모드로 실행 |
| version | **docker-compose 버전 확인**<br />$ docker-compose version   |
| ps      | **Container 목록 표시**<br />$ docker-compose ps             |
| logs    | **Container 로그 출력**<br />$ docker-compose logs web       |
| run     | **Container 실행**<br />$ docker-compose [서비스이름] [실행명령어] |
| start   | **Container 시작**<br />$ docker-compose start               |
| stop    | **Container 정지**<br />$ docker-compose stop                |
| restart | **Container 재시작**<br />$ docker-compose restart           |
| pause   | **Container 일시 정지**<br />$ docker-compose pause          |
| unpause | **Container 재개**                                           |
| port    | **공개 Port번호 표시**                                       |
| config  | **Yaml의 Syntax 및 환경 변수값 확인**<br />$ docker-compose config |
| kill    | **실행중인 Container 강제 정지**                             |
| rm      | **Container 삭제**                                           |
| down    | **리소스 삭제**<br />$ docker-compose down<br /># 함께 생성된 volumes도 삭제<br />$ docker-compose down --volumes |
| scale   | **Container  서비스 Scaleout 개수 증가**<br />$ docker-compose web=2 |
| -f      | **Yaml이 있는 Directory 변경**<br />$ docker-compose -f /other-dir/docker-compose.yml up |

