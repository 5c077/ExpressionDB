calcPCA <- reactive({
  filteredData = filterData() %>% 
    select_(data_unique_id, 'url', 'tissue', 'expr') %>% 
    spread(tissue, expr)
  
  geneNames = filteredData %>% 
    select(gene = url)
  
  pca_data  = filteredData %>% 
    ungroup() %>% 
    select_(paste0('-', data_unique_id), '-url')
  
  PCA = prcomp(pca_data, scale = TRUE, center = TRUE)
  
  
  # round digits
  PCA$x = bind_cols(geneNames, data.frame(PCA$x %>% round(., num_digits)))
  
  PCA$rotation = PCA$rotation %>% round(., num_digits)
  
  return(PCA)
})
