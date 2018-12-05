library(dplyr)
library(ggplot2)
library(stringr)


setwd("C:/Users/samch/Desktop/info201-college-info-final-project")

grad_rate <- read.csv(file = "grad-rates.csv", header = T, sep = ",")

## This function allow users to see the dataset by the state that they input 

search_by_state <- function(input_state){
  state_search <- grad_rate %>% filter(State == input_state)
  View(state_search)
}

## cleaning up data
grad_rate <- grad_rate %>% na.omit(grad_rate)
names(grad_rate)[1] <- "Institution_Name"

  
                            
