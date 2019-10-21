library(shiny)
library(plotly)
library(ECharts2Shiny)
##summary
ui <- fluidPage(
  tableOutput("static"),
  dataTableOutput("dynamic")
)
server <- function(input,output,session){
  output$static <- renderTable(head(sum_Th))
  output$dynamic <- renderDataTable(sum_Th,options = list(pageLength=5))
}
shinyApp(ui,server)
##scatter plot
ui <- fluidPage(
  plotlyOutput("plot")
)
server <- function(input,output){
  output$plot <- renderPlotly({
    plot_ly(New_Ning_Taxon_10,x = New_Ning_Taxon_10$n,y = New_Ning_Taxon_10$prop)
  })
}
shinyApp(ui,server)
##bar chart
ui <- fluidPage(
  titlePanel("Top 10 Taxon in 2 Ecoregion"),
  sidebarLayout(
    sidebarPanel(
      selectInput("number","Number:",
                  choices = colnames(df)),
      hr(),
      helpText("Data from the Reef Life Survey.")),
    mainPanel(
      plotOutput("bargraph")
    )  
    )
  )
server <- function(input,output,session){
  output$bargraph <- renderPlot({
    barplot(df[,input$number],
  main=input$number,
  ylab="Number of Taxon",xlab="species of Taxon")
  })
}
shinyApp(ui,server)












