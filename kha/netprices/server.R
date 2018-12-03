library(dplyr)
library(tidyr)
library(ggplot2)

net_prices_dataset <-
  read.csv("net-price.csv", stringsAsFactors = FALSE)


get_net_prices_data <-
  function(net_prices, chosen_state, income_level) {
    state_abbrev = state.abb[match(chosen_state, state.name)]
    net_prices_in_state <- filter(net_prices, state == state_abbrev)
    # Control = public or private
    net_prices_in_state$pub_or_priv <-
      sapply(net_prices_in_state$control, get_pub_or_priv)
    net_prices_for_income_level <-
      get_net_prices_from_income_level(net_prices_in_state, income_level)
    ggplot(net_prices_for_income_level,
           aes(x = pub_or_priv, y = net_price)) +
      geom_boxplot() + 
      labs(x = "School Type", y = "Net Price in $", title = paste("Net Prices of Colleges in", chosen_state))
  }

# Gets whether a school is a public or a private school
get_pub_or_priv <- function(control) {
  if (control == 1) {
    return ("Public")
  } else if (control == 2 | control == 3) {
    return ("Private")
  } else {
    return ("Neither")
  }
}

# Gets a datset of the average net prices of schools
# in the given dataset given your income level
get_net_prices_from_income_level <-
  function(net_prices, income_level) {
    if (income_level <= 30000) {
      pub_priv_net_prices <- select(
        net_prices,
        avg_net_price_income_0_to_30000_pub,
        avg_net_price_income_0_to_30000_priv,
        pub_or_priv
      ) %>%
        mutate(
          net_price = coalesce(
            avg_net_price_income_0_to_30000_pub,
            avg_net_price_income_0_to_30000_priv
          )
        )
      # Net price represents the cost, whether the public or private school price depending on if the school
      # is public or private (one column will be NA, the other will have a value)
    } else if (income_level > 30000 & income_level <= 48000) {
      pub_priv_net_prices <- select(
        net_prices,
        avg_net_price_income_30001_to_48000_pub,
        avg_net_price_income_30001_to_48000_priv,
        pub_or_priv
      ) %>%
        mutate(
          net_price = coalesce(
            avg_net_price_income_30001_to_48000_pub,
            avg_net_price_income_30001_to_48000_priv
          )
        )
    } else if (income_level > 48000 & income_level <= 75000) {
      pub_priv_net_prices <- select(
        net_prices,
        avg_net_price_income_48001_to_75000_pub,
        avg_net_price_income_48001_to_75000_priv,
        pub_or_priv
      ) %>%
        mutate(
          net_price = coalesce(
            avg_net_price_income_48001_to_75000_pub,
            avg_net_price_income_48001_to_75000_priv
          )
        )
    } else if (income_level > 75000 & income_level <= 110000) {
      pub_priv_net_prices <- select(
        net_prices,
        avg_net_price_income_75001_to_110000_pub,
        avg_net_price_income_75001_to_110000_priv,
        pub_or_priv
      ) %>%
        mutate(
          net_price = coalesce(
            avg_net_price_income_75001_to_110000_pub,
            avg_net_price_income_75001_to_110000_priv
          )
        )
    } else if (income_level > 110000) {
      pub_priv_net_prices <- select(
        net_prices,
        avg_net_price_income_over_110000_pub,
        avg_net_price_income_over_110000_priv,
        pub_or_priv
      ) %>%
        mutate(
          net_price = coalesce(
            avg_net_price_income_over_110000_pub,
            avg_net_price_income_over_110000_priv
          )
        )
    }
    pub_priv_net_prices <- pub_priv_net_prices %>%
      select(pub_or_priv, net_price) %>%
      na.omit()
    return (pub_priv_net_prices)
  }

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$netpricesplot <- renderPlot({
    get_net_prices_data(net_prices_dataset, input$state, input$income)
  })
})
