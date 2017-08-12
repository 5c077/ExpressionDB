# Function to return a heatmap for MuscleDB.


# Pagination to 
getPageHeat <- reactive({
  page = (input$nextPageHeat - input$prevPageHeat)
  
  if (page < 0) {
    page = 0
  } else {
    page = page
  }
})

output$heatmap <- renderPlotly({
  withProgress(message = 'Making plot', value = 0, {
    
    
    pageNum_heat = getPageHeat()
    
    iBeg = (pageNum_heat) * nObsHeat * length(input$muscles)  + 1
    iEnd = (pageNum_heat + 1) * nObsHeat * length(input$muscles)
    
    
    # Select just the expr cols and convert to wide df.
    filteredData = filterData() 
    
    # switching between volcano and plot causes a bit of mixing b/w filterData and the plotting
    # filtering happens quicker than plotting, so it gets confused and gives a temp warning/error
    if(!is.null(filteredData)) {
      if(! 'FC' %in% colnames(filteredData)){
        
        filteredData = filteredData %>% 
          select_(data_unique_id, 'tissue', 'expr') %>% 
          ungroup() 
        
        # rename columns to be consistent w/ what heatmaply wants
        colnames(filteredData) = c('name', 'variable', 'value') 
        
        
        # Check limits for iBeg and iEnd
        if(iEnd > nrow(filteredData)) {
          iEnd = nrow(filteredData)
        }
        
        
        # check if there's data.
        if (nrow(filteredData) == 0){
          #return an empty object
          heatmaply(matrix(0), dendrogram = 'none')
        } else {
          # Look only at small subset of data
          filteredData = filteredData %>% 
            slice(iBeg:iEnd)
          
          
          # Figure out how to scale the heatmap (no scaling, by row, log.)
          if(input$scaleHeat == "log") {
            scaleHeat = "none"
            
            filteredData = filteredData %>% 
              mutate(value = ifelse(value == 0, log10(min_expr), log10(value)))
            
            
          } else{
            scaleHeat = input$scaleHeat
          }
          
          
          
          # Draw the heatmap
          heatmaply(long_data = filteredData, scale = scaleHeat,
                    colors = heatmap_palette,
                    branches_lwd = 0.2, margins = c(50, 150, NA, 50),
                    dendrogram = if(input$orderHeat){'both'} else{'none'}
          )
        }
      } else {
        heatmaply(matrix(0), dendrogram = 'none')
      }
    }  else {
      heatmaply(matrix(0), dendrogram = 'none')
    }
  })
})
