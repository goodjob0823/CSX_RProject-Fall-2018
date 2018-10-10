library(NLP)
library(tm)
library(jiebaRD)
library(jiebaR)
library(RColorBrewer)
library(wordcloud)

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


