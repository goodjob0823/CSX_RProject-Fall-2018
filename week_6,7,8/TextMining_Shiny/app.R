library(NLP)
library(tm)
library(stats)
library(proxy)
library(dplyr)
library(readtext)
library(slam)
library(Matrix)
library(tidytext)
library(jiebaRD)
library(jiebaR)
library(knitr)
library(ggplot2)
library(magrittr)
library(xtable)
library(factoextra)
library(cluster)
library(shiny)
library(shinythemes)
library(robustbase)
library(rsconnect)


# 使用readtext一次下載多個txt檔

setwd("~/Documents/GitHub/CSX_RProject_Fall_2018/week_6,7,8/trump")
rawData <- readtext("*.txt")
rawData 


# 為了讓原始資料第一行(rawData$doc_id)元素更簡潔，用gsub把檔名中多餘的文字刪掉

rawData$doc_id <- gsub("Trump_"," ",rawData$doc_id)
print(rawData$doc_id)
rawData$doc_id <- gsub("-16.txt"," ",rawData$doc_id)
print(rawData$doc_id)


# 建立文本資料結構與基本文字清洗，刪去標點符號、數字以及一些英文常見字詞

docs <- Corpus(VectorSource(rawData$text))
toSpace <- content_transformer(function(x, pattern) {
  return(gsub(pattern, " ", x))
})
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, tolower)
docs <- tm_map(docs, removeWords, stopwords("english")) 
docs <- tm_map(docs, stripWhitespace)



mixseg = worker()
jieba_tokenizer = function(d)
{
  unlist( segment(d[[1]], mixseg) )
}

count_token = function(d)
{
  as.data.frame(table(d))
}

idfCal <- function(word_doc, n)
{ 
  log2( n / nnzero(word_doc) ) 
}
###
seg_date = lapply(docs, jieba_tokenizer)
tokens_date = lapply(seg_date, count_token)
###
n_date = length(seg_date)
TDM_date = tokens_date[[1]]
dateNames <- rawData[,"doc_id"]
for(doc_id in c(2:n_date))
{
  TDM_date = merge(TDM_date, tokens_date[[doc_id]], by="d", all = TRUE)
  names(TDM_date) = c('d', dateNames[1:doc_id])
}
TDM_date[is.na(TDM_date)] <- 0 #將NA填0
doc.tfidf_date <- TDM_date

#####
input.date <- "AshevilleNC_Sep-12"
words_count_date = TDM_date[,1:2]
colnames(words_count_date) = c('word', 'count')
words_count_date = words_count_date[rev(order(words_count_date$count)),]
# words_count_date$count = sort(words_count_date$count, decreasing = T)
rownames(words_count_date)=NULL

ggplot(words_count_date[1:20,], aes(x = reorder(word, count), y =count)) + 
  geom_bar(stat = "identity", fill='lightblue') + 
  coord_flip() +
  labs(x='word', y='count', title=paste('Author: ', input.date)) +
  theme(panel.background = element_blank(),
        axis.title = element_text(color = '#2d2d2d'),
        axis.text.x = element_text(hjust = 1, size=15),
        axis.text.y = element_text(hjust = 1, size=15),
        strip.text.x = element_text(color='#2d2d2d',face='bold',size=10),
        plot.title = element_text(hjust=0.5,face='bold',size=15))
###
rownames(doc.tfidf_date) = doc.tfidf_date$d
doc.tfidf_date <- doc.tfidf_date[,1:n_date+1]


# 建立文本矩陣 TermDocumentMatrix
tdm <- TermDocumentMatrix(docs)   
tdm


print(tf <- as.matrix(tdm))
DF <- tidy(tf) 
DF <- DF[-1, ]


# 將原始資料第一行(rawData$doc_id)的64個演講名稱，設定為向量。
# 之後，再將新的資料(所有字詞在各場演講出現的次數)的變數名稱，轉成自己命名的變數名稱。
speech_data <- c(rawData$doc_id)
print(speech_data)
colnames(DF) <- c("", speech_data)
print(colnames(DF))


# 將已建好的 TDM 轉成 TF-IDF
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


# 計算新資料的前十列、後十列文字，在所有演講出現的次數

termFrequency = rowSums(as.matrix(tdm))
termFrequency = subset(termFrequency, termFrequency>=10)

df = data.frame(term=names(termFrequency), freq=termFrequency)
head(termFrequency,10)
tail(termFrequency,10)


