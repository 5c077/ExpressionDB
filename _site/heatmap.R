# Function to return a heatmap for MuscleDB.



getPageHeat <- reactive({
  page = (input$nextPageHeat - input$prevPageHeat)
  
  if (page < 0) {
    page = 0
  } else {
    page = page
  }
})

output$heatmap <- renderD3heatmap({
  nPlotsHeat = 100
  pageNum_heat = getPageHeat()
  
  iBeg = (pageNum_heat)*nPlotsHeat + 1
  iEnd = (pageNum_heat + 1)*nPlotsHeat
  
  
  # Select just the expr cols and convert to wide df.
  filteredData = filterData() %>% 
    select(transcript, gene, tissue, expr) %>% 
    spread(tissue, expr)
  
  # Check limits for iBeg and iEnd
  if(iEnd > nrow(filteredData)) {
    iEnd = nrow(filteredData)
  }
  

  
  # check if there's data.
  if (nrow(filteredData) == 0){
    #return an empty object
    d3heatmap(rep(0,2), dendrogram = 'none')
    print('no data')
  } else {
    # Look only at small subset of data
    filteredData = filteredData %>% 
      slice(iBeg:iEnd)
    
    
    # Pull out the names to display
    heatNames = filteredData %>% 
      mutate(name = paste0(gene, " (", transcript, ")")) %>% 
      select(name)
    
    # Remove the non-numeric columns. 
    filteredData = filteredData %>% 
      select(-transcript, -gene)
    
    
    # Figure out how to scale the heatmap (no scaling, by row, log.)
    if(input$scaleHeat == "log") {
      scaleHeat = "none"
      
      filteredData = filteredData %>% 
        mutate_each(funs(log10))
      
      
      filteredData[filteredData == -Inf] = NA #! Note!  Fix this.  NA's don't work with foreign call to calc dendrogram.
      
    } else{
      scaleHeat = input$scaleHeat
    }
    
    # Draw the heatmap
    d3heatmap(filteredData, scale = scaleHeat, 
              dendrogram = if(input$orderHeat){'both'} else{'none'}, 
              # Rowv = TRUE, Colv = TRUE, 
              show_grid = TRUE, color="YlOrRd", labRow = t(heatNames),
              xaxis_height = 100, yaxis_width = 200
    )
  }
})

output$heatmapScale = renderPlot({
  nPlotsHeat = 100
  pageNum_heat = getPageHeat()
  
  iBeg = (pageNum_heat)*nPlotsHeat + 1
  iEnd = (pageNum_heat + 1)*nPlotsHeat
  
  # Hack for now, to only look at small subset of data
  # Select just the expr cols and convert to wide df.
  filteredData = filterData() %>% 
    select(transcript, gene, tissue, expr) %>% 
    spread(tissue, expr) %>% 
    slice(iBeg:iEnd)
  
  
  exprLimits = filteredData %>% 
    select(-transcript, -gene) %>% 
    summarise_each(funs(max, min))
  
  minExpr = min(exprLimits)
  
  maxExpr = max(exprLimits)
  
  
  
})