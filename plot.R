getPage <- reactive({
  page = (input$nextPage - input$prevPage)
  
  if (page < 0) {
    page = 0
  } else {
    page = page
  }
})

output$plot1 <- renderPlot({
  
  withProgress(message = 'Making plot', value = 0, {
    
    pageNum = getPage()
    
    
    iBeg = (pageNum)*nPlots + 1
    iEnd = (pageNum + 1)*nPlots
    
    
    filteredData = filterData()
    
    incProgress(amount = 0.5)
    
    # switching between volcano and plot causes a bit of mixing b/w filterData and the plotting
    # filtering happens quicker than plotting, so it gets confused and gives a temp warning/error
    if(!is.null(filteredData)) {
      if(! 'FC' %in% colnames(filteredData)){
        transcriptList = unique(filteredData[[data_unique_id]])[iBeg:iEnd]
        
        data2Plot = filteredData %>% 
          filter_(paste0(data_unique_id, '%in% transcriptList'))
        
        # specify connection between sample_names and sample_vars
        sample_labels = sample_names
        names(sample_labels) = sample_vars
        
        numTissues = length(unique(data2Plot$tissue))
        
        textSize = ifelse(numTissues <= 8, 16, 20 - numTissues/2)
        
        if(nrow(data2Plot) == 0) {
          # no data
          ggplot(data2Plot, aes(y= expr, x=tissue)) +
            geom_blank() +
            theme_void()
          
        } else {
          maxExpr = max(data2Plot$expr)
          
          yLim = c(-0.1*maxExpr, maxExpr)
          
          
          
          # dot plot
          ggplot(data2Plot, aes(y = expr, x = tissue, 
                                label = round(expr, 1))) +
            
            coord_flip(ylim = yLim) +
            
            
            # lollipops
            geom_segment(aes(x = tissue, 
                             xend = tissue,
                             y = 0, yend = expr), colour = grey90K,
                         size = 0.2) +
            # error bars
            geom_segment(aes(x = tissue,
                             xend = tissue,
                             y = expr - sem, yend = expr + sem),
                         size = 2.,
                         colour = grey60K, alpha = 0.3) +
            # points
            geom_point(fill = dot_color,
                       size = dot_size, colour = grey90K, 
                       stroke = 0.2, shape = 21) + 
            # label expression values
            geom_text(aes(x = tissue, y = 0), hjust = 1.1,
                      colour = grey60K) +
            
            
            ylab('expression (FPKM)') +
            
            scale_x_discrete(labels = sample_labels) +
            
            facet_wrap(as.formula(paste0('~', data_unique_id))) +
            theme_xOnly(textSize)
        }
      }
    }
  })
  
})
