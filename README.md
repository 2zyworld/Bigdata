
# 'BLU' 감정 분석을 통한 스마트 일기 서비스

<br>

### 프로젝트 기간
2022.05.02 ~ 2022.6.13 (주말제외 29일)

> 팀 구성
- AI팀 : 이승환
- IOT팀 : 김규배, 성수진
- 클라우드 : 김도원, 이병헌
- 빅데이터 : 김태은, 서은성, 장은영

⭐[Github Team organization](https://github.com/2zyworld)
  
[🔗발표자료](https://github.com/somijjjjj/2zyworld_Bigdata/blob/main/%EC%9C%B5%EB%B3%B5%ED%95%A9%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8%202%EC%A1%B0%20%EB%B0%9C%ED%91%9C%EC%9E%90%EB%A3%8C.pdf)

<br>

### 계획

1. 음성인식 일기 작성
2. 작성된 일기 보기
3. 작성된 일기를 통해 AI감정분석 
4. 사용자 감정 색상 반환 
5. 사용자 감정에 따른 노래 추천 🐾
6. 사용자 감정에 맞춘 조명 색 추천
7. 사용자 위치 기반 병원리스트 (+ 우울도테스트)
8. 명상, 힐링 음악 듣기 🐾
9. 사용자 감정 통계그래프 🐾

<br>

## 구현

### 전체 구성도

![](https://velog.velcdn.com/images/silver0/post/ac444ccd-0834-4145-a0a5-3e4c3d14b400/image.png)

1. 접근성과 편리성을 갖추기 위해 모바일 서비스를 제공하기로 했다. 
2. 사용자의 일기는 REST API 통해 AWS서버에 내의 AI감정분석 모델, 색상 합성 알고리즘을 거쳐 아마존RDS 데이터베이스에 저장이 된다.
3. 음악추천 알고리즘, 감정통계 그래프 알고리즘, 명상 음악리스트도 AWS서버 내의 저장이 되어있고, REST API를 통해 모바일과 통신을 할 수 있도록 설계를 했다.
4. 사용자가 원하면 앱에서 MQTT 통신으로 raspberry를 통해 조명을 제어할 수 있다.

<br> 

### 시스템 구성도
![](https://velog.velcdn.com/images/silver0/post/08e79f51-02e6-4370-bdb5-b25c57db20ed/image.png)

1. 모놀리식 컨테이너 구조로 시스템 구성을 설계했다.
2. 앱에서 API요청을 AWS서버에 보내게 되면 EKS 안에 있는 REST API 서버에서 앱에 필요한 정보를 반환한다.
3. DB서버를 서로 다른 가용영역에 생성하여 이중화 환경을 구성하여 primary DB 서버에 장애가 발생하게 되면 secondary DB가 primary를 승계할 수 있도록 설계했다.

<br> 

### Kubernetes 구성도
![](https://velog.velcdn.com/images/silver0/post/fbe4a7e1-e10e-44b4-83d3-81760de6a8bc/image.png)

1. 인그레스로 A.L.B역할을 하여 뒤의 서버를 연결했다.
2. 서버 부하 안정성에 대해 고려하여 Deploy를 H.P.A 설정했다.
3. 데이터베이스는 DB-service를 통해 RDS와 연결되었다.

<br> 

#### - Cloudwatch 모니터링 화면
![](https://velog.velcdn.com/images/silver0/post/273a8b49-4281-4fa7-b745-250ea597e17f/image.png)

> cloudwatch : 서버의 사용량을 모니터링 할 수 있는 aws기능

<br> 

#### - kubernetes 오토스케일링 기능 확인
![](https://velog.velcdn.com/images/silver0/post/ca686673-e25a-46c9-9213-258c1e73e780/image.gif)

>  hpa, node autoscaler : 서버에 사람이 많이 몰릴 때 자동으로 서버가 증설되는 서비스
1. 서버 부하가 늘어나더라도 안정적으로 서비스를 제공할 수 있게  HPA기능 과 aws의 node auto scale기능을 이용하였다.
2. Jmeter 프로그램으로 서버에 부하를 주어 실제로 두 기능이 활용되는 것을 확인했다.

<br> 

### 플랫폼 및 API

- 안드로이드 스튜디오, Kotlin을 통한 앱 제작
- Django REST Framework API 구축
- RESTful API를 통한 CRUD 구현
- 카카오 STT API
- Google Maps API
- kakaomap API
- MQTT를 통한 IoT 기기와 애플리케이션 연동

<br> 

### 한국어 텍스트 감성 분석 모델
- SK T-Brain KoBERT 사용 [🔗GitHub](https://github.com/SKTBrain/KoBERT)
Google BERT 기반 범용 NLP 모델
한국어 분석 성능 개량
한국어 Wikipedia 기반 tokenizer

- 감성 대화 말뭉치 데이터 사용 [🔗AI Hub](https://aihub.or.kr/aihubdata/data/view.do?currMenu=116&topMenu=100&aihubDataSe=ty&dataSetSn=86)
구성 한국어 코퍼스 27만 문장, 6개 대분류, 60개 소분류
내용
발화자(인간)와 응답자(시스템)의 대화로 구성
1개 상황당 4개~8개 대화와 1개 감정으로 구성
총 45959개 상황

최초 데이터 레이블링에 중복된 레이블이 있었고, 실제로 학습 과정에서도 모델의 혼동이 관찰되었기 때문에 해당되는 데이터는 하나의 클래스로 통합하는 등의 가공을 해주었다.

<br> 

### 색상-감정 알고리즘

![](https://velog.velcdn.com/images/silver0/post/b00a90d1-a436-4a8c-b6fd-26f84e597566/image.png)

 로버트 플루칙의 감정심리진화론에 따르면 인간의 모든 감정은 8가지 기본 감정의 혼합이라고 한다.
 이에 착안하여 분석 결과를 8가지 기본 감정 수치로 표현되게 했고, 이를 혼합하여 최종적으로 한 가지 색상으로 표현했다.


> 색상 표현의 이유
1. 감정 분석 결과를 직접적으로 표시할 경우 타인이 자신의 감정을 단정적으로 판단한다는 인상을 줄 수 있다.
2. 문자, 숫자와는 달리 시작적 자극을 통해 엔터테인먼트 요소를 강화하고 지속적인 어플 사용을 유도 할 수 있다.
3. 자연어와 심리라는 주제 특성상 '정확도'가 큰 의미를 갖지 못하기 때문에, 사용자가 직관적으로 받아들이거나 주관적 해석의 여지가 큰 부차적 표현 방법으로써 색상을 채택했다.

- [색상 합성 기능 구현](https://github.com/2zyworld/iot-django/blob/44b475e04e82fef1154e53f117448f3b00a79da6/diary/AI/kobert_main/inference.py#L60)

<br>

### 모델 프로세스
![](https://velog.velcdn.com/images/silver0/post/78da8a79-1a4d-40f2-aa2e-61303bf539f4/image.png)

1. 사용자가 입력한 한국어 텍스트 토큰화
2. 토큰화된 데이터는 Embedding 1개 레이어, Encoder 12개 레이어, Pooler와 Classifier 레이어 1개씩을 거쳐 최종적으로 8가지 기본 감정 수치를 계산
3. 이 수치는 추후 통계 분석에 활용되도록 저장되며, 동시에 색상 합성 알고리즘이 이 수치를 받아 색상 코드를 반환

<br>

### 음악 추천 알고리즘

> - 데이터수집 (3,989 x 10)
유튜브 플레이리스트 영상
멜론 태그별 수록곡

KoBERT모델에서 추출된 노래영상별 감정을 이용하여
사용자의 감정과 가장 유사한 노래영상을 추천해준다.

![](https://velog.velcdn.com/images/silver0/post/dfebdda8-2b30-4fac-a65d-c0ab9dda6eae/image.png)


> 감정에 따른 노래추천에 대한 참고 논문
###### Sittler, M.C., Cooper, A. J., & Montag, C. ,2019, Is empathy involved in our emotional response to music? The role of the PRL gene, empathy, and arousal in response to happy and sad music. Psychomusicology: Music, Mind, and Brain, 29(1), 10–21.
사람은 감정 조절의 필요를 느낄 때 음악을 활용하며,
슬픈 음악이 프로락틴과 옥시토신 분비를 돕기 때문에 슬픈 감정을 가진 사용자에게 슬픈 음악을 추천해주는 것은 사용자를 위로해주고 슬픈 감정에서 벗어나게 한다

<br>

### 통계그래프 및 명상 음악 

- Django ORM을 이용하여 DB에 있는 사용자 감정값을 월별로 추출하여 앱으로 전송하는 REST API 구현

- 유튜브 API를 이용하여 명상, 힐링 채널들의 영상들을 수집하고, 수집데이터는 장고 서버에 저장했다.
해당 데이터를 앱으로 전송하기 위해 REST API 구현


<br>


# 📽시연
### [🔗영상Link](https://www.youtube.com/watch?v=W1UPLfW53Gg) 

![](https://velog.velcdn.com/images/silver0/post/916d4f1d-ce9c-4f49-8f3a-6b64638e5c4a/image.png)

<젊은 ADHD의 슬픔> 저자인 정지음 작가는
어려서 AHD 진단을 받은 이후 정신질환에 시달렸는데
자신을 이렇게 정의했다고 한다.

<br>

![](https://velog.velcdn.com/images/silver0/post/5f397a6c-bca5-479d-8fb6-2506bfb99bcd/image.png)

그러나 일기와 글쓰기를 통해 자기자신을 관찰하고   
자기자신과 화해하고 수용하는 과정을 거치며
자기자신의 정의에 대한 생각은 질문으로 바뀌게 된다.

그리고 질문에 대해 이렇게 대답했다. 

<br>

![](https://velog.velcdn.com/images/silver0/post/fe5dafb4-11d7-4832-a813-4ea87ae18b0a/image.png)

<br>

> *발표 대본 中..*
*일기를 쓰는 것은 자신과 대화하는 하나의 형태라고 생각합니다.
누군가를 소중히 여긴다는 것은 많은 시간의 대화와 면밀히 살피는 것을 통해 상대의 고유함을 발견하는 마음일 것입니다.  
이 서비스를 통해 스스로를 소중히 여기고 다정하게 바라볼 수 있는 시간을 가졌으면 좋겟습니다.*

<br>

# 💭Project Review

IT 업계 각 분야에 대해 이해할 수 있는 기회가 되었고, 그를 바탕으로 하나의 서비스를 구성하고 제공하는 과정에 대한 전체적인 흐름을 경험할 수 있었다. 여러 실무 지식 뿐만 아니라 단순 학습만으로는 배울 수 없는 소통과 체계 관리의 중요성 또한 체감할 수 있는 값진 시간이었다.
스마트폰 이외에도 텔레비전, 컴퓨터 등 여러 플랫폼을 이용하고, 사용자가 검색하거나 작성한 댓글, SNS 포스팅 등을 실시간으로 분석하여 감정을 관리하고 멘탈 헬스케어에 도움을 주는 기술로 발전시키고 싶다. 또한 향후 댓글, 비트, 태그 등 텍스트 데이터 뿐만 아니라 표정, 음성 등을 포함한 복합적이고 통합된 데이터에 대한 분석이 가능하도록 확장하여 사용자가 원하는 추천 시스템을 제공할 수 있도록 고도화, 정교화하는 것을 목표로 하고 싶다.

<br>

### Reference

한국룬드백 보도자료, 2021.10.14. https://www.lundbeck.com/kr/press/news-updates

백세희, <죽고 싶지만 떡볶이는 먹고 싶어>  

정지음, <젊은 ADHD의 슬픔>

Plutchik, R, 2001, The nature of emotions: Human emotions have deep evolutionary roots, a fact that may explain their complexity and provide tools for clinical practice. American scientist, 89(4), 344-350.


Muller-Mees, Elke, 2000, 컬러파워  

이윤경,2010,표현주의 미술의 색채심리와 심리 치료적 요인에 관한 연구  

김지수, 2015,음악치료 전공생의 감정 조절을 위한 음악활용에 관한 연구  

Sittler, M.C., Cooper, A. J., & Montag, C., 2019, Is empathy involved in our emotional response to music? The role of the PRL gene, empathy, and arousal in response to happy and sad music. Psychomusicology: Music, Mind, and Brain, 29(1), 10–21.





