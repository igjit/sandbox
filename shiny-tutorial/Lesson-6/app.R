library(shiny)
library(quantmod)

source("helpers.R")

ui <- fluidPage(
  titlePanel("stockVis"),
  sidebarLayout(
    sidebarPanel(
      helpText("Select a stock to examine.

        Information will be collected from Yahoo finance."),
      textInput("symb", "Symbol", "SPY"),
      dateRangeInput("dates",
                     "Date range",
                     start = "2013-01-01",
                     end = as.character(Sys.Date())),
      br(),
      br(),
      checkboxInput("log", "Plot y axis on log scale",
                    value = FALSE),
      checkboxInput("adjust",
                    "Adjust prices for inflation", value = FALSE)
    ),
    mainPanel(plotOutput("plot"))
  )
)

server <- function(input, output) {
  dataInput <- reactive({
      getSymbols(input$symb, src = "yahoo",
          from = input$dates[1],
          to = input$dates[2],
          auto.assign = FALSE)
  })

  finalInput <- reactive({
    if (!input$adjust) return(dataInput())
    adjust(dataInput())
  })

  output$plot <- renderPlot({
    chartSeries(finalInput(), theme = chartTheme("white"),
        type = "line", log.scale = input$log, TA = NULL)
  })
}

shinyApp(ui, server)
