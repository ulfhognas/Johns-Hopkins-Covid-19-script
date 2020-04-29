# Johns-Hopkins-Covid-19-script
An R script. Creates some Covid-19 time series plots for a single country or the whole globe.

Data is drawn from a data repository by Johns Hopkins CSSE (University Center for Systems Science and Engineering):

https://github.com/CSSEGISandData/COVID-19

The main function is the.plots:  
Options are "Country", "daysback", "series", and "bar".  

First slot is a country or "globally", e.g. "Sweden", "US", or "United Kingdom".  

Second slot ("daysback") is the number of days you want to go back from today, e.g. 45  

Third slot ("series") is which series you want to see:  
1 deaths only (default)  
2 both deaths and confirmed cases  
3 confirmed cases only  

Fourth slot ("bar") is whether you want a bar chart for the daily counts, or not.  
Default is FALSE; this gives you a line chart plus a seven point moving averge  
Examples:  

the.plots("globally",45, 2)  
the.plots("Sweden",45)  
the.plots("US",45, bar = TRUE)  

The data come from Johns Hopkins and this is their impressive map:  
https://coronavirus.jhu.edu/map.html  

The map does not show individual countries as time series and that is why I wrote this script.

