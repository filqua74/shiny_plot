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
    
    theData <- reactive({
      if (length(input$country)>0) {
        s2 <- s1 %>% filter(geo %in% input$country & 
                              na_item==input$quantity &
                              TIME_PERIOD >= input$period[1] &
                              TIME_PERIOD <= input$period[2])
        return(s2)
      } else {
        return(s1 %>% filter(TIME_PERIOD==-1))
      }
    })
    
    output$overallAvg <- renderText({
      averages <- theData() %>% group_by(TIME_PERIOD) %>% summarise(value = mean(OBS_VALUE))
      average <- mean(averages$value)
      average
    })
    
    output$resultPlot <- renderPlot({
          #averages <- s2 %>% group_by(TIME_PERIOD) %>% summarise(value = mean(OBS_VALUE))
          #average <- mean(averages$value)
          pl <- ggplot(data=theData())
          pl <- pl + geom_line(aes(x=TIME_PERIOD, y=OBS_VALUE, colour=geo))
          pl <- pl + labs(x="Year", y="Million of Euros")
          pl <- pl +  scale_colour_discrete(name  ="Country")
          print(pl)
    })
    
  })
