
# Define server logic required to draw a histogram
library("shiny")
library("dplyr")
library("data.table")
library("ggplot2")

my_server <- function(input, output){
  getData <- reactive({
    data <- read.csv("grad-rates.csv", stringsAsFactors = FALSE)
    ##filter the data according to user select
    get_data <- filter(data, State == input$state)
    names(get_data)[1] <- "Institution_Name"
    get_data
  })
  
  output$gradtable <- renderDataTable({
    get_data <- getData()
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
    plotTitle <- h2(paste("Average Graduation Rate of Recent Years in ", input$state))
  }) 
  
  output$gradplot <- renderPlot({
    average_grad <- getData() %>% 
      select(-Institution_Name, -City, -State) 
      names(average_grad)[1] <- "2011" 
      names(average_grad)[2] <- "2012" 
      names(average_grad)[3] <- "2013"
      names(average_grad)[4] <- "2014" 
      names(average_grad)[5] <- "2015" 
      names(average_grad)[6] <- "2016"
    year <- colnames(average_grad)
    average <- round(colMeans(average_grad, na.rm = TRUE))
    df <- data.frame(year, average)
     
    plot <- ggplot(data = df, aes(x = year, y = average)) +
      geom_bar(stat="identity", fill="steelblue")+
      geom_text(aes(label= average), vjust=-0.3, size=3.5)+
      theme_minimal()
    plot
  })
}
shinyServer(my_server)

