library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(rsconnect)
library(readxl)

funds <- read_xlsx('vanguard.xlsx', range = 'B2:Z221')

returns <- funds %>% 
  filter(fund_type == 'Domestic Stock') %>%
  select(fund_name, fund_type, fund_category, one_year, 
         five_year, ten_year, beta)

returns <- returns %>% filter(beta > 0)

growth <- funds %>%
  filter(fund_type == 'Domestic Stock') %>%
  select(fund_name, fund_type, fund_category, 
         earnings_growth_rate, `price/earnings_ratio`)

inception <- funds %>%
  filter(fund_type == 'Domestic Stock') %>%
  select(fund_name, fund_type, fund_category,
         `since inception`, inception_date)

upper <- function(num, value1, value2, value3, value4, value5){
  p = list()
  for (x in num) {
    if (x == 1) {
      p[x] = value1
    } else if (x == 2){
      p[x] = value2
    } else if (x == 3){
      p[x] = value3
    } else{
      p[x] = value4
    }
  }
  return(p)
}

lower <- function(num, value1, value2, value3, value4, value5){
  q =  list()
  for (x in num) {
    if (x == 1) {
      q[x] = value2
    } else if (x == 2){
      q[x] = value3
    } else if (x == 3){
      q[x] = value4
    } else{
      q[x] = value5
    }
  }
  return(q)
}