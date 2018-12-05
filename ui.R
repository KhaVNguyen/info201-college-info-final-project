# MAIN SHINY APPLICATION

library(shiny)
library(shinythemes)
library(DT)

shinyUI(navbarPage(
  theme = shinytheme("readable"),
  # Application title
  "United States Colleges Tool",
  # -- Net Prices Page -- #
  tabPanel(
    "Net Prices",
    fluidPage(
      titlePanel("Net Prices of Colleges in the United States"),
      fluidRow(
        sidebarPanel(
          selectInput(
            inputId = "chosen_state",
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
  ),
  # -- Financial Aid Page -- #
  tabPanel(
    "Financial Aid",
    fluidPage(
      titlePanel("Financial Aid for Students in the United States"),
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "state",
            label = "State",
            choices = unique(state.name)
          ),
          radioButtons(
            "radio",
            label = "Select Federal student loans/Pell Grant",
            choices = list("Federal student loans" = 0, "Pell Grant" = 1),
            selected = 0
          ),
          sliderInput(
            inputId = "expect",
            label = "Your expectation (in $)",
            min = 0,
            max = 15000,
            value = 3000,
            step = 1000
          )
        ),
        mainPanel(
          htmlOutput("tableTitle"),
          dataTableOutput("table"),
          htmlOutput("financialPlotTitle"),
          plotOutput("plot")
        )
      )
    )
  ),
  tabPanel(
    "Graduation Rates",
    fluidPage(
      titlePanel("Student graduation rate in the United States"),
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "state_input",
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
          htmlOutput("gradPlotTitle"),
          plotOutput("gradplot")
        )
      )
    )
  ),
  # -- About Page -- #
  tabPanel(
    "About this Project",
    h2("Background"),
    tags$p(
      class = "lead",
      "This web application was created by Kha, Zixiao, and Sam for the Info 201 final project at University of Washington in Fall quarter 2018"
    ),
    h2("Our Goal"),
    tags$p(class = "lead", "Our target audience would be incoming college students and parents who want to gather data about 
         college options and general information about said colleges in a quick and easily-understandable format. 
         We want to provide them with as much information as possible without being too overwhelming so that they can make an informed decision about which college to attend."),
    h2("Where did the data come from?"),
    tags$p(class = "lead", HTML(paste0(
      "We used the ", a(href = "http://tuitiontracker.org/", "Tuition Tracker dataset, "),
      "which is 'powered by data provided by the U.S. department of Education from IPEDS, the 
                                   Integrated Postsecondary Education Data System. From there we will be using the 'financial aid,' 'graduation rates,' and 'net price' 
                                   datasets. Each individual data set lists for over 3400 individual colleges in the United States. 
                                   We found the data set by searching for data sets related to student on reddit.com/r/datasets."
    )))
  )
))