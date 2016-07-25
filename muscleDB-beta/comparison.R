# Gene selection box --------------------------------------------------
output$g1 = renderUI({
  
  # Pull out the names of the filtered genes.
  selGenes = filterData() %>% 
    mutate(fullName = paste0(gene, ' (', transcript, ')'))
  
  selGenes = unique(as.character(selGenes$fullName)) # shortName is factorized...
  
  selectizeInput('compRef', label = 'ref. transcript',
                 choices = selGenes,
                 width = '200px')
})



# Comparison plot  ------------------------------------------------------

output$compPlot = renderPlot({
  
  # Pull out the current Page Number
  pageNum = getCompPage()
  
  
  iBeg = (pageNum)*nPlots + 1
  iEnd = (pageNum + 1)*nPlots
  
        
  # filter data
  filteredData = filterData() %>% 
    mutate(fullName = paste0(gene, ' (', transcript, ')'))
  
  
  # pull out the data for the reference gene
  refGene = input$compRef
  
  refExpr = filteredData %>% 
    filter(fullName == refGene) %>% 
    mutate(refExpr = expr) %>% 
    select(tissue, refExpr)
  
  # Combine the reference data with the normal data.
  # Remove the reference tissue.
  # Calculate the fold change
  filteredData = left_join(filteredData, refExpr, by = 'tissue') %>% 
    filter(fullName != input$compRef) %>% 
    mutate(FC = expr / refExpr,
           logFC = log10(FC),
           logFC = ifelse(is.infinite(logFC), NA, logFC)) # correct for infinite values
  
  
  # Calculate correlation coefficient ---------------------------------------
  
  # Splay outward
  pairwise = spread(filteredData %>% select(tissue, transcript, expr, refExpr),
                    transcript, expr) %>%
    select(-tissue)

  # Calculate correlation
  correl = data.frame(cor(pairwise)) %>%
    select(corr = refExpr)

  correl = correl %>%
    mutate(transcript = row.names(correl))
  
  # Merge in with the master
  filteredData = left_join(filteredData, correl, by = "transcript")
  
  # Calculate limits for the plot
  yMax = max(abs(filteredData$logFC), na.rm = TRUE)
  
  
  # Refactorize -------------------------------------------------------------
  
  # Reverse tissue names
  filteredData$tissue = factor(filteredData$tissue, levels = rev(levels(filteredData$tissue)))
  
  if (input$sortBy == 'most') {
    orderNames = filteredData %>% 
      arrange(desc(corr)) # Sort by correlation coefficient, in descending order
    
    orderNames = orderNames$fullName
    
  } else if (input$sortBy == 'least') {
    orderNames = filteredData %>% 
      arrange(corr) # Sort by correlation coefficient, in ascending order
    
    orderNames = orderNames$fullName
  } else {
    orderNames = sort(filteredData$fullName)
  }
  
  
  filteredData$fullName = factor(filteredData$fullName, orderNames)
  
  
  # Select just the transcripts that fit within the current page.
  transcriptList = unique(filteredData$transcript)[iBeg:iEnd]
  
  filteredData = filteredData %>% 
    filter(transcript %in% transcriptList)
  
  
  # Plot --------------------------------------------------------------------
  
  ggplot(filteredData,
         aes(x = logFC, xend = 0, y = tissue, yend = tissue,
             fill = logFC)) +
    geom_segment(colour = grey40K, size = 0.25) +
    geom_vline(xintercept = 0, colour = grey90K, size = 0.25) +
    geom_point(size = 4, colour = grey70K,
               shape = 21) +
    scale_fill_gradientn(colours = brewer.pal(10, 'RdYlBu'),
                         limits = c(-yMax, yMax)) +
    theme_xgrid() +
    theme(rect = element_rect(colour = grey90K, size = 0.25, fill = NA),
          panel.border = element_rect(colour = grey90K, size = 0.25, fill = NA)) +
    facet_wrap(~fullName) +
    xlab('log(fold change)')
  
})



# Comparison pagination ---------------------------------------------------

getCompPage <- reactive({
  page = (input$nextComp - input$prevComp)
  
  if (page < 0) {
    page = 0
  } else {
    page = page
  }
})
