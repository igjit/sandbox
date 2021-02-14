library(shiny)
library(reticulate)

use_python("../venv/bin/python3", required = TRUE)

pyfirmata <- import("pyfirmata")
board <- pyfirmata$Arduino("/dev/ttyACM0")
pin <- 13 + 1

ui <- fluidPage(
  titlePanel("R + ShinyでLチカ"),
  checkboxInput("checkbox", "digital 13", value = FALSE),
)

server <- function(input, output) {
  observe({
    cat(file = stderr(), "checkbox:", input$checkbox, "\n")
    board$digital[[pin]]$write(input$checkbox)
  })
}

shinyApp(ui = ui, server = server)
