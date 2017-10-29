
# Table to display all the results ----------------------------------------


output$table <- renderDataTable({
  withProgress(message = 'Generating table', value = 0, {
    filtered = filterData()
    
    incProgress(amount = 0.5)
    # switching between volcano and plot causes a bit of mixing b/w filterData and the plotting
    # filtering happens quicker than plotting, so it gets confused and gives a temp warning/error
    if(!is.null(filtered)) {
      if(! 'FC' %in% colnames(filtered)){
        # Remove cols not needed in the table.
        filtered = filtered %>% 
          select_('url', go_gene_descrip, 'tissue', 'expr', 'q') %>% 
          rename(gene = url) %>% 
          rename_(.dots = setNames(go_gene_descrip, 'description'))
        
        # Provided there are rows in the data.table, convert to wide.
        if(nrow(filtered) > 0) {
          data.table::dcast(filtered, 
                            ... ~ tissue, 
                            value.var = 'expr')
        }
      }
    }
  })
},  
escape = c(-1,-2),
selection = 'none', #! No row selection.
options = list(searching = FALSE, stateSave = TRUE,
               pageLength = 25,
               rowCallback = JS(
                 'function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
        if (aData[0])
          $("td:eq(0)", nRow).css("color", "#293C97");
          $("td", nRow).css("text-align", "left");
      }')
)    
)


