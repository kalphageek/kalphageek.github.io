---
layout: single
title: "Nifi Example #1"
categories: nifi
tag: [nifi, example]
toc: true
toc_sticky: true
#author_profile : false
---



![](https://raw.githubusercontent.com/kalphageek/image_repo/main/img/nifi-sample_1.png?token=AHE3DGA3GORFWRNN7X5LCK3C3VI7K)



### 데모 흐름

오늘의 데모 사례는 IoT 애플리케이션입니다. 스마트 빌딩에는 사무실의 에어컨과 창문에 센서가 있습니다. AC가 켜져 있고 창이 열려 있으면 많은 에너지를 낭비하므로 이러한 상황을 기록하거나 경보를 생성하거나 AC를 자동으로 종료하려고 합니다. 이 경우 JSON 형식의 Apache Kafka Topic 2에서 센서 데이터를 수신합니다. 데이터를 CSV 형식의 HDFS와 Apache Cassandra에 저장할 것입니다.ㅗ

### Step 1

첫 번째 단계는 Kafka에서 데이터를 수신하는 것입니다. NiFi에는 Kafka Consumer 프로세서가 있으므로 정말 쉽습니다.
프로세서에서 bold properties를 설정해야 하므로 일부 Kafka 브로커의 주소를 설정하고 보안이 설정된 경우 보안도 설정해야 하며 읽고 싶은 Topic도 지정해야 합니다. 우리의 경우 `mport.1`가 AC에 대한 Topic이고, `mport.2` 창문 sensor에 대한 것이므로 둘 다 추가했습니다.

### Step 2

창문과 AC 센서의 형식이 다르기 때문에 데이터의 출처 Topic을 기반으로 라우팅을 설정했습니다. 이렇게 하면 두 센서의 데이터를 다르게 처리할 수 있습니다. 라우팅을 위해 RouteOnAttribute 프로세서를 사용했습니다.
다행히 Kafka Consumer는 kafka.topic 속성을 설정하여 지금 사용할 수 있습니다. 작동하도록 하기 위해 Route to Property name strategy를 선택했습니다. 이 방법으로 이 프로세서에 대한 new output relationships을 만들 수 있습니다. 2개의 AC와 창을 만들었습니다. 프로세서에게 어떤 FlowFile이 어떤 방향으로 가야 하는지 알려주기 위해 NiFi expression language를 사용할 수 있습니다. 문서 검색에 대한 자세한 내용을 보려면 지금은 `kafka.topic`속성이 `mport.1`또는 `mport.2`와 같은지 확인하는 표현식을 만들었습니다 .

### Step 3

자, 흐름을 분리했습니다. 시스템의 AC 부분에 대한 FlowFiles의 흐름을 보여드리겠습니다. 창문 쪽은 완전히 동일한 레이아웃이지만 약간 다른 데이터 구성표가 있습니다.
따라서 **PutCassandra** 프로세서를 사용하여 Cassandra에 저장할 수 있으려면 JSON을 CSV로 변환하여 HDFS에 저장하고, CQL INSERT 문으로 변환해야 합니다. 이러한 종류의 텍스트 조작은 **ReplaceText** 프로세서를 사용하여 가장 쉽게 수행할 수 있지만 이를 사용하려면 모든 JSON 속성을 속성으로 추출해야 합니다. 이를 위해 **EvaulateJSONPath** 프로세서를 사용했습니다.
Destination 속성을 flowfile-attribute로 설정하여 NiFi에 새 속성을 생성하도록 지시합니다. 여기에서 JSONPath 표현식을 사용하여 JSON 콘텐츠에서 값을 추출할 수 있습니다. 이 프로세서가 FlowFile로 완료되면 `rms_sum1, rms_sum2, rms1, rms2, timestamp` 라는 5개의 새 속성이 생기고 JSON ``콘텐츠 ``의 ``값 ``이 포함됩니다.

### Step 4 / a

속성이 설정되면 흐름이 분할되지만 동일한 데이터는 양방향으로 이동합니다. 이를 달성하기 위해 성공 관계를 여러 목표에 쉽게 연결할 수 있습니다. 먼저 HDFS 아카이브에서 JSON을 CSV로 변환하려고 합니다. 이를 위해 **ReplaceText** 프로세서를 사용했습니다.
기본적으로 `(?s)(^.*$)`정규 표현식으로 전체 데이터 콘텐츠를 선택하고 쉼표로 구분하여 이전에 설정한 속성 콤마로 구분된 `${'rms1'},${'rms_sum1'},${'rms2'},${'rms_sum2'}` 의 데이터 값으로 대체했습니다 .  expression language `${}`를 사용하는 속성 값에 도달할 수 있다는 것을 이해했다고 확신합니다.

### Step 5 / a

HDFS는 큰 파일을 저장하기 위한 것입니다. 이 small lines은 너무 작아서 효율적으로 저장할 수 없으므로 **MergeContent** 프로세서를 사용하여 여러 FlowFile을 `n`구분 기호로 연결했습니다.
많은 옵션이 있지만 우리의 옵션은 정말 간단합니다. **MergeContent** 프로세서는 최소 파일 양이나 최소 그룹 크기에 도달할 때까지 출력을 생성하지 않습니다. 스트리밍과 같은 처리 흐름에서는 이것이 문제가 될 수 있지만 지금은 보관 및 분석을 위해 HDFS에 쓰고 있기 때문에 문제가 되지 않습니다.

### Step 6 / a

NiFi에는 HDFS 프로세서가 탑재되어 있어 이 파일 시스템에 데이터를 저장하는 것이 정말 쉽습니다. NiFi가 클러스터에 연결하는 방법을 알 수 있도록 hdfs-site 및 core-site xml 파일을 설정해야 합니다. 파일을 저장할 경로만 있으면 됩니다. 이 속성은 expression language도 지원하므로 일부 논리를 사용하여 파일을 저장할 위치를 결정할 수 있습니다.
이 단계를 통해 HDFS 스토리지 부분이 완료되었으므로 Cassandra를 계속 사용하겠습니다.

### Step 4 / b

이전에 본 것과 동일한 원칙을 여기에서 사용합니다. NiFi의 **PutCassandra** 프로세서가 작동하려면 데이터 콘텐츠로 CQL INSERT 문이 필요하므로 JSON이 좋지 않습니다. 우리는 그것들을 CQL 문으로 변환해야 합니다. CSV 변환에 사용한 것과 똑같은 방법을 사용할 수 있습니다.
**ReplaceText** 프로세서를 사용하여 CQL 문을 구성합니다. 이 경우 정확한 대체 값은 다음과 같습니다.

### Step 5 / b

마지막 단계는 매우 쉽습니다. 나는 이전에 이것이 작동하는 데 필요한 Cassandra 테이블을 생성했습니다. **PutCassandra** 프로세서가 Cassandra 클러스터를 찾을 수 있는 위치를 설정하고 키 공간을 설정하면 완료됩니다.
이것은 AC 측의 흐름이었습니다. 창문 부분의 경우 이 부분을 복사하고 **EvaluateJSONPath** 및 **ReplaceText**에서 변경된 데이터 체계와 함께 재사용할 수 있습니다.

AC 및 창문 분기가 있는 흐름의 최종 형태는 다음과 같습니다.