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

    ggsave(file, width = 10, height = 10)
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

output$downloadPNG_v = downloadHandler(
  filename = function() {
    paste('volcano_', Sys.Date(), '.png', sep='')
  },
  content = function(file) {
    
    ggsave(file)
  }
)

output$downloadPDF_v = downloadHandler(
  filename = function() {
    paste('volcano_', Sys.Date(), '.pdf', sep='')
  },
  content = function(file) {
    
    ggsave(file)
  }
)

output$downloadPNG_c = downloadHandler(
  filename = function() {
    paste('comparison_', Sys.Date(), '.png', sep='')
  },
  content = function(file) {
    
    ggsave(file)
  }
)

output$downloadPDF_c = downloadHandler(
  filename = function() {
    paste('comparison_', Sys.Date(), '.pdf', sep='')
  },
  content = function(file) {
    
    ggsave(file)
  }
)

output$downloadPNG_p = downloadHandler(
  filename = function() {
    paste('pca_', Sys.Date(), '.png', sep='')
  },
  content = function(file) {
    
    ggsave(file)
  }
)

output$downloadPDF_p = downloadHandler(
  filename = function() {
    paste('pca_', Sys.Date(), '.pdf', sep='')
  },
  content = function(file) {
    
    ggsave(file)
  }
)