# 找出所有演講中，出現次數最高的30個字詞
high.freq=tail(sort(termFrequency),n=30)
hfp.df=as.data.frame(sort(high.freq))
hfp.df$names <- rownames(hfp.df)


# 畫柱狀圖，顯示出現次數最高的30個字，各別出現的次數
library(knitr)
library(ggplot2)
# png('Trump_speeches.png')

ggplot(hfp.df, aes(reorder(names,high.freq), high.freq)) +
  geom_bar(stat="identity") + coord_flip() + 
  xlab("Terms") + ylab("Frequency") + 
  ggtitle("Term frequencies")


# 接著找出次數最高的50個字詞
high.freq_1=tail(sort(termFrequency),n=50)
hfp.df_1=as.data.frame(sort(high.freq_1))
hfp.df_1$names <- rownames(hfp.df_1)



ggplot(hfp.df_1, aes(reorder(names,high.freq_1), high.freq_1)) +
  geom_bar(stat="identity") + coord_flip() + 
  xlab("Terms") + ylab("Frequency") + 
  ggtitle("Term frequencies")


DF_1 <- t(DF)
DF_1

DF_1.df <- as.data.frame(DF_1)
DF_1.df

colnames(DF_1.df) <- c(DF_1.df[1, ])
DF_1.df <- DF_1.df[-1, ]



# scale(DF)
pcs <- prcomp(DF[ ,-1], center = T, scale = T)
pcs
plot(pcs)



library(magrittr)
pcs$x

pcs$x %>%
  as.data.frame() %>%
  ggplot(aes(PC1, PC2)) + geom_point()




apply(DF[ ,2:65], 1, sum)
total_amount <- as.vector(apply(DF[ ,2:65], 1, sum))
DF.df <- cbind(DF, total_amount)
DF.df.sort <- DF.df[order(DF.df$total_amount, decreasing = T), ]




data <- DF[ ,-1]

row.names(DF.df.sort) <- c(DF.df.sort[,1])
DF.df.sort_latest <- as.data.frame(DF.df.sort[c("hillary","clinton","clintons","obama","hillarys","obamaclinton","illegal","crime","criminal","corruption","violence","killed","violent","crime","weapons","isis","military","terrorism","terrorists","crisis","nuclear","borders","africanamerican","africanamericans","african","children","school","schools","education","childcare","women","woman","workers","refugees","immigrant","refugee","veterans","lobbyist","religious","justice","justices","mexico","china","islamic","iraq","syria","russia","americas","libya","korea","haiti","pennsylvania","ohio","florida","carolina","hampshire","detroit","chicago","baltimore","arizona","orlando","hispanic","poverty","lowincome","jobs","money","prosperity","wealthy","jobkilling","nafta","tpp","transpacific","economic","economy","deficit","debt","currency","infrastructure","trade","obamacare","reform","reforms","jobkilling"),])
row.names(DF.df.sort_latest) <- c(1:83)    

type <- c(rep("name",times = 6),rep("military/safety",times = 16),rep("ethnics/human rights",times = 19),           rep("country/state/city",times = 21),rep("policy/economy",times = 21))
type <- as.data.frame(type)
DF.df.sort_latest <- cbind(DF.df.sort_latest, type)
data_latest <- DF.df.sort_latest[ ,c(-1,-66,-67)]


E.dist <- dist(data_latest, method = "euclidean")
# par(mfrow=c(1,2))

hc.s <- hclust(E.dist, method = "single")
hc.c <- hclust(E.dist, method = "complete")
hc.a <- hclust(E.dist, method = "average")
hc.w <- hclust(E.dist, method = "ward.D") 

par(mar = c(0, 4, 4, 2), mfrow = c(2, 2))
plot(hc.s, labels = FALSE, main = "single", xlab = " ")
plot(hc.c, labels = FALSE, main = "complete", xlab = " ")
plot(hc.a, labels = FALSE, main = "average", xlab = " ")
plot(hc.w, labels = FALSE, main = "ward.D", xlab = " ")
# abline(h=9, col="red")


# op <- par(mar = c(1, 4, 4, 1))
par(mar = c(1, 4, 4, 1), mfrow = c(1, 1))
plot(hc.w, labels = DF.df.sort_latest$type, cex = 0.6, main = "ward.D showing 3 clusters")
rect.hclust(hc.w, k = 5)



