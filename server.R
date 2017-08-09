shinyServer(
  function(input, output, session) {
    
    
    # SELECTIZE ---------------------------------------------------------------
    
    populateSelectize <- reactive({
      updateSelectizeInput(session, 'GO', choices = GOs, 
                           options = list(placeholder = "search ontology"), 
                           server = TRUE)
    })
    
    populateSelectize2 <- reactive({
      updateSelectizeInput(session, 'descrip', choices = gene_names, 
                           options = list(placeholder = "search gene name"), 
                           server = TRUE)
    })
    
    
    
    # FILTER ------------------------------------------------------------------
    
    # FILTER: Based on the inputs given by the users, filter down the large db into 
    # a table with only the selected values.  MAIN function to select data.
    source("filterExpr.R", local = TRUE)
    
    # TABLE ------------------------------------------------------------------
    
    # TABLE outputs: main table with all the data, and summary table 
    # with the summary statistics for the filtered data.
    source("summaryTable.R", local = TRUE)
    source("mainTable.R", local = TRUE)
    
    # SUMMARY WIDGETS at the top of the table page w/ some summary stats.
    source("summaryStats.R", local = TRUE)
    
    # DOWNLOAD data buttons.
    source("downloadFncns.R", local = TRUE)
    
    # PLOT output
    source("plot.R", local = TRUE)
    
    # COMPARISON output
    source("comparison.R", local = TRUE)
    
    # PCA ---------------------------------------------------------------------
    
    # PCA output
    source("calcPCA.R", local = TRUE)
    source("PCA.R", local = TRUE)
    
    # HEATMAP -----------------------------------------------------------------
    source("heatmap.R", local = TRUE) 
    
    
    # VOLCANO PLOT ------------------------------------------------------------
    
    source("volcano.R", local = TRUE)
    
    
  })

