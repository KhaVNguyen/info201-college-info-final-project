# reference server logic from kha
source("kha/server.R")
# reference server logic from zixiao
source("zixiao/server.R")
source("sam/server.R")
shinyServer(function(input, output) {
  # -- Net Price -- #
  
  # Net Prices Table Title
  output$net_prices_title <- renderUI({
    net_prices_title <- h2(paste("Statistics of all Colleges in", input$chosen_state))
  })
  
  # Net Prices Box and Whisker Plot 
  output$net_prices_plot <- renderPlot({
    net_prices_data <-
      get_net_prices_data(net_prices_dataset, input$chosen_state, input$income)
    plot_net_prices_data(net_prices_data, input$chosen_state)
  })
  
  # Net Prices Colleges in Budget Title
  output$colleges_in_budget_title <- renderUI({
    colleges_in_budget_title <- h2(paste("Colleges in", input$chosen_state, 
                                         "in your budget"))
  })
  
  # Net Prices Colleges in Budget Table
  output$colleges_in_budget_table = renderDataTable({
    get_net_prices_data_under_budget(net_prices_dataset, input$chosen_state, input$income, input$budget)
  })
  
  # --  Financial - Aid -- #
  ## Filter the data according to the user input
  getData <- reactive({
    data <- read.csv("zixiao/financial-aid.csv", stringsAsFactors = FALSE)
    state_abbrev = state.abb[match(input$state, state.name)]
    get_data <- filter(data, State == state_abbrev)
    if(input$radio == 0){
      get_data <- select(get_data,Institution.Name, City.location.of.institution, contains("loan"))
    } else {
      get_data <- select(get_data,Institution.Name, City.location.of.institution, contains("pell"))
    }
    get_data
  })
  
  ## Financial aid output data table
  output$table <- renderDataTable({
    result <- getData()%>%
      select(Institution.Name, City.location.of.institution, contains("1415"))%>%
      select(Institution.Name, City.location.of.institution, starts_with("Average"), starts_with("Percent"))
    names(result)[1] <- "Institution Name"
    names(result)[2] <- "City"
    names(result)[3] <- "Average (in $)"
    names(result)[4] <- "Pecent Accepted"
    result <- result%>%
      filter(!is.na(result[3]))
    result <- filter(result, result[3] >= input$expect)
  })   
  
  ## Average financial Aid Bar plot output
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
      labs(x = "Year", y = "State Average") + 
      theme_minimal()
    plot
  })
  
  ## Financial aid data table titile
  output$tableTitle <- renderUI({
    tableTitle <- h2(paste("Colleges in", input$state, 
                           "that fit your expectation"))
  })
  
  ## Financial aid plot title
  output$financialPlotTitle <- renderUI({
    plotTitle <- h2(paste("Average amount of financial aid given in", input$state_input, "(in $)"))
  }) 
  
  # --  Graduation Rates -- #
  getGrad <- reactive({
    data <- read.csv("sam/grad-rates.csv", stringsAsFactors = FALSE)
    ## Filter the data according to user select
    get_data <- filter(data, State == input$state_input)
    names(get_data)[1] <- "Institution_Name"
    get_data
  })
  
  ## Gets the data of the selected state
  output$gradtable <- renderDataTable({
    get_data <- getGrad()
    names(get_data)[8] <- "Graduation_Rate_2016"
    result <- get_data%>%
      select(Institution_Name, City,Graduation_Rate_2016)
    result <- filter(result, Graduation_Rate_2016 >= input$grad)
  })   
  
  ## generates title for the tab 
  output$gradTitle <- renderUI({
    tableTitle <- h2(paste("Colleges Graduation rate in", input$state_input, 
                           "that fit your expectation"))
  })
  ## generates title for the plot
  output$gradPlotTitle <- renderUI({
    plotTitle <- h2(paste("Average Graduation Rate of Recent Years in ", input$state_input))
  }) 
  
  ## Renaming and reshaping data to match the need to create the plot 
  output$gradplot <- renderPlot({
    average_grad <- getGrad() %>% 
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
    
    ## Created the plot to display graduation rate of recent years 
    plot <- ggplot(data = df, aes(x = year, y = average)) +
      geom_bar(stat="identity", fill="steelblue")+
      geom_text(aes(label= average), vjust=-0.3, size=3.5)+
      theme_minimal()
    plot
  })
})
