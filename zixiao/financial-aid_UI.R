library(shiny)

my_ui <- fluidPage(
  titlePanel("Financial aids for student in the United States"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "state",
        label = "State",
        choices = state.abb
      ),
      radioButtons("radio", label = "Select Federal student loans/Pell Grant",
                   choices = list("Federal student loans" = 0, "Pell Grant" = 1), 
                   selected = 0),
      sliderInput(
        inputId = "expect",
        label = "Your expectation $",
        min = 0,
        max = 15000,
        value = 3000,
        step = 1000
      )
    ),
    mainPanel(
      htmlOutput("tableTitle"),
      dataTableOutput("table"),
      htmlOutput("plotTitle"),
      plotOutput("plot")
    )
  )
)
shinyUI(my_ui) 