library(tidyverse)
library(magrittr)
library(readxl)
library(ggmap)
library(shiny)
library(leaflet)
library(maps)
library(htmlwidgets)
library(mapdata) 
library(htmltools)

data <- read.csv(file = "public_schools.csv",header = TRUE , sep = ",")
data <- select(data,X,Y,ADDRESS,SCH_NAME,CITY)

ui <- fluidPage(
  titlePanel("Public schools in Boston"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("CITY","select city", unique(data$CITY)),
      numericInput("nu", "Select how many schools to show",value = 30),
      hr(),
      helpText("Data from the public schools in Boston")),
    mainPanel(
      leafletOutput(outputId = "plot")
    )
  )
)
  


server <- function(input,output,session) {
  output$plot = renderLeaflet({
    data = data %>% filter(CITY == input$CITY)
    plot = leaflet(data) %>% addTiles()%>%
      setView(lng= -71.0589, lat = 42.3601, zoom = 12)  %>% 
      addMarkers(data = data, lng =~X,lat =~Y, label = ~htmlEscape(SCH_NAME), popup = ~htmlEscape(ADDRESS))
    
    
    
    
      
    
  })
}


shinyApp(ui,server)











