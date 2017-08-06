output$avgExpr <- renderInfoBox({
  filteredData = filterData()
  
  avgVal = filteredData %>% 
    summarise(round(mean(expr),2))
  
  infoBox("mean expression",
          avgVal,
          icon = icon("minus"),
          fill = TRUE
  )
})

output$maxExpr <- renderInfoBox({
  filteredData = filterData()
  
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
})
