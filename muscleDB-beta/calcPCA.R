calcPCA <- reactive({
  filteredData = filterData() %>% 
    select(transcript, gene, tissue, expr) %>% 
    spread(tissue, expr)
  
  geneNames = filteredData %>% 
    select(transcript, gene)
  
  filteredData  = filteredData %>% 
    select(-transcript, -gene)
  
  PCA = prcomp(filteredData, scale = TRUE, center = TRUE)
  
  PCA$x = cbind(geneNames, PCA$x)
  
  return(PCA)
})