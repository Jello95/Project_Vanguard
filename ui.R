library(shiny)
library(shinyWidgets)
library(plotly)

fluidPage(
  titlePanel(
    'Mutual Fund / ETF Selection for 401K Portfolio'
  ),
  sidebarPanel(
    h3('Purpose'),
    p("This project aims to scrape fund level data from Vanguard's website
      and help users identify funds for their 401K portfolio. Users may enter
      in their own preferences based on risk-return, income, diversification, 
      and liquidity."),
    
    prettyCheckboxGroup(inputId = 'ghi',
                        label = 'Fund_Category',
                        choices = c('Large Blend', 'Large Growth',
                                    'Large Value', 'Mid-Cap Blend',
                                    'Mid-Cap Growth', 'Mid-Cap Value',
                                    'Small Blend', 'Small Growth',
                                    'Small Value'),
                        ),
    
    p("Attributes are shown below with 1 representing the top quartile and 
      4 representing the bottom quartile."),
    
    prettyCheckboxGroup(inputId = 'def',
                        label = 'SEC Yield',
                        choices = c(1:4),
                        shape = 'round',
                        inline = TRUE,
                        selected = 1:4
    ),
    
    prettyCheckboxGroup(inputId = 'abc',
                        label = 'Fund Size',
                        choices = c(1:4),
                        shape = 'round',
                        inline = TRUE,
                        selected = 1:4
    ),
    
    prettyCheckboxGroup(inputId = 'jkl',
                        label = 'Number of Stocks',
                        choices = c(1:4),
                        shape = 'round',
                        inline = TRUE,
                        selected = 1:4
    ),
    
  ),
  mainPanel(
    h3('Grouping Funds by Asset Class'),
    
    tabsetPanel(
      
      tabPanel('Short Term', plotlyOutput('scatter1', width = '100%')),
      tabPanel('Medium Term', plotlyOutput('scatter2', width = '100%')),
      tabPanel('Long Term', plotlyOutput('scatter3', width = '100%'))
    ),
    
    tabsetPanel(
      type = 'tabs',
      tabPanel('Fundamentals', plotlyOutput('scatter4', width = '100%')),
      tabPanel('Historical Performance', plotlyOutput('scatter5', width = '100%'))
    )
    
    ),
  
  absolutePanel(
    DT::dataTableOutput('table1', width = 800, height = 1100),
    top = 1100,
    left = 50
  )
)