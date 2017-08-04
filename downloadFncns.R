output$downloadTable <- downloadHandler(
  filename = function() {
    paste('data-', Sys.Date(), '.csv', sep='')
  },
  content = function(file) {
    filteredData = filterData()
    
    filteredData = filteredData %>% 
      select_(paste0('-', ont_var)) %>% 
      spread(tissue, expr) 
    
    write.csv(filteredData, file)
  }
)