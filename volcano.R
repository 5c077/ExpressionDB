# volcano table -----------------------------------------------------------

output$volcanoTable <- renderDataTable({
  filtered = filterData() 

  
  if(!is.null(filtered)){ # check object exists
    if(! 'expr' %in% colnames(filtered)) { # checks if the data has finished being transformed to a wide format
      filtered = filtered %>% 
        mutate(FC = signif(FC, 3),
               logFC = signif(logFC, 3),
               logQ = signif(logQ, 3))
      
      brushedPoints(filtered, input$volcanoBrush)
      
      
      # Check if there's brushing activated.  If not, display all.
      brush <- input$volcanoBrush
      
      if (!is.null(brush)) {
        brushedPoints(filtered, brush) # Highlight only those brushed
      } else if(!is.null(ranges$x)){    # After double click; highlight those w/i plot window
        filtered %>% 
          filter(logFC >= ranges$x[1], logFC <= ranges$x[2], 
                 logQ >= ranges$y[1], logQ <= ranges$y[2])
      } else {
        filtered
      }
    }
  }
  
},  
escape = c(-1,-2, -3),
options = list(searching = TRUE, stateSave = TRUE,
               pageLength = 25,
               rowCallback = JS(
                 'function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
        if (aData[0])
          $("td:eq(0)", nRow).css("color", "#293C97");
          $("td", nRow).css("text-align", "center");
      }')
)
)


# ggplot zoom -------------------------------------------------------------


# When a double-click happens, check if there's a brush on the plot.
# If so, zoom to the brush bounds; if not, reset the zoom.
# Code from RStudio (thanks, guys) http://shiny.rstudio.com/gallery/plot-interaction-zoom.html

# Single zoomable plot (on left)
ranges <- reactiveValues(x = NULL, y = NULL)


# When a double-click happens, check if there's a brush on the plot.
# If so, zoom to the brush bounds; if not, reset the zoom.
observeEvent(input$volcanoDblclick, {
  brush <- input$volcanoBrush
  if (!is.null(brush)) {
    
    ranges$x <- c(brush$xmin, brush$xmax)
    ranges$y <- c(brush$ymin, brush$ymax)
    
  } else {
    ranges$x <- NULL
    ranges$y <- NULL
  }
})


# Muscle selection boxes --------------------------------------------------


output$m1 = renderUI(
  selectInput('muscle1', label = 'sample 1',
              choices = input$muscles,
              width = '200px'))

output$m2 = renderUI(
  selectInput('muscle2', label = 'samplele 2 (reference)',
              choices = input$muscles,
              width = '200px'))


# volcano tooltip ---------------------------------------------------------





# ggvis volcano output ----------------------------------------------------

output$volcanoPlot <- renderPlot({
  withProgress(message = 'Making plot', value = 0, {
    filteredData = filterData()
    
    incProgress(amount = 0.5)
    
    if(!is.null(filteredData)){ # check object exists
      if(! 'expr' %in% colnames(filteredData)) { # checks if the data has finished being transformed to a wide format
        # Temporary plot to be replaced by interactive version.  
        ggplot(filteredData, aes(y = logQ, x = logFC)) +
          geom_point(size = 3, alpha  = 0.3, colour = 'dodgerblue') +
          coord_cartesian(xlim = ranges$x, ylim = ranges$y) +
          theme(title = element_text(size = 32, color = grey90K),
                axis.line = element_blank(),
                axis.ticks = element_blank(),
                axis.text = element_text(size = 16, color = grey60K),
                axis.title = element_text(size = 18, color = grey60K),
                legend.position="none",
                panel.grid.major = element_line(color = grey60K, size = 0.2),
                panel.border = element_blank(),
                plot.margin = rep(unit(0, units = 'points'),4),
                panel.background = element_blank(),
                strip.text = element_text(size=13, face = 'bold', color = grey60K),
                strip.background = element_blank()
          )
      }
    }
  })
})

# Save volcano csv --------------------------------------------------------

output$csvVolcano <- downloadHandler(
  filename = function() {
    paste('volcano_data-', Sys.Date(), '.csv', sep='')
  },
  content = function(file) {
    filteredData = filterData()
    
    write.csv(filteredData, file)
  }
)
