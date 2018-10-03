library(ggplot2)
library(hexbin)
library(dplyr)

my_data <- read.csv("Downloads/avocado.csv", header=T, sep=",")
my_data

ggplot(data = my_data, mapping = aes(x = Total.Volume, y = AveragePrice)) + geom_point(alpha = 0.1, color = "brown")
my_data[my_data$type == 'conventional']
head(my_data, 20)
class(my_data)
str(my_data)
summary(my_data)
colume_name <- colnames(my_data)
colume_name

ggplot(data = my_data, mapping = aes(x = type)) + geom_bar(color = "brown")
ggplot(data = my_data, mapping = aes(x = Total.Bags, y = AveragePrice)) + geom_bar(stat = "identity", color = "brown")

ggplot(data = my_data, mapping = aes(x = year, y = Total.Bags))+geom_bar(stat="identity",fill="steelblue")
ggplot(data = my_data, mapping = aes(x = year, y = AveragePrice/338))+geom_bar(stat="identity",fill="steelblue")

my_data_organic <- my_data[grep("organic", my_data$type), ]
grep("organic", my_data$type)
View(my_data_organic)

my_data_Boston <- my_data[grep("Boston", my_data$region), ]
grep("Boston", my_data$region)
View(my_data_Boston)

my_data_Atlanta <- my_data[grep("Atlanta", my_data$region), ]
grep("Atlanta", my_data$region)
View(my_data_Atlanta)

my_data_Boston <- my_data[grep("Boston", my_data$region), ]
grep("Boston", my_data$region)
View(my_data_Boston)

my_data_California <- my_data[grep("California", my_data$region), ]
grep("California", my_data$region)
View(my_data_California)

my_data_Chicago <- my_data[grep("Chicago", my_data$region), ]
grep("Chicago", my_data$region)
View(my_data_Chicago)

my_data_Houston <- my_data[grep("Houston", my_data$region), ]
grep("Houston", my_data$region)
View(my_data_Houston)

my_data_composite <- bind_rows(my_data_Atlanta, my_data_Boston, my_data_California, my_data_Chicago, my_data_Houston)
ggplot(data = my_data_composite, mapping = aes(x = region, y = AveragePrice/338)) + geom_bar(stat = "identity", color = "grey")






------------------------------------------------------------




help(geom)





data_type <- type[,"conventional"]
my_data_1 <- my_data[,'type']







total_volume <- matrix(round(runif(14)*18249), nrow = 14)  
  










filter(type == "conventional" & region == "Albany") %>%

my_data_2 <- select(my_data, Total.Volume, type)
my_data_2

newdata <- my_data[which(my_data$type=="conventional")]
newdata



my_data_a <- my_data[ ,"type"]
my_data_a
my_data %% group_by(type) %% summarise(Total.Volume)
my_data %>% group_by(type) %%
  summarise(Total.Volume = sum(row = Total.Volume), type = "conventional")

sum(subset(my_data, type == "conventional", select == "Total.Volume"))
select(my_data, contains("conventional"))
select(my_data, contains("organic"))


class(my_data)
summary(my_data)







install.packages("hexbin")
install.packages("dplyr")
getwd()












install.packages("ggmap")
install.packages("mapproj")

library(ggmap)
library(mapproj)

map <- get_googlemap(location = 'Canada', zoom = 4)
ggmap(map)


library(ggmap)
library(mapproj)
map <- get_map( location =  c(lon = 105.3632715, lat = 29.7632836),zoom = 7)
ggmap(map)


get_map()



library(ggmap)
library(mapproj)
map <- get_map( location =  c(lon = 70.3632715, lat = 65.7632836),zoom = 7)
print(ggmap(map))



# 問題：
如何搜集特定的數據？(ex. 只想搜集conventional，但寫完之後一直說"type not found")
如何畫出多個變數的ggplot圖
如何把atlanta、boston等多個表合併？並重新弄一個region?因為原來的表有50多個region，圖塞不下......
如何查詢region是否有new york?

