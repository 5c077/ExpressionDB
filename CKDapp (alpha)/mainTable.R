
# Table to display all the results ----------------------------------------


output$table <- renderDataTable({
  
  filtered = filterData()
  
  # Remove cols not needed in the table.
  filtered = filtered %>% 
    select(transcript = transcriptLink, gene = geneLink, tissue, expr, q)
  
  
  # Leftover from SQL implementation. 
  # filtered = collect(filtered) 
  
  # Provided there are rows in the data.table, convert to wide.
  if(nrow(filtered) > 0){
    data.table::dcast(filtered, 
                      transcript + gene + q ~ tissue, 
                      value.var = 'expr')
  }
},  
escape = c(-1,-2, -3),
selection = 'none', #! Temporarily turning off row selection.
options = list(searching = FALSE, stateSave = TRUE,
               pageLength = 25,
               rowCallback = JS(
                 'function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
        if (aData[0])
          $("td:eq(0)", nRow).css("color", "#293C97");
          $("td", nRow).css("text-align", "center");
      }')
)    
)