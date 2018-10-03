library(ggplot2)

iris
view(iris)
data = iris
mode(data)

temp = data.frame(matrix(unlist(data)), nrow = 150, byrow = T)
summary(temp)

ggplot(data = i, aes = )
