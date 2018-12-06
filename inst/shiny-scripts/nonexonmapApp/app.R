# app.R
#
# Ref: https://shiny.rstudio.com/tutorial/ Shiny tutorial
#

# Load packages ----
library(shiny)
library(ggplot2)
library(ggiraph)

# Load data ----
load(system.file("extdata/testdata", "testDataCount.Rdata", package = "nonexonmap"))

# Define UI ----
myUi <- fluidPage(

  titlePanel("Non-exon sequence mapping on reference sequence"),
  sidebarLayout( position = "right",
    sidebarPanel(
      helpText(h3("Please input reads file, transcripts file and introns file as needed.")),
      fileInput(inputId = "readsFile",
        label = "Input reads file:"
      ),
      fileInput(inputId = "transcriptsFile",
                   label = "Input transcripts file:"
                   ),
      fileInput(inputId = "intronsFile",
                  label = "Input introns file:"
                   ),
      # Horizontal line
      tags$hr(),
      helpText(h3("Please change the color of low and high value and what the color represents as needed.")),
      sliderInput(inputId = "lowColor",
                     label = "Low value color:",
                     min   = 1,
                     max   = 8,
                     value = 4),
      sliderInput(inputId = "highColor",
                    label = "High value color:",
                    min   = 1,
                    max   = 8,
                    value = 2),
      selectInput(inputId = "select",
                    label = "Select color display for",
                  choices = list("Average Intron Percent",
                                     "Number of Non-exon"),
                  selected = "Average Intron Percent"),
      helpText("Average Intron Percent is the average intron percent at each position if there are more than one introns at one position. Number of Non-exon is the number of non-exon at each position.")
    ),

    mainPanel(
      textOutput(outputId = "message"),
      ggiraphOutput("plot")
    )
  )
)

# Define Server ----
myServer <- function(input, output) {
  observe({
    if (is.null(input$readsFile) || is.null(input$transcriptsFile)) {
      message <-
        sprintf("Default reads file is RRHreads.fasta in extdata of nonexonmap package.
          Default transcriptsFile is RRHtranscripts.fasta in extdata of nonexonmap package.
          Default intronsFile is RRHintrons.fasta in extdata of nonexonmap package.
          Please upload reads file or transcriptsFile.")
      countLists <- testCountNonExon
    } else if (is.null(input$intronsFile)) {
      message <-
        sprintf("Uploaded reeds file is %s.
          Uploaded transcripts file is %s.
          No introns file is uploaded.",
          input$readsFile$name, input$transcriptsFile$name)
      countLists <- mainNonExonMap(input$readsFile$datapath, input$transcriptsFile$datapath)
    } else {
      message <-
        sprintf("Uploaded reeds file is %s.
          Uploaded transcripts file is %s.
          Uploaded introns file is %s.",
          input$readsFile$name, input$transcriptsFile$name, input$intronsFile$name)
      countLists <- mainNonExonMap(input$readsFile$datapath, input$transcriptsFile$datapath, input$intronsFile$datapath)
    }

    output$message <- renderText({message})

    output$plot <- renderggiraph({
      i <- 1L
      x <- as.numeric(countLists[[2]][[i]]) # position of introns

      # Create a table to present the number of occurance of non-exon sequence
      # exist at certain position
      data <- as.data.frame(table(x), stringsAsFactors = FALSE)

      # Initial a list to store the infomation of each non-exon sequence
      info <- c(1:8)
      averageIntronPercent <- c(1:8)
      for (j in 1:nrow(data)) {
        indexes <- which(x %in% data$x[j])
        info[j] <- sprintf("Putative intron(non-exon) exist at %d\n",
          as.numeric(data$x[j]))

        # Add the percentage of introns if countLists have the information
        totalIntronPercent <- 0L
        if (length(countLists) == 4) {
          z <- countLists[[4]][[i]]
          for (index in indexes) {
            totalIntronPercent <- totalIntronPercent + as.numeric(z[index]*100)
            info[j] <- paste(info[j],
              sprintf("Contains intron %.1f%%\n Contains exon %.1f%%\n",
                z[index]*100,    abs(1-z[index])*100))
          }
        }
        averageIntronPercent[j] <- totalIntronPercent / as.numeric(length(indexes))
      }

      # Change the color representation according to user interface
      if (input$select == "Average Intron Percent") {
        aes <- aes(tooltip = info[1:8], color  = averageIntronPercent)
      } else {
        numberOfNonExon <- data$Freq
        aes <- aes(tooltip = info[1:8], color = numberOfNonExon)
      }

      # Plot the non-exon map
      # https://davidgohel.github.io/ggiraph/articles/offcran/using_ggiraph.html
      g <- qplot(x = as.numeric(data$x), y = data$Freq)
      my_gg <- g +
        geom_point_interactive(aes, size = 2) +
        scale_y_continuous(name  = "Number of non-exon exists",
          breaks = c(1:(max(data$Freq)+1)),
          limits = c(0, max(data$Freq) +1)) +
        xlab(sprintf("Reference sequence %s", countLists[[1]][[i]])) +
        ggtitle(sprintf("Number of non-exon sequence located at\n reference sequence %s",
          countLists[[1]][[i]])) +
        scale_colour_gradient(low = input$lowColor, high = input$highColor)

    girafe(code = print(my_gg))

    })
  })
}

# Run APP ----
shinyApp(ui = myUi, server = myServer)

# [END]
