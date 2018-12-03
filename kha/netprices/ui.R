library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Net Prices of Colleges in the United States"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "state",
                  label = "State",
                  choices = unique(state.name)),
      sliderInput(inputId = "income",
                  label = "Your Family's Annual Income in $",
                  min = 0, 
                  max = 200000, 
                  value = 50000, 
                  step = 10000)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("netpricesplot")
    )
  )
))
