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
            label = "Your Family's Annual Income in US $",
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
            label = "Your Budget (in US $)",
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
          ## Choose the state to check
          selectInput(
            inputId = "state",
            label = "State",
            choices = unique(state.name)
          ),
          ## A radio button to chooce the Financial aid type
          radioButtons(
            "radio",
            label = "Select Federal student loans/Pell Grant",
            choices = list("Federal student loans" = 0, "Pell Grant" = 1),
            selected = 0
          ),
          ##Slider to choose the expectation aid
          sliderInput(
            inputId = "expect",
            label = "Your expectation (in US $)",
            min = 0,
            max = 15000,
            value = 3000,
            step = 1000
          )
        ),
        ##output data table and bar plot
        mainPanel(
          htmlOutput("tableTitle"),
          dataTableOutput("table"),
          htmlOutput("financialPlotTitle"),
          plotOutput("plot")
        )
      )
    )
  ),
  # -- Graduation Rates Page -- #
  tabPanel(
    "Graduation Rates",
    fluidPage(
      titlePanel("Student Graduation Rate in the United States"),
      sidebarLayout(
        sidebarPanel(
          ## Allow users to choose a State to inspect
          selectInput(
            inputId = "state_input",
            label = "State",
            choices = unique(state.name)
          ),
          
          ## A slider that filters out schools under the selected rate
          sliderInput(
            inputId = "grad",
            label = "Your expected graduation rate",
            min = 0,
            max = 100,
            value = 65,
            step = 5
          )
        ),
        ## plots the trend of the average graduation rate of the selected state over the years
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
    tags$p(HTML(paste0(
      "We used the ", a(href = "http://tuitiontracker.org/", "Tuition Tracker dataset, "),
      "which is 'powered by data provided by the U.S. department of Education from IPEDS, the 
                                   Integrated Postsecondary Education Data System. From there we will be using the 'financial aid,' 'graduation rates,' and 'net price' 
                                   datasets. Each individual data set lists for over 3400 individual colleges in the United States. 
                                   We found the data set by searching for data sets related to student on reddit.com/r/datasets."
    
      ))),
    h2("What questions did we want to answer?"),
    tags$ul(
      tags$li("What are the statistics for lowest, mean, and highest net prices for colleges in the given state?"), 
      tags$li("What are the statistics for lowest,mean and highest federal state local or institutional grant aid for colleges in the given state?"), 
      tags$li("What are the statistics for the net graduation rate per year for each college in a given state?")
    ),
    h2("What users might be able to find through using our tool ... "),
    tags$p(HTML(paste0("The following might be what a user might find from selecting ", strong("Washington"), " state."))),
    tags$ul(
      tags$li("With a family income level of $100,000 a year, the median average net price is roughly $25,000 for private schools
              and $13,000 for public schools. The lowest cost private school in Washington costs "),
      tags$li("User can view a list of colleges under a budget for example of $7000, which are the following:
              Gadsden State Community College, Snead State Community College, Spring Hill College"),
      tags$li("User can compare how much a college offers in financial aid money in comparison to the state's averages
              in recent years. We noticed the financial aid averages in the state of Washington have
              stayed relatively the same over the past 8 years."),
      tags$li("Washington's colleges' graduation rates tend to be around roughly 58% over the past 6 years, 
              with the lowest of 53 in 2013")
    )
  )
))