library(shiny)
library(shinythemes)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("readable"),
  # Application title
  titlePanel("Net Prices of Colleges in the United States"),
  
  # Sidebar with a slider input for number of bins
  fluidRow(
    sidebarPanel(
      selectInput(
        inputId = "state",
        label = "State",
        choices = unique(state.name)
      ),
      sliderInput(
        inputId = "income",
        label = "Your Family's Annual Income in $",
        min = 0,
        max = 200000,
        value = 50000,
        step = 10000
      )
    ),
    mainPanel(
      htmlOutput("net_prices_title"),
      plotOutput("net_prices_plot")
    ),
    sidebarPanel(
      sliderInput(
        inputId = "budget",
        label = "Your Budget (in $)",
        min = 0,
        max = 75000,
        value = 30000,
        step = 1000
      )
    ),
    mainPanel(
      htmlOutput("colleges_in_budget_title"),
      dataTableOutput("colleges_in_budget_table")
    )
  )
)
)
