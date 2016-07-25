theme_xOnly<- function() {
  theme(title = element_text(size = 32, color = grey90K),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.text.y = element_text(vjust = 0.1),
        axis.title = element_blank(), 
        legend.position="none",
        panel.border = element_rect(colour = grey90K, size = 0.25, fill = NA),
        panel.background = element_blank(),
        panel.grid.major = element_line(color = grey60K, size = 0.2),
        panel.grid.major.y = element_blank(),
        panel.margin = rep(unit(15, units = 'points'),4),
        panel.background = element_blank(), 
        strip.text = element_text(size=13, face = 'bold', color = grey60K, family = 'Segoe UI Semilight'),
        strip.background = element_blank()
  )
}

grey90K = '#414042'
grey60K = '#808285'
nPlots = 25

getPage <- reactive({
  page = (input$nextPage - input$prevPage)
  
  if (page < 0) {
    page = 0
  } else {
    page = page
  }
})

output$plot1 <- renderPlot({
  
  pageNum = getPage()
  
  
  iBeg = (pageNum)*nPlots + 1
  iEnd = (pageNum + 1)*nPlots
  
  
  filteredData = filterData()
  
  # transcriptList = unique(filteredData$transcript)[1:nPlots]
  transcriptList = unique(filteredData$transcript)[iBeg:iEnd]
  
  data2Plot = filteredData %>% 
    filter(transcript %in% transcriptList) %>% 
    mutate(transFacet = paste0(gene, '(', transcript, ')')) # Merge names for more informative output.
  
  
  if(nrow(data2Plot) == 0) {
    # no data
    ggplot(data2Plot, aes(y= expr, x=tissue)) +
      geom_blank() +
      theme_void()
    
  } else {
    maxExpr = max(data2Plot$expr)
    
    yLim = c(-0.1*maxExpr, maxExpr)
    
    ggplot(data2Plot, aes(y= expr, x=tissue, label = round(expr, 1))) +
      coord_flip(ylim = yLim) +
      geom_bar(stat = "identity", fill = 'dodgerblue') +
      geom_text(aes(x = tissue, y = 0), hjust = 1.1,
                family = 'Segoe UI Light', 
                colour = 'blue') +
      facet_wrap(~transFacet) +
      theme_xOnly()
  }
  
})