library(xtable)
library(factoextra)

set.seed(20)
data_latest.km <- kmeans(data_latest, centers = 5, nstart = 50)

# We can look at the within sum of squares of each cluster
data_latest.km$withinss

data_latest.km_Table <- data.frame(group = DF.df.sort_latest$type, cluster = data_latest.km$cluster)
data_latest_Table <- xtable(with(data_latest.km_Table, table(group, cluster)), 
                            caption = "Number of samples from each experimental group within each k-means cluster")


fviz_cluster(data_latest.km,           # 分群結果
             data = data_latest,       # 資料
             geom = c("point","text"), # 點和標籤(point & label)
             frame.type = "norm")      # 框架型態


library(cluster)

data_latest.kmedoid <- pam(data_latest, k = 5)     # pam = Partitioning Around Medoids
data_latest.kmedoid$objective                      # 群內的變異數

data_latest.kmedoid_Table <- data.frame(group = DF.df.sort_latest$type, 
                                        cluster = data_latest.kmedoid$clustering)
data_latest_Table_1 <- xtable(with(data_latest.kmedoid_Table, table(group, cluster)), 
                              caption = "Number of samples from each experimental group within each PAM cluster")


par(mar = c(5, 1, 4, 4))
plot(data_latest.kmedoid, main = "Silhouette Plot for 5 clusters")

fviz_cluster(data_latest.kmedoid,   
             data = data_latest,    
             geom = c("point"),     
             frame.type = "norm")   


fviz_nbclust(data_latest, 
             FUNcluster = hcut,  
             method = "wss",     
             k.max = 12          
) + 
  
  labs(title = "Elbow Method for HC") +
  
  geom_vline(xintercept = 5,       
             linetype = 2)         


fviz_nbclust(data_latest, 
             FUNcluster = kmeans,# K-Means
             method = "wss",     # total within sum of square
             k.max = 12          # max number of clusters to consider
) + 
  
  labs(title = "Elbow Method for K-Means") +
  
  geom_vline(xintercept = 5,       # 在 X=5的地方 
             linetype = 2)         # 畫一條虛線


fviz_nbclust(data_latest, 
             FUNcluster = pam,   # K-Medoid
             method = "wss",     # total within sum of square
             k.max = 12          # max number of clusters to consider
) + 
  
  labs(title = "Elbow Method for K-Medoid") +
  
  geom_vline(xintercept = 5,       # 在 X=5的地方 
             linetype = 2)         # 畫一條虛線


fviz_nbclust(data_latest, 
             FUNcluster = kmeans,   # K-Means
             method = "silhouette", # Avg. Silhouette
             k.max = 12             # max number of clusters
) +
  
  labs(title = "Avg.Silhouette Method for K-Means") 


##UI =======================================================================
ui <- navbarPage(
  
  theme = shinythemes::shinytheme("flatly"),
  
  # Application title
  "川普選前演講分析",
  
  tabPanel(
    "簡介",
    tags$h2("簡介"),br(),
    tags$h3("姓名： 張靖雍"),br(),br(),
    tags$h4("本次作業想探討川普在總統大選前一系列的演講，"),br(),
    tags$h4("是否出現偏激的用字，"),br(),
    tags$h4("以及在這些演講中提到了哪些政策"),br()
  ),
  tabPanel(
    "演講常用字",
    tags$h2("演講常用字"),br(),
    mainPanel(
      plotOutput("Plot_1")
    )
  ),
  tabPanel(
    "階層式分群",
    tags$h2("階層式分群"),br(),
    mainPanel(
      plotOutput("Plot_2")
    )
  ),
  tabPanel(
    "類別間的關聯性",
    tags$h1("類別間的關聯性：K-means"),
    sidebarPanel(
      tags$h4("使用K-means，將不同類別的字進行分群"),
      numericInput("k1",
                   "Number of k:",
                   min = 1,
                   max = nrow(data_latest) - 1,
                   value = 5)
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("Plotly_KM1")
    )
  ),
  tabPanel(
    "類別間的關聯性",
    tags$h1("類別間的關聯性：K-medoid"),
    sidebarPanel(
      tags$h4("使用K-medoid，將不同類別的字進行分群"),
      numericInput("k2",
                   "Number of k:",
                   min = 1,
                   max = nrow(data_latest) - 1,
                   value = 5)
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("Plotly_KM2")
    )
  )
)

