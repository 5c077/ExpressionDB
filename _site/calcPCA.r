calcPCA <- reactive({
  filteredData = filterData() %>% 
    select(contains(expr))
  
  PCA = prcomp(filteredData, scale = TRUE, center = TRUE)
})