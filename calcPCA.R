calcPCA <- reactive({
  filteredData = filterData() %>% 
    select_(data_unique_id, 'tissue', 'expr') %>% 
    spread(tissue, expr)
  
  geneNames = filteredData %>% 
    select_(data_unique_id)
  
  pca_data  = filteredData %>% 
    ungroup() %>% 
    select_(paste0('-', data_unique_id))
  
  PCA = prcomp(pca_data, scale = TRUE, center = TRUE)
  
  PCA$x = bind_cols(geneNames, data.frame(PCA$x))
  
  return(PCA)
})
