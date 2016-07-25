# Widget showing the minimum, mean, and maximum expression value.
# output$minExpr <- renderInfoBox({
#   filteredData = filterData()
#   
#   print(dim())
#   
#   minVal = filteredData %>% 
#     summarise(min = min(expr))
#   
#   # Find minimum value and which tissues have that value.
#   minVal= minVal[[1]]
#   
#   iMin = which(filteredData$expr == minVal)
#   
#   
#   if (length(iMin) > 2) {
#     minGenes = paste0("in ", length(iMin),
#                       " different tissues")
#   } else {
#     minTrans = filteredData$shortName[iMax]
#     minTissue = filteredData$tissue[iMax]
#     minGenes = paste0(minTrans, " (", minTissue, ")")
#   }
#   
#   infoBox("minimum expression",
#           minVal,
#           minGenes,
#           #               HTML(paste0(minVal, '<br>',"fdjks")),"rjek",
#           icon = icon("chevron-down"),
#           fill = TRUE
#   )
# })

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
  maxVal= maxVal[[1]]
  
  iMax = which(filteredData$expr == maxVal)
  
  if (length(iMax) > 2) {
    maxGenes = paste0("in ", length(iMax),
                      " different genes")
  } else {
    maxTrans = filteredData$shortName[iMax]
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
