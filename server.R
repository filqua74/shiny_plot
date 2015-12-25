# Economic variables Explorer - Based on Eurostat
# Project for Coursera Class
# Author: Filippo Quarta

fileName <- "stats.Rdata"
if (!file.exists(fileName)) {
  # Retrieve data from eurostat
  library(rsdmx)  
  download.file("http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/naida_10_gdp.sdmx.zip", destfile = "data.sdmx.zip")
  unzip("data.sdmx.zip", exdir = ".")
  fileNameSdmx <- "naida_10_gdp.sdmx.xml"
  sdmx <- readSDMX(fileNameSdmx,isURL = F)
  stats <- as.data.frame(sdmx)
  save(stats,fileName)
} else {
  load(fileName)
}

library(dplyr)
library(ggplot2)

s1 <- stats %>% filter(unit=="CP_MEUR") %>% select(geo,na_item,TIME_PERIOD, OBS_VALUE)
s1$OBS_VALUE <- as.numeric(s1$OBS_VALUE)
s1$TIME_PERIOD <- as.numeric(s1$TIME_PERIOD)

shinyServer(
  function(input, output) {
    
    output$resultPlot <- renderPlot({
        s2 <- s1 %>% filter(geo %in% input$country & 
                            na_item==input$quantity &
                            TIME_PERIOD >= input$period[1] &
                            TIME_PERIOD <= input$period[2])
        pl <- ggplot(data=s2)
        pl <- pl + geom_line(aes(x=TIME_PERIOD, y=OBS_VALUE, colour=geo))
        pl <- pl + labs(x="Year", y="Million of Euros")
        pl <- pl +  scale_colour_discrete(name  ="Country")
        print(pl)
    })
    
  })
