source("kha/server.R")
source("zixiao/server.R")
shinyServer(function(input, output) {
  # Net Price
  output$net_prices_title <- renderUI({
    net_prices_title <- h2(paste("Statistics of all Colleges in", input$chosen_state))
  })
  
  output$net_prices_plot <- renderPlot({
    net_prices_data <-
      get_net_prices_data(net_prices_dataset, input$chosen_state, input$income)
    plot_net_prices_data(net_prices_data, input$chosen_state)
  })
  
  output$colleges_in_budget_title <- renderUI({
    colleges_in_budget_title <- h2(paste("Colleges in", input$chosen_state, 
                                         "in your budget"))
  })
  
  output$colleges_in_budget_table = renderDataTable({
    get_net_prices_data_under_budget(net_prices_dataset, input$chosen_state, input$income, input$budget)
  })
  
  # Financial - Aid 
  getData <- reactive({
    data <- read.csv("zixiao/financial-aid.csv", stringsAsFactors = FALSE)
    ##filter the data according to user select
    get_data <- filter(data, State == input$state)
    if(input$radio == 0){
      get_data <- select(get_data,Institution.Name, City.location.of.institution, contains("loan"))
    } else{financialaid
      get_data <- select(get_data,Institution.Name, City.location.of.institution, contains("pell"))
    }
    get_data
  })
  
  output$table <- renderDataTable({
    result <- getData()%>%
      select(Institution.Name, City.location.of.institution, contains("1415"))%>%
      select(Institution.Name, City.location.of.institution, starts_with("Average"), starts_with("Percent"))
    names(result)[2] <- "City"
    names(result)[3] <- "Average (in $)"
    names(result)[4] <- "Pecent Accepted"
    result <- filter(result, "Average (in $)" >= input$expect)
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
})