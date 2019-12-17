library(dplyr)
library(tidyverse)
library(knitr)
library(tidytext)
library(gridExtra)
library(shiny)
library(leaflet)
library(shinydashboard)

crime <- read.csv("~/Desktop/BU MSSP/615/final project/Vancouver crime/crime.csv")
crime <- na.omit(crime)
crime <- crime %>% dplyr::select(TYPE,YEAR,MONTH,DAY,NEIGHBOURHOOD,Latitude,Longitude)
crime <- crime %>% filter(YEAR==2015 | YEAR==2016)

#################
header <- dashboardHeader(title = p("Crime Report in 2015 & 2016"), titleWidth = 400)


dashboard <- column(width =4,
                     
                     box(width = NULL , title =tagList(shiny::icon("filter",class = 'fa-lg'), "Filter Data") ,
                         solidHeader = T, collapsible = T, status = 'info',
                         
                         selectizeInput('crimeType','Crime Type', choices =unique(crime$TYPE),
                                        selected = "Theft from Vehicle",width = 380,multiple = T),
                         
                         selectizeInput('Year','Year', choices =unique(crime$YEAR),
                                        selected = "2015",width = 380,multiple = T),
                         
                         selectizeInput('Month','Month', width = 380,choices =unique(crime$MONTH),
                                        selected = "1",
                                        multiple = T),
                         
                         sliderInput('Day','Day of Month',min = 1,max = 31,width = 380,value = 1,step = 1),
                        
                         submitButton(text = "Submit",icon =icon('filter'))
                     )
                     
)

map <- column(width =8,
               box(width = NULL, solidHeader = TRUE,
                   leafletOutput('VancouverMap',height = 500)))

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Vancouver", tabName = "Van", icon = icon("map"))
  )
)  

body <- dashboardBody(
  tabItems(
    tabItem(
      tabName="Van",
      fluidRow(
        dashboard, map
      )
    )
  )
)

ui <- dashboardPage(skin = 'blue',
                    header,
                    sidebar,
                    body
)

server <- function(input, output) {
  filteredData <- reactive({
    crime %>%
      filter(TYPE == input$crimeType ) %>%
      filter(YEAR == input$Year) %>%
      filter(MONTH == input$Month) %>%
      filter(DAY <= input$Day)
  })
  
  output$VancouverMap <- renderLeaflet({
    leaflet(filteredData())  %>% addTiles() %>%
      setView(lng = -123.1207, lat = 49.2827, zoom = 12)  %>%
      addMarkers(
        ~Longitude, ~Latitude,popup = ~NEIGHBOURHOOD,clusterOptions = markerClusterOptions()
      )
  })
}

shinyApp(ui = ui, server = server)

