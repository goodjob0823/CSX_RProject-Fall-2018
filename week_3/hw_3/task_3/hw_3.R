library(ggplot2)
library(dplyr)
my_data <- read.csv("avocado.csv", header=T, sep=",", stringsAsFactors = F)
my_data


ggplot(data = my_data, mapping = aes(x = Total.Volume, y = AveragePrice)) + geom_point(alpha = 0.1, color = "brown")
head(my_data, 20)
class(my_data)
str(my_data)
summary(my_data)
colume_name <- colnames(my_data)
colume_name


ggplot(data = my_data, mapping = aes(x = year, y = Total.Bags))+geom_bar(stat="identity",fill="steelblue")
ggplot(data = my_data, mapping = aes(x = year, y = AveragePrice/4562))+geom_bar(stat="identity",fill="steelblue")


my_data_organic <- my_data[grep("organic", my_data$type), ]
grep("organic", my_data$type)
View(my_data_organic)


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




