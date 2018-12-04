
# Define server logic required to draw a histogram
library("shiny")
library("lubridate")
library("dplyr")
library("stringr")
library("R.utils")
library("data.table")
library("ggplot2")
library("maps")

my_server <- function(input, output) {
  getData <- reactive({
    data <- read.csv("financial-aid.csv", stringsAsFactors = FALSE)
    ##filter the data according to user select
    get_data <- filter(data, State == input$state)
    if(input$radio == 0){
    get_data <- select(get_data,Institution.Name, City.location.of.institution, contains("loan"))
    } else{
    get_data <- select(get_data,Institution.Name, City.location.of.institution, contains("pell"))
    }
    get_data
  })
  
  output$table <- renderDataTable({
    result <- getData()%>%
      select(Institution.Name, City.location.of.institution, contains("1415"))%>%
      select(Institution.Name, City.location.of.institution, starts_with("Average"), starts_with("Percent"))
    names(result)[2] <- "City"
    names(result)[3] <- "Average"
    names(result)[4] <- "Pecent% to gain"
    result <- filter(result, Average >= input$expect)
    })   
  output$plot <- renderPlot({
    r <- getData()%>%
      select(contains("Average"))
    names(r)[1] <- "15-16"
    names(r)[2] <- "14-15"
    names(r)[3] <- "13-14"
    names(r)[4] <- "12-13"
    names(r)[5] <- "11-12"
    names(r)[6] <- "10-11"
    names(r)[7] <- "09-10"
    names(r)[8] <- "08-09"
    col <- colnames(r)
    mean <- round(colMeans(r, na.rm = TRUE))
    result <- data.frame(year = col, State_average = mean)
    plot <- ggplot(data = result, aes(x = year, y = State_average)) +
      geom_bar(stat="identity", fill="steelblue")+
      geom_text(aes(label=mean), vjust=-0.3, size=3.5)+
      theme_minimal()
    plot
  })
  output$tableTitle <- renderUI({
    tableTitle <- h2(paste("Colleges in", input$state, 
                                         "that fit your expectation"))
  })
  output$plotTitle <- renderUI({
    plotTitle <- h2(paste("Average level in", input$state))
  }) 
}
shinyServer(my_server)

