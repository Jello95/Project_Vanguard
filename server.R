library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library(shinyWidgets)
library(DT)

function(input, output){
  
  newgraph <- reactive({
    x = input$ghi
    newscatter <- returns %>% filter(fund_category %in% x)
    return(newscatter)
  })
  
  oldgraph <- reactive({
    x = input$ghi
    oldscatter <- growth %>% filter(fund_category %in% x)
    return(oldscatter)
  })
  
  badgraph <- reactive({
    x = input$ghi
    badscatter <- inception %>% filter(fund_category %in% x)
    return(badscatter)
  })
  
  newtable <- reactive({
    t = list(input$def)
    u = list(input$abc)
    v = list(input$jkl)
    
    x1 <- lapply(t, upper, 
                 value1 = 0.03590,
                 value2 = 0.01730,
                 value3 = 0.01490,
                 value4 = 0.01120,
                 value5 = 0)
    
    x2 <- lapply(u, upper,
                 value1 = 3.387e+11,
                 value2 = 1.570e+10,
                 value3 = 4.700e+09,
                 value4 = 7.113e+08,
                 value5 = 2.590e+07)
    
    x3 <- lapply(v, upper,
                 value1 = 3516,
                 value2 = 896,
                 value3 = 483,
                 value4 = 247,
                 value5 = 0)
    
    y1 <- lapply(t, lower, 
                 value1 = 0.03590,
                 value2 = 0.01730,
                 value3 = 0.01490,
                 value4 = 0.01120,
                 value5 = 0)
    
    y2 <- lapply(u, lower,
                 value1 = 3.387e+11,
                 value2 = 1.570e+10,
                 value3 = 4.700e+09,
                 value4 = 7.113e+08,
                 value5 = 2.590e+07)
    
    y3 <- lapply(v, lower,
                 value1 = 3516,
                 value2 = 896,
                 value3 = 483,
                 value4 = 247,
                 value5 = 0)
    
    newscreener <- funds %>%
                    select(fund_name, fund_type, fund_category,
                           sec_yield, fund_size, number_of_stocks) %>%
                    filter(fund_type == 'Domestic Stock') %>%
                    filter(sec_yield <= max(unlist(x1[[1]])) & 
                            sec_yield >= min(unlist(y1[[1]]))) %>%
                    filter(fund_size <= max(unlist(x2[[1]])) &
                           fund_size >= min(unlist(y2[[1]]))) %>%
                    filter(number_of_stocks <= max(unlist(x3[[1]])) & 
                           number_of_stocks >= min(unlist(y3[[1]]))
                           )
    
    return(newscreener)
  })
  
  output$scatter1 <- renderPlotly(
    newgraph() %>%
      ggplot(aes(x = beta, y = one_year, colour = fund_category,
                 label = fund_name)) +
      geom_point(stroke = 1) +
      labs(title = 'Short Term Risk Return', 
           x = 'Beta',
           y = '1 Year Return',
           xlim = c(0.7, 1.4),
           ylim = c(-0.2, 0.5)
           ) +
      theme_bw()
  )
  
  output$scatter2 <- renderPlotly(
    newgraph() %>%
      ggplot(aes(x = beta, y = five_year, colour = fund_category,
                 label = fund_name)) +
      geom_point(stroke = 1) +
      labs(title = 'Medium Term Risk Return', 
           x = 'Beta',
           y = '5 Year Return',
           xlim = c(0.7, 1.4),
           ylim = c(-0.2, 0.5)
           ) +
      theme_bw()
  )
  
  output$scatter3 <- renderPlotly(
    newgraph() %>%
      ggplot(aes(x = beta, y = ten_year, colour = fund_category,
                 label = fund_name)) +
      geom_point(stroke = 1) +
      labs(title = 'Long Term Risk Return', 
           x = 'Beta',
           y = '10 Year Return',
           xlim = c(0.7, 1.4),
           ylim = c(-0.2, 0.5)
           ) +
      theme_bw()
  )
  
  output$scatter4 <- renderPlotly(
    oldgraph() %>%
      ggplot(aes(x = `price/earnings_ratio`, y = earnings_growth_rate, 
                 colour = fund_category, label = fund_name)) +
      geom_point(stroke = 1) +
      labs(title = 'Fundamentals', 
           x = 'PE Ratio',
           y = 'Earnings Growth',
           xlim = c(0.7, 1.4),
           ylim = c(-0.2, 0.5)
      ) +
      theme_bw()
  )
  
  output$scatter5 <- renderPlotly(
    badgraph() %>%
      ggplot(aes(x = as.Date(inception_date, format = '%m/%d/%Y'), 
                 y = `since inception`,
                 colour = fund_category, label = fund_name)) +
      geom_point(stroke = 1) +
      labs(title = 'Historical Performance',
           x = 'Inception Date',
           y = 'Since Inception Returns') +
      scale_x_date(date_breaks = '10 years', date_labels = "%Y")+
      theme_bw()
  )
  
  output$table1 <- DT::renderDataTable({
    DT::datatable(newtable(), options = list(orderClasses = TRUE))
  })
  
}