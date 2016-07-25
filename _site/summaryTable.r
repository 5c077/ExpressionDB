output$summaryTable <- renderDataTable({
  # Filter the data based on the params set by the user.
  filteredData = filterData()
  
  sumTable = filteredData %>% 
    group_by(tissue) %>% 
    summarise(mean = round(mean(expr),2),
              stdev = round(sd(expr), 2),
              median = median(expr),
              max = max(expr),
              min = min(expr))
  
  tableCols = sumTable$tissue
  
  sumTable = t(sumTable %>% select(-tissue))
  
  colnames(sumTable) = tableCols

  data.frame("tissue:" = rep("", 5),
             sumTable)
}, selection = 'none',
options = list(searching = FALSE, paging = FALSE, info = FALSE, ordering = FALSE,
               rowCallback = JS(
                 'function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
        if (aData[0])
          $("td:eq(0)", nRow).css("color", "#293C97");
          $("td", nRow).css("text-align", "center");
      }')
)    
)
