output$downloadTable <- downloadHandler(
  filename = function() {
    paste('data-', Sys.Date(), '.csv', sep='')
  },
  content = function(file) {
    filteredData = filterData()
    
    filteredData = filteredData %>% 
      select(gene, transcript, tissue, 
             expr, q) %>% 
      spread(tissue, expr) 
    
    write.csv(filteredData, file)
  }
)