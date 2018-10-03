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


library(ggmap)
library(mapproj)
register_google <- function(key = "AIzaSyBBeUPDxrLXly4GA0FoSucx0b6fhl4byHI", day_limit = 1000)
register_google



install.packages(mapproj)
library(mapproj)
library(forcats)

install.packages("ggmap")









register_google <- function (AIzaSyBBeUPDxrLXly4GA0FoSucx0b6fhl4byHI, account_type, client, signature, second_limit, day_limit) {
  
  # get current options
  options <- getOption("ggmap")
  
  # check for client/sig specs
  if (!missing(client) &&  missing(signature) ) {
    stop("if client is specified, signature must be also.")
  }
  if ( missing(client) && !missing(signature) ) {
    stop("if signature is specified, client must be also.")
  }
  if (!missing(client) && !missing(signature) ) {
    if (goog_account() == "standard" && missing(account_type)) {
      stop("if providing client and signature, the account type must be premium.")
    }
  }
  
  # construct new ones
  if(!missing(key)) options$google$key <- key
  if(!missing(account_type)) options$google$account_type <- account_type
  if(!missing(day_limit)) options$google$day_limit <- day_limit
  if(!missing(second_limit)) options$google$second_limit <- second_limit
  if(!missing(client)) options$google$client <- client
  if(!missing(signature)) options$google$signature <- signature
  
  # # set premium defaults
  if (!missing(account_type) && account_type == "premium") {
    if(missing(day_limit)) options$google$day_limit <- 100000
  }
  
  # class
  class(options) <- "ggmap_credentials"
  
  # set new options
  options(ggmap = options)
  
  # return
  invisible(NULL)
}







#' @rdname register_google
#' @export
goog_key <- function () {
  
  getOption("ggmap")$google$key
  
}

#' @rdname register_google
#' @export
has_goog_key <- function () {
  
  if(is.null(getOption("ggmap"))) return(FALSE)
  
  !is.na(goog_key())
  
}







#' @rdname register_google
#' @export
has_goog_account <- function () {
  
  if(is.null(getOption("ggmap"))) return(FALSE)
  
  !is.na(goog_account())
  
}

#' @rdname register_google
#' @export
goog_account <- function () {
  
  getOption("ggmap")$google$account_type
  
}








#' @rdname register_google
#' @export
goog_client <- function () {
  
  getOption("ggmap")$google$client
  
}

#' @rdname register_google
#' @export
has_goog_client <- function () {
  
  if(is.null(getOption("ggmap"))) return(FALSE)
  
  !is.na(goog_client())
  
}








#' @rdname register_google
#' @export
goog_signature <- function () {
  
  getOption("ggmap")$google$signature
  
}

#' @rdname register_google
#' @export
has_goog_signature <- function () {
  
  if(is.null(getOption("ggmap"))) return(FALSE)
  
  !is.na(goog_signature())
  
}





#' @rdname register_google
#' @export
goog_second_limit <- function () {
  
  # set to 50 if no key present (ggmap not loaded)
  if(!has_goog_key()) return(50)
  
  getOption("ggmap")$google$second_limit
  
}



#' @rdname register_google
#' @export
goog_day_limit <- function () {
  
  # set to 2500 if no key present (ggmap not loaded)
  if(!has_goog_key()) return(2500)
  
  getOption("ggmap")$google$day_limit
  
}







#' @rdname register_google
#' @param tree a json tree from \code{\link{fromJSON}}
#' @export
check_google_for_error <- function (tree) {
  
  if (tree$status == "REQUEST_DENIED") {
    warning("REQUEST_DENIED : ", tree$error_message)
  }
  
}
