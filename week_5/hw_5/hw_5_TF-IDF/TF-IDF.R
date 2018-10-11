library(bitops)
library(httr)
library(RCurl)
library(XML)
library(tm)


Trump_speeches <- list.files(path = "/Users/John/Documents/GitHub/CSX_RProject_Fall_2018/week_5/hw_5/hw_5_TF-IDF/election_2016/speeches/trump")

for(i in Trump_speeches) { x <- read.table(i, header=TRUE, comment.char = "A", sep="\t"); 
                  assign(print(i, quote=FALSE), x); write.table(x, paste(i, c(".out"), sep=""), 
                  quote=FALSE, sep="\t", col.names = NA) }

Trump_speeches


------------------------------------------------------------------------------------


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
# inspect(docs)

toSpace <- content_transformer(function(x, pattern) {
  return(gsub(pattern, " ", x))
})
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, toSpace, "")