##SERVER =====================================================================
server <- function(input, output) {
  output$Plot_1 <- renderPlot({
    termFrequency = rowSums(as.matrix(tdm))
    termFrequency = subset(termFrequency, termFrequency>=10)
    
    df = data.frame(term=names(termFrequency), freq=termFrequency)
    head(termFrequency,10)
    tail(termFrequency,10)
    
    high.freq=tail(sort(termFrequency),n=30)
    hfp.df=as.data.frame(sort(high.freq))
    hfp.df$names <- rownames(hfp.df)
    
    ggplot(hfp.df, aes(reorder(names,high.freq), high.freq)) +
      geom_bar(stat="identity") + coord_flip() + 
      xlab("Terms") + ylab("Frequency") + 
      ggtitle("Term frequencies")
  })
  output$Plot_2 <- renderPlot({
    row.names(DF.df.sort) <- c(DF.df.sort[,1])
    DF.df.sort_latest <- as.data.frame(DF.df.sort[c("hillary","clinton","clintons","obama","hillarys","obamaclinton","illegal","crime","criminal","corruption","violence","killed","violent","crime","weapons","isis","military","terrorism","terrorists","crisis","nuclear","borders","africanamerican","africanamericans","african","children","school","schools","education","childcare","women","woman","workers","refugees","immigrant","refugee","veterans","lobbyist","religious","justice","justices","mexico","china","islamic","iraq","syria","russia","americas","libya","korea","haiti","pennsylvania","ohio","florida","carolina","hampshire","detroit","chicago","baltimore","arizona","orlando","hispanic","poverty","lowincome","jobs","money","prosperity","wealthy","jobkilling","nafta","tpp","transpacific","economic","economy","deficit","debt","currency","infrastructure","trade","obamacare","reform","reforms","jobkilling"),])
    row.names(DF.df.sort_latest) <- c(1:83)    
    
    type <- c(rep("name",times = 6),rep("military/safety",times = 16),rep("ethnics/human rights",times = 19),           rep("country/state/city",times = 21),rep("policy/economy",times = 21))
    type <- as.data.frame(type)
    DF.df.sort_latest <- cbind(DF.df.sort_latest, type)
    data_latest <- DF.df.sort_latest[ ,c(-1,-66,-67)]
    
    E.dist <- dist(data_latest, method = "euclidean")
    
    hc.s <- hclust(E.dist, method = "single")
    hc.c <- hclust(E.dist, method = "complete")
    hc.a <- hclust(E.dist, method = "average")
    hc.w <- hclust(E.dist, method = "ward.D")  
    
    par(mar = c(1, 4, 4, 1), mfrow = c(1, 1))
    plot(hc.w, labels = DF.df.sort_latest$type, cex = 0.6, main = "ward.D showing 3 clusters")
    rect.hclust(hc.w, k = 5)
  })
  output$Plotly_KM1 <- renderPlot({
    set.seed(20)
    data_latest.km <- kmeans(data_latest, centers = 5, nstart = 50)
    
    data_latest.km$withinss
    
    data_latest.km_Table <- data.frame(group = DF.df.sort_latest$type, cluster = data_latest.km$cluster)
    data_latest_Table <- xtable(with(data_latest.km_Table, table(group, cluster)), 
                                caption = "Number of samples from each experimental group within each k-means cluster")
    
    fviz_cluster(data_latest.km,           
                 data = data_latest,       
                 geom = c("point","text"), 
                 frame.type = "norm")      
  })
  output$Plotly_KM2 <- renderPlot({
    data_latest.kmedoid <- pam(data_latest, k = 5)     
    data_latest.kmedoid$objective                      
    
    data_latest.kmedoid_Table <- data.frame(group = DF.df.sort_latest$type, 
                                            cluster = data_latest.kmedoid$clustering)
    data_latest_Table_1 <- xtable(with(data_latest.kmedoid_Table, table(group, cluster)), 
                                  caption = "Number of samples from each experimental group within each PAM cluster")
    
    
    par(mar = c(5, 1, 4, 4))
    plot(data_latest.kmedoid, main = "Silhouette Plot for 5 clusters")
    
    fviz_cluster(data_latest.kmedoid,   # 分群結果
                 data = data_latest,    # 資料
                 geom = c("point"),     # 點 (point)
                 frame.type = "norm")   # 框架型態
  })
}

# Run the application 
shinyApp(ui = ui, server = server)