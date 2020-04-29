# The main function is the.plots:
# options are "Country", "daysback", "series", and "bar"
# First slot is a country or "globally", e.g. "Sweden", "US", or "United Kingdom"
# second slot ("daysback") is the number of days you want to go back from today, e.g. 45
# third slot ("series") is which series you want to see:
# 1 deaths only (default)
# 2 both deaths and confirmed cases
# 3 confirmed cases only
# fourth slot ("bar") is whether you want a bar chart for the daily counts, or not
# default is FALSE; this gives you a line chart plus a seven point moving averge
# examples:
#
# the.plots("globally",45, 2)
# the.plots("Sweden",45)
# the.plots("US",45, bar = TRUE)
#
# The data come from Johns Hopkins 
# This is their impressive map:
# https://coronavirus.jhu.edu/map.html
#
# The map does not show individual countries as time series
# and that is why I wrote this script.
# Contact me if you have questions or suggestions: ulf.hognas@gmail.com
# Ulf H?gn?s

cov19 <-read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv", header=T)
confirmed19 <-read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv", header=T)

cov19<- cov19[,-c(3,4)]
confirmed19<- confirmed19[,-c(3,4)]
l <- ncol(confirmed19)

globalcount <- function(somedata){
  l <- ncol(somedata)
  global <- somedata[1,]
  global[1:2] <- c("","globally")
  global[3:l] <- colSums(somedata[,3:l])
  global
}

totalcount <- function(Country, somedata){
  l <- ncol(somedata)
  countryrows <- which(somedata$Country.Region==Country)
  newcount <- somedata[countryrows[1],]
  newcount[1] <- ""
  newcount[3:l]<-colSums(somedata[countryrows,3:l])
  newcount
}

cov19 <- rbind(cov19, totalcount("China",cov19), 
               totalcount("Australia",cov19),
               totalcount("Canada",cov19),
               globalcount(cov19))

confirmed19 <- rbind(confirmed19, totalcount("China",confirmed19), 
                     totalcount("Australia",confirmed19),
                     totalcount("Canada",confirmed19),
                     globalcount(confirmed19))

countryplot <- function(Country, daysback, somedata, seriestype, bar = TRUE){
  n<-ncol(somedata)
  cumTemp <- unlist(somedata[which(somedata$Country.Region==Country & somedata$Province.State==""),(n-daysback+1):n])
  l <- length(cumTemp)
  
  newTemp <- cumTemp[-1]-cumTemp[-l]
  
  
  names(newTemp) <- 2:l
  plot(1:l, cumTemp, type = "o", ylab = seriestype,
       xlab = "Days",
       main = paste("Cumulative", seriestype, Country))
  if (bar==TRUE){
    barplot(newTemp,
            main = paste("Daily", seriestype, Country))
  } else {
    plot(newTemp, type = "o", ylab = seriestype,
            main = paste("Daily", seriestype, Country))
    ma7 <- rep(0,(l-1))
    for (i in 4:(l-4)){
      ma7[i] <- mean(newTemp[(i-3):(i+3)]) 
    }
    lines(4:(l-4),ma7[4:(l-4)],lwd=2,col='navy')
    print(length(ma7[4:(l-4)]))
  }
}

the.plots <- function(Country, daysback, series = 1, bar = FALSE){
  par(mfrow=c((2-series%%2),2))
  if (series != 1){
    countryplot(Country, daysback, confirmed19, "Confirmed", bar) 
  } 
  if (series != 3){
    countryplot(Country, daysback, cov19, "Deaths", bar)  
  } 
}

the.plots("globally",45, 2, bar = FALSE)
the.plots("Sweden",45, bar = FALSE)
the.plots("US",45, bar = FALSE)
