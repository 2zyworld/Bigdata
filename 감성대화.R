
library(dplyr)
library(readr)
library(readxl)
library(stringr)

setwd('C:/Users/admin/final_project')
getwd()

data <- read_excel("data/감성대화말뭉치(최종데이터)_Training.xlsx")
nrow(data) # 40879
names(data)
# [1] "번호"        "연령"        "성별"        "상황키워드"  "신체질환"    "감정_대분류"
# [7] "감정_소분류" "사람문장1"   "시스템응답1" "사람문장2"   "시스템응답2" "사람문장3"  
# [13] "시스템응답3" "사람문장4"   "시스템응답4"

data1 <- data %>% 
  group_by(감정_대분류, 감정_소분류) %>% arrange(감정_대분류) %>% View()

senti <- data[6:7]
names(senti) <- c('대분류','소분류')
senti <- senti %>% arrange(대분류)
View(senti)
# 소분류별 개수 count
senti %>% group_by(소분류) %>% count() %>% View()


# 대분류별 소분류 추출
senti[duplicated(senti$소분류),]
senti1 <- senti[!duplicated(senti$소분류),]
View(senti1)
write.csv(senti1, "data/감정별소분류.csv")

# 감정소분류 개별파일 불러오기
# a- 장은영
# b- 서은성님
# c- 이승환님
# d- 김태은님
senti_class_a <- read.csv('data/감정별소분류_a.csv')
View(senti_class_a)
senti_class_b <- read.csv('data/감정별소분류_b.csv')
View(senti_class_b)
senti_class_c <- read.csv('data/감정별소분류_c.csv')
View(senti_class_c)
senti_class_d <- read.csv('data/감정별소분류_d.csv')
View(senti_class_d)

avg_senti <- bind_rows(senti_class_a,senti_class_b,senti_class_c,senti_class_d)
View(avg_senti)
names(avg_senti)
# [1] "X"                  "대분류"             "소분류"             "Anger.분노."        "Anticipation.기대." "Joy.기쁨."         
# [7] "Trust.신뢰."        "Fear.두려움."       "Surprise.놀라움."   "Sadness.슬픔."      "Disgust.혐오."     

# ------------------ 각 컬럼의 감정별로 평균구하기
# 분노
senti_class1 <- aggregate(Anger.분노.~소분류,avg_senti,mean)
senti_class1
# 기대
senti_class2 <- aggregate(Anticipation.기대.~소분류,avg_senti,mean)
senti_class2
# 기쁨
senti_class3 <- aggregate(Joy.기쁨.~소분류,avg_senti,mean)
# 신뢰
senti_class4 <- aggregate(Trust.신뢰.~소분류,avg_senti,mean)
# 두려움
senti_class5 <- aggregate(Fear.두려움.~소분류,avg_senti,mean)
# 놀라움
senti_class6 <- aggregate(Surprise.놀라움.~소분류,avg_senti,mean)
# 슬픔
senti_class7 <- aggregate(Sadness.슬픔.~소분류,avg_senti,mean)
# 혐오
senti_class8 <- aggregate(Disgust.혐오.~소분류,avg_senti,mean)
class(senti_class8)

# 여러 개의 데이터 프레임(data.frame) 한 번에 합치기
# 패키지 설치하기
install.packages("plyr")
library(plyr)

senti_data <- join_all(list(senti_class1, senti_class2, senti_class3,senti_class4,
                            senti_class5, senti_class6, senti_class7,senti_class8), by="소분류", type="left")
View(senti_data)
write.csv(senti_data, "data/감정분류점수.csv")

# 자료 형태확인
glimpse(senti_data)
# 복사본
senti_data1 <- senti_data
# 실수 -> 정수 변환
senti_data1$Anger.분노. <- as.integer(senti_data1$Anger.분노.)
senti_data1$Anticipation.기대. <- as.integer(senti_data1$Anticipation.기대.)
senti_data1$Joy.기쁨. <- as.integer(senti_data1$Joy.기쁨.)
senti_data1$Trust.신뢰. <- as.integer(senti_data1$Trust.신뢰.)
senti_data1$Fear.두려움. <- as.integer(senti_data1$Fear.두려움.)
senti_data1$Surprise.놀라움. <- as.integer(senti_data1$Surprise.놀라움.)
senti_data1$Sadness.슬픔. <- as.integer(senti_data1$Sadness.슬픔.)
senti_data1$Disgust.혐오. <- as.integer(senti_data1$Disgust.혐오.)

View(senti_data1)
write.csv(senti_data, "data/감정분류점수_int.csv")


