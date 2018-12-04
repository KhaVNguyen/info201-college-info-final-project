# AIN SHINY APPLICATION

library(shiny)

# Define UI for application that draws a histogram
shinyUI(navbarPage(
  # Application title
  "College Statistics",
  tabPanel("Net Prices",
           
           # Sidebar with a slider input for number of bins
           fluidPage(
             # Application title
             titlePanel("Net Prices of Colleges in the United States"),
             
             # Sidebar with a slider input for number of bins
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
           )),
  tabPanel("Financial Aid",
           fluidPage(
             titlePanel("Financial aids for student in the United States"),
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "state",
                   label = "State",
                   choices = state.abb
                 ),
                 radioButtons(
                   "radio",
                   label = "Select Federal student loans/Pell Grant",
                   choices = list("Federal student loans" = 0, "Pell Grant" = 1),
                   selected = 0
                 ),
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
           ))
))
