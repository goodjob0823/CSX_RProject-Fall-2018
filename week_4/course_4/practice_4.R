library(NLP)
library(tm)
library(jiebaRD)
library(jiebaR)
library(RColorBrewer)
library(wordcloud)
getwd()
text <- readLines("Eminem songs.txt")
text

docs <- Corpus(VectorSource(text))
inspect(docs)
toSpace <- content_transformer(function(x, pattern) {
  return (gsub(pattern, " ", x))}
)
docs <- tm_map(docs, toSpace, "a")
docs <- tm_map(docs, toSpace, "and")
docs <- tm_map(docs, toSpace, "or")
docs <- tm_map(docs, toSpace, "the")
docs <- tm_map(docs, toSpace, "it")
docs <- tm_map(docs, toSpace, "you")
docs <- tm_map(docs, toSpace, "I")
docs <- tm_map(docs, toSpace, "on")
docs <- tm_map(docs, toSpace, "in")
docs <- tm_map(docs, toSpace, "out")
docs <- tm_map(docs, toSpace, "to")
docs <- tm_map(docs, toSpace, "is")
docs <- tm_map(docs, toSpace, "are")
docs <- tm_map(docs, toSpace, "he")
docs <- tm_map(docs, toSpace, "she")
docs <- tm_map(docs, toSpace, "so")
docs <- tm_map(docs, toSpace, "up")
docs <- tm_map(docs, toSpace, "down")
docs <- tm_map(docs, toSpace, "this")
docs <- tm_map(docs, toSpace, "that")
docs <- tm_map(docs, toSpace, "my")
docs <- tm_map(docs, toSpace, "your")
docs <- tm_map(docs, toSpace, "me")
docs <- tm_map(docs, toSpace, "his")
docs <- tm_map(docs, toSpace, "her")
docs <- tm_map(docs, toSpace, "one")
docs <- tm_map(docs, toSpace, "not")
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, stripWhitespace)

mixseg = worker()
jieba_tokenizer=function(d){
  unlist(segment(d[[1]],mixseg))
}
seg = lapply(docs, jieba_tokenizer)
freqFrame = as.data.frame(table(unlist(seg)))
freqFrame = freqFrame[-c(1:34),]
wordcloud(docs,
          random.order=FALSE, random.color=TRUE, 
          rot.per=0, colors=brewer.pal(8, "Dark2"),
          ordered.colors=FALSE,use.r.layout=FALSE,
          fixed.asp=TRUE)








# 問題：
# 如何不用一個一個歌詞慢慢複製，直接爬娶我想要的歌的歌詞到txt上？查一下！(可以考慮直接從google lyrics關鍵字爬到歌詞，回去多練練)
# 如何判斷每個單字的數量，比如判斷a、the的數量，來決定刪除哪些常見而且不重要的詞
# 有些歌詞被刪除了...可以寄信問助教！(附上txt檔、R檔)(執行inspect(docs)前面的程式碼不會被刪，但後面開始會...)(好像是transformation drops documents的結果)


# 可以繼續做其他饒舌歌手！
# 做完之後還要畫統計圖！
# 程式碼一行一行(or一小段)慢慢讀取，才知道問題在哪裡！一次看到太多bug很亂



# Warning message、Error差別？
# 網友打的程式碼也不一定完全正確，自己要驗證過！
# 有空記得把之前寫過的程式碼都再看過一遍，才會記得！




library(NLP)
library(tm)
library(jiebaRD)
library(jiebaR)
library(RColorBrewer)
library(wordcloud)
library(dplyr)
getwd()
text <- readLines("Eminem songs.txt")
txt <- tolower('txt')
txtList <- lapply(txt, strsplit," ")
txtChar <- unlist(txtList)
txtChar <- gsub("\\.|,|\\!|:|;|\\?","",txtChar)
txtChar <- txtChar[txtChar!=""]
data <- as.data.frame(table(txtChar))
colnames(data) <- c("Word","freq")
ordFreq <- data[order(data$freq,decreasing=T),]

text_1 <- readLines("Top 100 common words.txt")
Word <- select(text_1, 'Word')
antiWord <- data.frame(Word,stringsAsFactors=F)
result <- anti_join(ordFreq,antiWord,by="Word") %>% arrange(desc(freq))


docs <- Corpus(VectorSource(text))
inspect(docs)
toSpace <- content_transformer(function(x, pattern) {
  return (gsub(pattern, " ", x))}
)
docs <- tm_map(docs, toSpace, "a")
docs <- tm_map(docs, toSpace, "and")
docs <- tm_map(docs, toSpace, "or")
docs <- tm_map(docs, toSpace, "the")
docs <- tm_map(docs, toSpace, "it")
docs <- tm_map(docs, toSpace, "you")
docs <- tm_map(docs, toSpace, "I")
docs <- tm_map(docs, toSpace, "on")
docs <- tm_map(docs, toSpace, "in")
docs <- tm_map(docs, toSpace, "out")
docs <- tm_map(docs, toSpace, "to")
docs <- tm_map(docs, toSpace, "is")
docs <- tm_map(docs, toSpace, "are")
docs <- tm_map(docs, toSpace, "he")
docs <- tm_map(docs, toSpace, "she")
docs <- tm_map(docs, toSpace, "so")
docs <- tm_map(docs, toSpace, "up")
docs <- tm_map(docs, toSpace, "down")
docs <- tm_map(docs, toSpace, "this")
docs <- tm_map(docs, toSpace, "that")
docs <- tm_map(docs, toSpace, "my")
docs <- tm_map(docs, toSpace, "your")
docs <- tm_map(docs, toSpace, "me")
docs <- tm_map(docs, toSpace, "his")
docs <- tm_map(docs, toSpace, "her")
docs <- tm_map(docs, toSpace, "one")
docs <- tm_map(docs, toSpace, "not")
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, stripWhitespace)

mixseg = worker()
jieba_tokenizer=function(d){
  unlist(segment(d[[1]],mixseg))
}
seg = lapply(docs, jieba_tokenizer)
freqFrame = as.data.frame(table(unlist(seg)))
freqFrame = freqFrame[-c(1:34),]
wordcloud(docs,
          random.order=FALSE, random.color=TRUE, 
          rot.per=0, colors=brewer.pal(8, "Dark2"),
          ordered.colors=FALSE,use.r.layout=FALSE,
          fixed.asp=TRUE)