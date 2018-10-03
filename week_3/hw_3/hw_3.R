library(ggplot2)

my_data <- read.csv("metro-bike-share-trip-data.csv")
my_data














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






