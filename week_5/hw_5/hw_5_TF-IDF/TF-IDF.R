library(NLP)
library(tm)
library(stats)
library(proxy)
library(dplyr)
library(readtext)
library(jiebaRD)
library(jiebaR)
library(slam)
library(Matrix)
library(tidytext)



rawData <- readtext("*.txt")
rawData 

docs <- Corpus(VectorSource(rawData$text))
#inspect(docs)

# data clean
toSpace <- content_transformer(function(x, pattern) {
  return(gsub(pattern, " ", x))
})
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, stripWhitespace)


# words cut
common_words <- read.csv("Top 100 common words.csv")
mixseg <- worker()
words <- as.matrix(common_words)
new_user_word(mixseg, words)

jieba_tokenizer <- function(d){
  unlist(segment(d[[1]], mixseg))
}
seg <- lapply(docs, jieba_tokenizer)
freqFrame <- as.data.frame(table(unlist(seg)))

d.corpus <- Corpus(VectorSource(seg))
tdm <- TermDocumentMatrix(d.corpus)
tf <- as.matrix(tdm)
DF <- tidy(tf)


# tf-idf computation
N = tdm$ncol
tf <- apply()











# Note(心得)(2018/10/11):
# (1) speech的資料記得要照順序排列 (週四or週五弄好！)

# (2) setwd可以在右下角的Files那裡調整(10/11學到的)
# (3) 這份作業要分段執行，因為有兩個不同setwd的.csv檔(讀上面的資料要先setwd一次，下面的資料再setwd一次)
# (4) 轉換不同的作業，每次要執行前，記得重新設定該read.csv的setwd！
# (5) Github Desktop要設備註前，不要把勾勾全部勾起來，因為week_4、week_5(每週作業的commit備註都不一樣)
#     而是分part coomit備註，才分別push上去
# (6) 有些資料集太長不想被執行，可以在該行程式碼加上井號變紫色，就不會被執行出來！(R Markdown也是，要另外在{r}後面加東西)
# (7) 有不懂的地方可以試著先讀取老師的範例檔，看看長什麼樣子，自己在做做看！(or 看ntu cool教學影片)
# (8) 有空可以看其他同學的github作品，可以學到一些原本不會的東西 (ex. 亮瑜week_4叫出多個.txt檔，I have a dream那份作品)




# 須解決：
# (1) 英文字如何正確斷詞！(google一下)(google歐美文章，他們都用英文斷詞，有類似的問題！)




