# electricity_charge <- as.data.frame("electricity_charge")

Sys.setlocale(category = "LC_ALL", locale = "UTF-8")
electricity_charge <- read.csv("/Users/John/Documents/GitHub/CSX_RProject_Fall_2018/week_4/hw_4/hw_4_leafled map/electricity_charge.csv",
                               encoding = "UTF-8", header = TRUE, stringsAsFactors = FALSE)
electricity_charge


# 設定place經緯度變數
place <- c(electricity_charge$地址)

# 建立place的data.frame
place <- data.frame(lat=double(),lng=double())
library(googleway)
key <- "AIzaSyDoEDEiealBlFlpEUlW_pbUaVXX63hPHps"
#利用迴圈將經緯度資料放入dataframe中
for (i in 1:length(electricity_charge$地址)) {
  geo_result <- google_geocode(address = electricity_charge$地址[i], key = key)
  place <- rbind(place, geo_result$results$geometry$location)
  Sys.sleep(0.01)
}

df2 <- place[-c(361:368),]

library(dplyr)
df1 <- electricity_charge
df2 <- place[-c(361:368),]
df_place <- cbind(df1,df2)
df_place

lon <- sapply(df_place$lng, as.numeric)
lat <- sapply(df_place$lat, as.numeric)

library(leaflet)
map <- leaflet(df_place)
map <- addTiles(map)
map <- addMarkers(map, lon, lat, popup=paste("單位：", df_place$單位,"<br>",
                                             "地址：", df_place$地址,"<br>",
                                             "備註：", df_place$備註,"<br>"))
map

