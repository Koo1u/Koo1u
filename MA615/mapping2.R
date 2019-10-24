library(ggmap)
library(maptools)
library(maps)
library(shiny)
library(leaflet)
library(ggplot2)
library(sp)
library(htmlwidgets)
library(mapproj)
#mapWorld <- borders("world", colour="gray50", fill="white")
mapWorld <- map_data("world")

mp1 <- ggplot(mapWorld, aes(x=long, y=lat, group=group))+
  geom_polygon(fill="white", color="black") +
  coord_map(xlim=c(-180,180), ylim=c(-60, 90))


types <- c(Cylindrical="cylindrical", Mercator="mercator",Sinusoidal="sinusodal",Gnomonic="gnomonic",Rectangular="rectangular",Cylequalarea="cylequalarea")

ui <- fluidPage(
  titlePanel("Type of Maps"),
    selectInput("maps","Select types of map",choices = types),
    mainPanel(
      plotOutput(outputId = "plot")
    )
  )


server <- function(input,output,session) {
  mapWorld <- map_data("world")
  mp1 <- ggplot(mapWorld, aes(x=long, y=lat, group=group))+
    geom_polygon(fill="white", color="black") +
    coord_map(xlim=c(-180,180), ylim=c(-60, 90))
  output$plot <- renderPlot({
    if(input$maps == "rectangular" | input$maps== "cylequalarea" ) {
    mp2 <- mp1 + coord_map(input$maps,parameters = 0,xlim=c(-180,180), ylim=c(-60, 90))}
    else{
    mp2 <- mp1 + coord_map(input$maps,xlim=c(-180,180), ylim=c(-60, 90))
    }
    mp2
  })
}

shinyApp(ui,server)
