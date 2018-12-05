library(shiny)

my_ui <- fluidPage(
  titlePanel("Student graduation rate in the United States"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "state",
        label = "State",
        choices = state.abb
      ),
      
      sliderInput(
        inputId = "grad",
        label = "Your expected graduation rate",
        min = 0,
        max = 100,
        value = 65,
        step = 5
      )
    ),
    mainPanel(
      htmlOutput("gradTitle"),
      dataTableOutput("gradtable"),
      htmlOutput("plotTitle"),
      plotOutput("gradplot")
    )
  )
)
shinyUI(my_ui) 