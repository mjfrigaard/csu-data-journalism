library(shiny)
library(reactable)

theme <- reactableTheme(borderColor = "#dfe2e5", stripedColor = "#f6f8fa",
    highlightColor = "#f0f5f9", cellPadding = "8px 12px")

ui <- fluidPage(
  titlePanel("Biotech stock prices"),

  reactableOutput(outputId = "table")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot2::ggplot(data = iris, aes(x = Sepal.Length)) +
      geom_histogram()
  })

  output$table <- renderReactable({

    # define reactable data input ---------------------------------------------
    reactable(iris,
      filterable = TRUE, searchable = TRUE, sortable = FALSE,
      showPageSizeOptions = TRUE, onClick = "expand", striped = TRUE,
      columns = list(Sepal.Length = colDef(
        name = "Sepal Length",
        aggregate = "max", format = colFormat(
          suffix = " cm",
          digits = 1
        )
      ), Sepal.Width = colDef(
        name = "Sepal Width",
        defaultSortOrder = "desc", aggregate = "mean", format = list(aggregated = colFormat(
          suffix = " (avg)",
          digits = 2
        )), cell = function(value) {
          if (value >= 3.3) {
            classes <- "tag num-high"
          } else if (value >= 3) {
            classes <- "tag num-med"
          } else {
            classes <- "tag num-low"
          }
          value <- format(value, nsmall = 1)
          span(class = classes, value)
        }
      ), Petal.Length = colDef(
        name = "Petal Length",
        aggregate = "sum"
      ), Petal.Width = colDef(
        name = "Petal Width",
        aggregate = "count"
      ), Species = colDef(aggregate = "frequency")),
      details = function(index) {
        if (index == 3) {
          tabsetPanel(
            tabPanel("plot", plotOutput("plot")),
            tabPanel("subtable", reactable(iris[1:3, 1:2], fullWidth = FALSE))
          )
        } else if (index == 5) {
          paste("Details for row:", index)
        }
      }, theme = theme
    )
  })
}

shinyApp(ui, server)
