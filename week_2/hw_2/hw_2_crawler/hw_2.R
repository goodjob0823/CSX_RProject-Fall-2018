install.packages("rvest")
library("rvest")


The_avengers <- read_html("https://www.imdb.com/title/tt0848228/?ref_=nv_sr_1")
#評分
rating <- The_avengers %>%
    html_nodes("strong span") %>%
    html_text() %>%
    as.numeric()
rating

#抓圖
poster <- The_avengers %>%
    html_nodes(".poster img") %>%
    html_attr("src")
poster

#票房
budget <- The_avengers %>%
    html_nodes('#titleDetails .txt-block:nth-child(12)') %>%
    html_text()
budget

Opening_Weekend_USA <- The_avengers %>%
    html_nodes('#titleDetails .txt-block:nth-child(13)') %>%
    html_text()
Opening_Weekend_USA

Gross_USA <- The_avengers %>%
    html_nodes('#titleDetails .txt-block:nth-child(14)') %>%
    html_text()
Gross_USA

Cumulative_Worldwide_Gross <- The_avengers %>%
    html_nodes('#titleDetails .txt-block:nth-child(15)') %>%
    html_text()
Cumulative_Worldwide_Gross


#總時間
time <- The_avengers %>%
    html_nodes('#titleDetails .txt-block:nth-child(23)') %>%
    html_text()
time
