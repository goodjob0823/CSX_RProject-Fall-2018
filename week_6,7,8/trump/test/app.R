#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

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
    
    fviz_cluster(data_latest.kmedoid,   
                 data = data_latest,    
                 geom = c("point"),   
                 frame.type = "norm")   
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

