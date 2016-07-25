# volcano table -----------------------------------------------------------

output$volcanoTable <- renderDataTable({
  filtered = filterData()
  brushedPoints(filtered, input$volcanoBrush)
},  
escape = c(-1,-2, -3),
options = list(searching = TRUE, stateSave = TRUE,
               pageLength = 25,
               rowCallback = JS(
                 'function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
        if (aData[0])
          $("td:eq(0)", nRow).css("color", "#293C97");
          $("td", nRow).css("text-align", "center");
      }')
)
)


# volcano tooltip ---------------------------------------------------------





# ggvis volcano output ----------------------------------------------------

output$volcanoPlot <- renderPlot({
  filteredData = filterData()
  
# Temporary plot to be replaced by interactive version.  
  ggplot(filteredData, aes(y = logQ, x = logFC)) +
    geom_point(size = 3, alpha  = 0.3, colour = 'dodgerblue') +
    coord_cartesian(xlim = ranges$x, ylim = ranges$y) +
    theme(title = element_text(size = 32, color = grey90K),
          axis.line = element_blank(),
          axis.ticks = element_blank(),
          axis.text = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
          axis.title = element_text(size = 18, color = grey60K, family = 'Segoe UI Light'), 
          legend.position="none",
          panel.background = element_blank(),
          panel.grid.major = element_line(color = grey60K, size = 0.2),
          panel.border = element_blank(),
          plot.margin = rep(unit(0, units = 'points'),4),
          panel.background = element_blank(), 
          strip.text = element_text(size=13, face = 'bold', color = grey60K, family = 'Segoe UI Semilight'),
          strip.background = element_blank()
    )
})
