packages <- c("NLP", "tm", "stats", "proxy", "dplyr", "readtext", "slam", "Matrix", "tidytext", "ggplot2")
lapply(packages, library, character.only = TRUE)

rawData <- readtext("*.txt")
rawData 

rawData$doc_id <- gsub("Trump_"," ",rawData$doc_id)
print(rawData$doc_id)
rawData$doc_id <- gsub("-16.txt"," ",rawData$doc_id)
print(rawData$doc_id)



docs <- Corpus(VectorSource(rawData$text))
#inspect(docs)

# data clean
toSpace <- content_transformer(function(x, pattern) {
  return(gsub(pattern, " ", x))
})
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, tolower)   
# docs <- tm_map(docs, PlainTextDocument)
docs <- tm_map(docs, removeWords, stopwords("english"))   
# docs <- tm_map(docs, PlainTextDocument)
docs <- tm_map(docs, stripWhitespace)
# docs <- tm_map(docs, PlainTextDocument)

tdm <- TermDocumentMatrix(docs)   
tdm
print(tf <- as.matrix(tdm))
DF <- tidy(tf) 
DF <- DF[-1, ]

speech_data <- c(rawData$doc_id)
print(speech_data)
colnames(DF) <- c("", speech_data)
print(colnames(DF))



tf <- apply(tdm, 2, sum)
idfCal <- function(word_doc){log2((length(word_doc)+1) / nnzero(word_doc))}
idf <- apply(tdm, 1, idfCal)
doc.tfidf <- as.matrix(tdm)
doc.tfidf[ ,-1]
for(i in 1:nrow(tdm)){
  for(j in 1:ncol(tdm)){
    doc.tfidf[i,j] <- (doc.tfidf[i,j] / tf[j]) * idf[i]
  }
}

findZeroId <- as.matrix(apply(doc.tfidf, 1, sum))
tfidfnn <- doc.tfidf[-which(findZeroId == 0),]

write.csv(tfidfnn, "show.csv")

colnames(doc.tfidf) <- speech_data
print(colnames(doc.tfidf))


library(ggplot2)
termFrequency = rowSums(as.matrix(tdm))
termFrequency = subset(termFrequency, termFrequency>=10)

df = data.frame(term=names(termFrequency), freq=termFrequency)
head(termFrequency,10)
tail(termFrequency,10)


high.freq=tail(sort(termFrequency),n=30)
hfp.df=as.data.frame(sort(high.freq))
hfp.df$names <- rownames(hfp.df) 

# ----------------------------------------------------

apply(doc.tfidf, 1, function(x){
    x2 <- sort(x, TRUE)
    x2[x2 >= x2[3]]
  })

  
TopWords <- data.frame()
for( id in c(1:n) )
{
  dayMax = order(doc.tfidf[,id+1], decreasing = TRUE)
  showResult = t(as.data.frame(doc.tfidf[dayMax[1:5],1]))
  TopWords = rbind(TopWords, showResult)
}
rownames(TopWords) = colnames(doc.tfidf)[2:(n+1)]
TopWords = droplevels(TopWords)
kable(TopWords)
  
  
library(varhandle)
tempGraph$freq = unfactor(tempGraph$freq)
ggplot(tempGraph, aes(speech, freq)) + 
  geom_point(aes(color = words, shape = words), size = 5) +
  geom_line(aes(group = words, linetype = words))

# ----------------------------------------------------

library(ggplot2)
ggplot(hfp.df, aes(reorder(names,high.freq), high.freq)) + 
  geom_bar(stat="identity") + coord_flip() + 
  xlab("Terms") + ylab("Frequency") + 
  ggtitle("Term frequencies")




# ----------------------------------------------------
  
  
  
  




---------------------------------------------------------------------------------


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
# (2) tf、DF的變數名稱如何更改......
# (3) 檔案命名在排序有沒有比較快的做法(ex. 寫程式...)？ex. sep、oct做排序，還是只能改檔名成數字格式(日期)再排序？
#     週四問一下老師！總不可能徒法煉鋼...(64個檔案還好...但檔案多一定要想其他辦法！)
# (4) setwd()的檔案也沒有照順序排......有空再研究！先把矩陣都弄好！
# (5) gsub 如何寫數字迴圈，刪除rawData數字？
# (6) 如何把DF的欄位變數順序更改，使得從七月開始、十一月結束？(只能土法煉鋼？)

# (7) R Markdown圖片弄不出來......禮拜四問一下！
