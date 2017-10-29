output$pcaPlot = renderPlot({
  withProgress(message = 'Performing Principal Component Analysis...', value = 0, {
    
    # Call the PCA calculation
    pca_vals = calcPCA()
    incProgress(amount = 0.5)
    
    if(!is.null(pca_vals)){
      PCA = data.frame(pca_vals$x, ID = 1:nrow(pca_vals$x))
      
      mainPlot = ggplot(PCA, aes(x = PC1, y = PC2)) +
        xlab('principal component 1') +
        ylab('principal component 2') + 
        geom_point(size = dot_size, alpha = 0.3, colour = dot_color) +
        coord_cartesian(xlim = ranges$x, ylim = ranges$y) +
        theme_xy(16)
      
      s = input$PCApts_rows_selected
      
      
      if (length(s)) {
        # If the plot has been zoomed in, convert b/w the indices.
        
        if(!is.null(ranges$x)){    # After double click; highlight those w/i plot window
          PCA = PCA %>% 
            filter(PC1 >= ranges$x[1], PC1 <= ranges$x[2], 
                   PC2 >= ranges$y[1], PC2 <= ranges$y[2])
        }
        
        
        mainPlot + 
          geom_point(data = PCA[s, , drop = FALSE], 
                     colour = accent_color, 
                     size = dot_size,
                     alpha = 0.5)
      } else{
        mainPlot
      }
    }
    
  })
})


# Data table for filtered points ------------------------------------------

output$PCApts <- renderDataTable({
  
  # Calculate PCA using prcomp
  filtered = calcPCA()
  
  
  # switching between volcano and plot causes a bit of mixing b/w filterData and the plotting
  # filtering happens quicker than plotting, so it gets confused and gives a temp warning/error
  if(!is.null(filtered)) {
    if(! 'FC' %in% colnames(filtered)){
      
      # Return only the first two PCs.
      filtered = data.frame(filtered$x, ID = 1:nrow(filtered$x)) %>% 
        select(gene, PC1, PC2)
      
      # Check if there's brushing activated.  If not, display all.
      brush <- input$pcaBrush
      
      if (!is.null(brush)) {
        brushedPoints(filtered, brush) # Highlight only those brushed
      } else if(!is.null(ranges$x)){    # After double click; highlight those w/i plot window
        filtered %>% 
          filter(PC1 >= ranges$x[1], PC1 <= ranges$x[2], 
                 PC2 >= ranges$y[1], PC2 <= ranges$y[2])
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


# Brush/zoom --------------------------------------------------------------


# When a double-click happens, check if there's a brush on the plot.
# If so, zoom to the brush bounds; if not, reset the zoom.
observeEvent(input$pcaDblclick, {
  brush <- input$pcaBrush
  
  if (!is.null(brush)) {
    ranges$x <- c(brush$xmin, brush$xmax)
    ranges$y <- c(brush$ymin, brush$ymax)
    
  } else {
    ranges$x <- NULL
    ranges$y <- NULL
  }
})


# Loading table -----------------------------------------------------------


output$PCAload = renderDataTable({
  PCA = calcPCA()
  
  PCA$rotation[,1:2]
})


# Info box ----------------------------------------------------------------

output$PCAstats = renderInfoBox({
  PCA = calcPCA()
  
  stats = cumsum((PCA$sdev)^2) / sum(PCA$sdev^2)
  valueBox(subtitle = "Percent variance explained by PC1",
           width = NULL,
           value = round(stats[1]*100,1))
})
