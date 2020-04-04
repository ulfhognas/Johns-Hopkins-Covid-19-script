#The main function is the.plots:
#First slot is a country or "globally"
#second slot is the number of days you want to go back from today
#third slots is which series you want to see
# 1 deaths only (default)
# 2 both deaths and confirmed cases
# 3 confirmed cases only
#examples:
#
#the.plots("globally",31)
#the.plots("China",70, 2)
#the.plots("Sweden",30)
#
#The data come from Johns Hopkins 
#This is their impressive map:
#https://coronavirus.jhu.edu/map.html
#
#The map does not show individual countries as time series
#and that is why I wrote this script.
#Contact me if you have questions or suggestions: ulf.hognas@gmail.com
#Ulf Högnäs
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

countryplot <- function(Country, daysback, somedata, type){
  n<-ncol(somedata)
  cumTemp <- unlist(somedata[which(somedata$Country.Region==Country & somedata$Province.State==""),(n-daysback+1):n])
  l <- length(cumTemp)
  
  newTemp <- cumTemp[-1]-cumTemp[-l]

  
  names(newTemp) <- 2:l
  plot(1:l, cumTemp, type = "o", ylab = type,
       xlab = "Days",
       main = paste("Cumulative", type, Country))
  barplot(newTemp,
          main = paste("Daily", type, Country))
}

the.plots <- function(Country, daysback, series = 1){
  par(mfrow=c((2-series%%2),2))
  if (series != 1){
    countryplot(Country, daysback, confirmed19, "Confirmed") 
  } 
  if (series != 3){
    countryplot(Country, daysback, cov19, "Deaths")  
  } 
}

the.plots("globally",31,1)

