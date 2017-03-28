# filterData is a reactive function that takes no arguments, so it'll autoupdate when
# the inputs change.
filterData <- reactive({
  
  
  # Selectize GO input ------------------------------------------------------
  populateSelectize()
  
  
  # Gene and muscle filtering -----------------------------------------------
  
  # Per1, Per2, Per3, ....
  # Note: to change to exact matching, include '$' at the end of the string.
  # geneInput = paste0(input$geneInput, '%') # For SQL-based filtering
  geneInput = paste0('^', input$geneInput)
  
  if(is.null(input$GO)){
    ont = ""
  } else {
    ont = input$GO
  }
  
  # For fold change, adding in the FC-selected muscle if it's not already in the list
  if(input$tabs == 'volcano') {# volcano plot     
    # Select 2 muscles from the user input.
    selMuscles = unique(c(input$muscle1, input$muscle2))
  } else if(input$adv == TRUE & input$ref != 'none') {
    selMuscles = unique(c(input$ref, input$muscles))
  } else { 
    selMuscles = input$muscles
  }
  
  # Generate key for muscles
  muscleSymbols = plyr::mapvalues(selMuscles,
                                  from = c('atria', 'left ventricle',
                                           'total aorta', 'right ventricle',
                                           'soleus', 
                                           'diaphragm',
                                           'eye', 'EDL', 'FDB',
                                           'thoracic aorta', 'abdominal aorta',
                                           'tongue', 'masseter',
                                           'plantaris'),
                                  to = c('ATR', 'LV',
                                         'AOR', 'RV',
                                         'SOL', 'DIA',
                                         'EYE', 'EDL', 'FDB',
                                         'TA', 'AA', 
                                         'TON', 'MAS',
                                         'PLA'),
                                  warn_missing = FALSE)
  
  
  qCol = paste0(paste0(sort(muscleSymbols), collapse = '.'), '_q')
  
  # SELECT DATA.
  # Note: right now, if there's something in both the "gene" and "ont"
  # input boxes, they must BOTH be true (AND relationship).
  # For example, if you have gene = "Myod1" and ont = "kinase",
  # you'll find only genes w/ both the name Myod1 and kinase as an ontology (which doesn't exist).
  # To switch this to an OR relationship, combine the geneInput and ont with an '|'.
  
  # Check if q-value filtering is turned on
  if(input$adv == FALSE & qCol %in% colnames(data)) {
    filtered = data %>% 
      select_("-dplyr::contains('_q')", q = qCol) %>% 
      filter(tissue %in% selMuscles,   # muscles
             grepl(eval(geneInput), shortName, ignore.case = TRUE),
             GO %like% ont)
    
  }  else if (input$adv == FALSE) {
    filtered = data %>% 
      select_("-dplyr::contains('_q')") %>% 
      filter(tissue %in% selMuscles,   # muscles
             grepl(eval(geneInput), shortName, ignore.case = TRUE),  # gene symbol
             GO %like% ont) %>%     # gene ontology
      mutate(q = NA)
  } else if(qCol %in% colnames(data)){
    # Check if the q values exist in the db.
    filtered = data %>% 
      select_("-dplyr::contains('_q')", q = qCol) %>% 
      filter(tissue %in% selMuscles,   # muscles
             grepl(eval(geneInput), shortName, ignore.case = TRUE),  # gene symbol
             GO %like% ont,               # gene ontology
             q < input$qVal)
  } else {
    filtered = data %>% 
      select(-dplyr::contains('_q')) %>% 
      filter(tissue %in% selMuscles,   # muscles
             grepl(eval(geneInput), shortName, ignore.case = TRUE),  # gene symbol
             GO %like% ont                # gene ontology                 
      ) %>% 
      mutate(q = NA)
  }
  
  
  
  # filter(filtered, row_number(transcript) == 1L)
  
  
  # Filter on expression & fold change  ---------------------------------------------
  
  if(input$adv == TRUE | input$tabs == 'volcano'){
    
    # -- Case 1: Volcano plot. --
    # -- Special cleanup for volcano plot --
    if(input$tabs == 'volcano') {
      # Two selected muscles for comparison filtered above.
      
      # Filter on expression: find tissues with any values within the range.
      filteredTranscripts = filtered %>%
        filter(expr <= input$maxExprVal,
               expr >= input$minExprVal) %>% 
        select(transcript)
      
      filtered = filtered %>% 
        filter(transcript %in% filteredTranscripts$transcript) %>%  # FIlter
        select(transcript = transcriptLink, gene = geneLink, 
               tissue, expr, q, transcriptName = transcript, geneSymbol = gene) %>% 
        mutate(expr = ifelse(expr == 0, 0.0001, expr) # Correction so don't divide by 0. 
        ) 
      
      
      # Check that there's something to reshape.
      if(nrow(filtered) != 0 & input$muscle1 != input$muscle2){
        
        
        filtered = filtered %>% 
          spread(tissue, expr) %>% 
          mutate_(.dots = setNames(paste0('`', input$muscle1,'` / `', input$muscle2,'`'), 'FC')) %>% 
          mutate(logFC = log10(FC),
                 logQ = -log10(q))
                 # id = dense_rank(transcript))
        
      } else {
        filtered = data.table(id = 0, name = 'no data', FC = 0, logFC = 0, logQ = 0, geneSymbol = NA, transcriptName = NA)
      }
      
    } else if(input$ref != 'none') {
      
      # -- Case 2: expr + FC filtering ---------------------------------------------
      # If advanced filtering is checked, always filter on expression.
      # Only use this case if a reference tissue is checked.
      
      # -- Filter on expr change --
      # Check to make sure that expression filtering is on.  Otherwise, don't filter.
      filteredTranscripts = filtered %>%
        filter(expr <= input$maxExprVal,
               expr >= input$minExprVal) %>% 
        select(transcript)
      
      
      # -- Filter on fold change --
      # Running last since it's kind of annoying. 
      # Assuming that whatever is the ref should be added no matter what...
      numMuscles = length(selMuscles)
      
      # Pull out the expression values for the selected muscles
      relExpr = filtered %>% 
        filter(tissue == input$ref) %>% 
        select(transcript, relExpr = expr)
      
      # Figuring out which transcripts meet the fold change conditions.
      filteredFC = left_join(filtered, relExpr,         # Safer way: doing a many-to-one merge in:
                             by = c('transcript')) %>% 
        mutate(`fold change`= expr/relExpr) %>%         # calc fold change
        filter(`fold change` >= input$foldChange)       # filter FC
      
      # Select the transcripts where at least one tissue meets the conditions.
      filtered = filtered %>% 
        filter(transcript %in% filteredTranscripts$transcript &
                 transcript %in% filteredFC$transcript
        )
    } else {
      # -- Case 3: just filter on expression. --
      filteredTranscripts = filtered %>%
        filter(expr <= input$maxExprVal,
               expr >= input$minExprVal) %>% 
        select(transcript)
      
      
      # Select the transcripts where at least one tissue meets the conditions.
      filtered = filtered %>% 
        filter(transcript %in% filteredTranscripts$transcript)
      
    }
  }
  
  
  return(filtered)
})





