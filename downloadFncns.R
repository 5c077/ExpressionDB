output$downloadTable = downloadHandler(
  filename = function() {
    paste('data_', Sys.Date(), '.csv', sep='')
  },
  content = function(file) {
    filteredData = filterData()

    filteredData = filteredData %>%
      select_(paste0('-', ont_var)) %>%
      spread(tissue, expr)

    write.csv(filteredData, file)
  }
)

output$downloadPNG = downloadHandler(
  filename = function() {
    paste('dotplot_', Sys.Date(), '.png', sep='')
  },
  content = function(file) {

    ggsave(file)
  }
)

output$downloadPDF = downloadHandler(
  filename = function() {
    paste('dotplot_', Sys.Date(), '.pdf', sep='')
  },
  content = function(file) {
    
    ggsave(file)
  }
)

