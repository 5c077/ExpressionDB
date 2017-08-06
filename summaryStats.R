output$avgExpr <- renderInfoBox({
  filteredData = filterData()
  
  # switching between volcano and plot causes a bit of mixing b/w filterData and the plotting
  # filtering happens quicker than plotting, so it gets confused and gives a temp warning/error
  if(!is.null(filteredData)) {
    if(! 'FC' %in% colnames(filteredData)){
      avgVal = filteredData %>% 
        summarise(round(mean(expr),2))
      
      infoBox("mean expression",
              avgVal,
              icon = icon("minus"),
              fill = TRUE
      )
    } else{
      infoBox("mean expression")
    }
  } else {
    infoBox("mean expression")
  }
})

output$maxExpr <- renderInfoBox({
  filteredData = filterData()
  
  # switching between volcano and plot causes a bit of mixing b/w filterData and the plotting
  # filtering happens quicker than plotting, so it gets confused and gives a temp warning/error
  if(!is.null(filteredData)) {
    if(! 'FC' %in% colnames(filteredData)){
      maxVal = filteredData %>% 
        summarise(max = max(expr))
      
      # Find maximum value and which tissues have that value.
      maxVal = maxVal[[1]]
      
      iMax = which(filteredData$expr == maxVal)
      
      if (length(iMax) > 2) {
        maxGenes = paste0("in ", length(iMax),
                          " different genes")
      } else {
        maxTrans = filteredData[[data_unique_id]][iMax]
        maxTissue = filteredData$tissue[iMax]
        maxGenes = paste0(maxTrans, " (", maxTissue, ")")
      }
      
      infoBox("maximum expression",
              maxVal,
              maxGenes,
              icon = icon("chevron-up"),
              fill = TRUE
      )
    } else{
      infoBox("maximum expression")
    }
  } else{
    infoBox("maximum expression")
  }
})
