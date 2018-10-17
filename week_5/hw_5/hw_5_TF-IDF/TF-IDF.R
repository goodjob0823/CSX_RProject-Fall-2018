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


high.freq=tail(sort(termFrequency),n=50)
hfp.df=as.data.frame(sort(high.freq))
hfp.df$names <- rownames(hfp.df) 


library(ggplot2)
ggplot(hfp.df, aes(reorder(names,high.freq), high.freq)) + 
  geom_bar(stat="identity") + coord_flip() + 
  xlab("Terms") + ylab("Frequency") + 
  ggtitle("Term frequencies")




high.freq_1=tail(sort(termFrequency),n=50)
hfp.df_1=as.data.frame(sort(high.freq_1))
hfp.df_1$names <- rownames(hfp.df_1)


library(knitr)
library(ggplot2)
# png('Trump_speeches.png')
ggplot(hfp.df_1, aes(reorder(names,high.freq_1), high.freq_1)) +
  geom_bar(stat="identity") + coord_flip() + 
  xlab("Terms") + ylab("Frequency") + 
  ggtitle("Term frequencies")




apply(doc.tfidf, 1, function(x){
  x2 <- sort(x, TRUE)
  x2[x2 >= x2[3]]
})

