# Economic variables Explorer - Based on Eurostat
# Project for Coursera Class
# Author: Filippo Quarta
#


quantities <- c("Gross domestic product at market prices"="B1GQ",
                "External balance of goods and services"="B11",
                "Final consumption expenditure"="P3")

countries <- c("Belgium"="BE",
               "Greece"="EL", 
               "Lithuania"="LT",   
               "Portugal"="PT",
               "Bulgaria"="BG",
               "Spain"="ES",
               "Luxembourg"="LU",
               "Romania"="RO",
               "Czech Republic"="CZ",
               "France"="FR",
               "Hungary"="HU",
               "Slovenia"="SI",
               "Denmark"="DK",
               "Croatia"="HR",
               "Malta"="MT",
               "Slovakia"="SK",
               "Germany"="DE",
               "Italy"="IT",
               "Netherlands"="NL")

shinyUI(pageWithSidebar(
  headerPanel("Macroeconomics in Europe (1975-2010) - source: Eurostat"),
 
    sidebarPanel(
      helpText(HTML('Create a plot for comparing economic variables of several European countries.
               You can select the countries and the year range of interest.
               Original data has been retrieved through <a href="http://ec.europa.eu/eurostat/data/sdmx-data-metadata-exchange">Eurostat smdx interface.
               </a>. The complete source url is <a href="http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/naida_10_gdp.sdmx.zip">http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/naida_10_gdp.sdmx.zip</a>')),
      
      selectInput("quantity", "Variable:",
                         quantities),
      
      checkboxGroupInput("country", "Countries:",
                         countries, inline=TRUE),
      
      sliderInput("period", 
                  label = "Period of interest:",
                  min = 1975, max = 2014, value = c(2000, 2014))
    ),
    
    mainPanel(
      plotOutput('resultPlot'),
      tags$b("Overall Average (Million Euros)="),
      textOutput('overallAvg')
    )
  ))