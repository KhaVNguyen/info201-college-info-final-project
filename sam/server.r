
# Define server logic required to draw a histogram
library("shiny")
library("dplyr")
library("data.table")
library("ggplot2")

my_server <- function(input, output) {
  getData <- reactive({
    data <- read.csv("grad-rates.csv", stringsAsFactors = FALSE)
    ##filter the data according to user select
    get_data <- filter(data, State == input$state)
    get_data
  })
  
  output$gradtable <- renderDataTable({
    get_data <- getData()
    names(get_data)[1] <- "Institution_Name"
    names(get_data)[8] <- "Graduation_Rate_2016"
    result <- get_data%>%
      select(Institution_Name, City,Graduation_Rate_2016)
    result <- filter(result, Graduation_Rate_2016 >= input$grad)
  })   
 
  output$gradTitle <- renderUI({
    tableTitle <- h2(paste("Colleges Graduation rate in", input$state, 
                           "that fit your expectation"))
  })
  output$plotTitle <- renderUI({
    plotTitle <- h2(paste("Average level in", input$state))
  }) 
}
shinyServer(my_server)

