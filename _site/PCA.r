output$pcaPlot = renderPlot({
  
  library(RColorBrewer)

  x = calcPCA()
  
  PCA = data.frame(x$x, ID = 1:nrow(x$x))
  
  ggplot(PCA, aes(x = PC1, y = PC2)) + 
    theme_bw() +
    geom_point(size = 3, alpha = 0.3, color = brewer.pal(9, "PuRd")[7])
  
  # PCA %>% ggvis(x = ~PC1, y = ~PC2, key := ~ID) %>% 
  #   layer_points(size := 25, size.hover := 100, fill.hover := "royalblue",
  #                stroke := "#BD202E",  stroke.hover := "navy", strokeWidth.hover := 0.75, 
  #                fill := "#BD202E",  opacity := 0.5) %>% 
  #   add_tooltip(PCATooltip, "hover")
  
  
#   PCATooltip <- function(x) {
#     if(is.null(x)) return(NULL)
#     
#     x$ID
    #   all_data <- isolate(filterVolcano())
    #   geneName <- all_data[all_data$ID == x$ID, 1]
    #   transcriptName <- strtrim(all_data[all_data$ID == x$ID, 2],10)
    #   paste0("<b>", geneName, "</b><br>",
    #          transcriptName, "<br>",
    #          "fold change: ", format(10^x[1], digits = 3, nsmall = 1), "<br>",
    #          "p/q: ", format(10^-x[2], digits = 3, nsmall = 1))
  # }
  
  # plot(x$x)
  
  # cumsum((x$sdev)^2) / sum(x$sdev^2)
  
  # Brush to select.
})