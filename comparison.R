# Gene selection box --------------------------------------------------
output$g1 = renderUI({
  
  # Pull out the names of the filtered genes.
  selGenes = filterData()
  
  
  # switching between volcano and plot causes a bit of mixing b/w filterData and the plotting
  # filtering happens quicker than plotting, so it gets confused and gives a temp warning/error
  if(!is.null(selGenes)) {
    if(! 'FC' %in% colnames(selGenes)){
      
      selGenes = selGenes %>% distinct_(data_unique_id) %>% pull()
      
      selectizeInput('compRef', label = 'ref. transcript',
                     choices = selGenes,
                     width = '200px')
    }
  }
})



# Comparison plot  ------------------------------------------------------

output$compPlot = renderPlot({
  
  withProgress(message = 'Making plot', value = 0, {

    
    
    # filter data
    filteredData = filterData()
    
    incProgress(0.21)
    
    
    # Pull out the current Page Number
    pageNum = getCompPage()
    
    
    numTissues = length(unique(filteredData$tissue))
    
    
    iBeg = (pageNum)*nPlots*numTissues + 1
    iEnd = (pageNum + 1)*nPlots*numTissues
    
    # switching between volcano and plot causes a bit of mixing b/w filterData and the plotting
    # filtering happens quicker than plotting, so it gets confused and gives a temp warning/error
    if(!is.null(filteredData)) {
      if(! 'FC' %in% colnames(filteredData) & !is.null(input$compRef)){
        
        # pull out the data for the reference gene
        refGene = input$compRef
        
        refExpr = filteredData %>% 
          filter_(paste0(data_unique_id, ' == refGene')) %>% 
          rename(refExpr = expr) %>% 
          ungroup() %>% 
          select(tissue, refExpr)
        
        # Combine the reference data with the normal data.
        # Remove the reference tissue.
        # Calculate the fold change
        filteredData = left_join(filteredData, refExpr, by = 'tissue') %>% 
          filter_(paste0(data_unique_id, '!= input$compRef')) %>% 
          mutate(FC = expr / refExpr,
                 logFC = log10(FC),
                 logFC = ifelse(is.infinite(logFC), NA, logFC)) # correct for infinite values
        
        
        if(input$sortBy != 'alpha') {
          # Calculate correlation coefficient ---------------------------------------
          # Only needed if sorting by most/least similar
          incProgress(0.17)
          # Splay outward
          pairwise = filteredData %>% 
            select_(data_unique_id, 'tissue', 'expr', 'refExpr') %>% 
            spread_(data_unique_id, 'expr') %>%
            select(-tissue)
          
          
          incProgress(0.15)
          # Calculate correlation
          correl = cor(pairwise)
          
          correl = data.frame(correl) %>%
            select(corr = refExpr)
          
          
          incProgress(0.5)
          
          correl = correl %>%
            mutate(corr_name = row.names(correl))
          
          # Merge in with the master
          filteredData = left_join(filteredData, correl, by = setNames('corr_name', data_unique_id))
        } else {
          incProgress(0.6)
        }
        
        # Calculate limits for the plot
        yMax = max(abs(filteredData$logFC), na.rm = TRUE)
        
        
        # Refactorize -------------------------------------------------------------
        
        if (input$sortBy == 'most') {
          filteredData = filteredData %>% 
            arrange(desc(corr)) # Sort by correlation coefficient, in descending order
          
          orderNames = unique(filteredData[[data_unique_id]])
          
        } else if (input$sortBy == 'least') {
          filteredData = filteredData %>% 
            arrange(corr) # Sort by correlation coefficient, in ascending order
          
          orderNames = unique(filteredData[[data_unique_id]])
        } else {
          orderNames = sort(unique(filteredData[[data_unique_id]]))
          
          filteredData = filteredData %>% 
            arrange_(data_unique_id)
        }
        
        filteredData[[data_unique_id]] = factor(filteredData[[data_unique_id]], orderNames)
        
        
        # Select just the transcripts that fit within the current page.
        
        filteredData = filteredData %>% 
          slice(iBeg:iEnd)
        
        
        # Plot --------------------------------------------------------------------
        
        
        textSize = ifelse(numTissues <= 8, 16, 20 - numTissues/2)
        
        ggplot(filteredData,
               aes(x = logFC, xend = 0, y = tissue, yend = tissue,
                   fill = logFC)) +
          geom_segment(colour = grey90K, size = 0.25) +
          geom_vline(xintercept = 0, colour = grey90K, size = 0.25) +
          geom_point(size = 4, colour = grey60K,
                     shape = 21) +
          scale_fill_gradientn(colours = comparison_palette,
                               limits = c(-yMax, yMax)) +
          theme_xOnly(textSize) +
          theme(rect = element_rect(colour = grey90K, size = 0.25, fill = NA),
                panel.border = element_rect(colour = grey90K, size = 0.25, fill = NA)) +
          facet_wrap(as.formula(paste0('~', data_unique_id))) +
          xlab('log(fold change)')
      }
    }
  })
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
