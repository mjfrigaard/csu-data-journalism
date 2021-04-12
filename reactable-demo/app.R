
# packages ----------------------------------------------------------------
library(shiny)
library(reactable)
library(ggplot2)


# define UI ---------------------------------------------------------------
ui <- fluidPage(

    # Application title
    titlePanel("Biotech stock prices"),

reactable(data = iris,
          columnGroups = list(colGroup(name = "Sepal",
                                       columns = c("Sepal.Length",
                                                   "Sepal.Width")),
                              colGroup(name = "Petal",
                                       columns = c("Petal.Length",
                                                   "Petal.Width"))),
          filterable = TRUE,
          searchable = TRUE,
          resizable = TRUE,
          showPageSizeOptions = TRUE,
          onClick = "expand",
          outlined = TRUE,
          bordered = TRUE,
          borderless = TRUE,
          striped = TRUE,
          highlight = TRUE,
          compact = TRUE,
          showSortable = TRUE,

    defaultSorted = c("Sepal.Length", "Sepal.Width"),
    columns = list(
        Sepal.Length = colDef(name = "Length",
                              aggregate = "max",
                              format = colFormat(suffix = " cm",
                                                 digits = 1)),
        Sepal.Width = colDef(name = "Width",
                             defaultSortOrder = "desc",
                             aggregate = "mean",
                             format = list(aggregated =
                                               colFormat(suffix = " (avg)",
                                                         digits = 2)),
                                cell = function(value) {
                                    if (value >= 3.3) {
                                        classes <- "tag num-high"
                                        } else if (value >= 3) {
                                            classes <- "tag num-med"
                                        } else {
                                            classes <- "tag num-low"
                                        }
                                    value <- format(value, nsmall = 1)
                                    span(class = classes, value)
                                        },
                                footer = function(values) {
                                            div(tags$b("Average: "),
                                                round(x = mean(values),
                                                      digits = 1))
                                                            }),
        Petal.Length = colDef(name = "Length", aggregate = "sum"),
        Petal.Width = colDef(name = "Width", aggregate = "count"),
        Species = colDef(aggregate = "frequency")),
            details = function(index) {
                if (index == 3) {
                    tabsetPanel(
                        tabPanel(title = "plot",
                                 plotOutput(outputId = "plot")),
                        tabPanel(title = "subtable",
                                 reactable(iris[1:3, 1:2],
                                           fullWidth = FALSE)))
                    } else if (index == 5) {
                        paste("Details for row:", index)
                    }
                }
    )
)

# Define server -----------------------------------------------------------
server <- function(input, output) {

    output$plot <- renderPlot({
        ggplot2::ggplot(data = iris, aes(x = Sepal.Length)) +
            geom_histogram()
    })

}

# Run the application  --------------------------------------------------
shinyApp(ui = ui, server = server)
