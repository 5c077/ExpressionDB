
# filterData is a reactive function that takes no arguments, so it'll autoupdate when
# the inputs change.
filterData <- reactive({
  withProgress(message = 'Filtering data...', value = 0, {
    
    # Selectize GO input ------------------------------------------------------
    populateSelectize()
    populateSelectize2()
    
    incProgress(amount = 0.05)
    
    # Gene and muscle filtering -----------------------------------------------
    
    # Per1, Per2, Per3, ....
    # Note: to change to exact matching, include '$' at the end of the string.
    # geneInput = paste0(input$geneInput, '%') # For SQL-based filtering
    # geneInput = paste0('^', input$geneInput) # If you want to change so the search string starts with
    
    first_char = str_sub(input$geneInput, 1, 1)
    last_char = str_sub(input$geneInput, -1, -1)
    
    incProgress(amount = 0.05)
    
    if(str_detect(input$geneInput,  '“?\\"') | str_detect(input$geneInput,  '"?\\"')){
      # If exact matching is turned on, there are 3 potential search matches: 
      # What we want to match will be a string will either like
      # (A) "merge_id (unique_id)", e.g. "Clfar (uc007bcn)"
      # or (B) "unique_id", e.g. "uc007fix"
      # User inputs need to be converted into regex exact matching.
      # The user will input one of 3 things:
      # [1] "merge_id" which will be converted into "^merge_id (" to exact match [Situation A]
      #     (note: "(" has to be escaped; see below)
      # [2] "unique_id" --> "(unique_id)$" [Situation A]
      # [3] "unique_id" --> "^unique_id$" [Situation B]
      
      # replace by regex exact matching
      # [1] "merge_id" --> "^merge_id ("
      geneInput1 = str_replace(input$geneInput, first_char, '\\^')
      # Multiple escape characters needed; in the end need "\\(" to escape the "("
      # To get there, each \\ --> \
      geneInput1 = str_replace(geneInput1, last_char, ' \\\\\\\\\\(')
      
      # [2] "unique_id" --> "(unique_id)$"
      geneInput2 = str_replace(input$geneInput, first_char, '\\\\\\\\\\(')
      # Multiple escape characters needed; in the end need "\\(" to escape the "("
      # To get there, each \\ --> \
      geneInput2 = str_replace(geneInput2, last_char, '\\\\\\\\\\)$')
      
      # [3] "unique_id" --> "^unique_id$" [Situation B]
      geneInput3 = str_replace(str_replace(input$geneInput, first_char, '\\^'), last_char, '$')
      
    } else {
      geneInput1 = input$geneInput
      geneInput2 = NA
      geneInput3 = NA
    }
    
    incProgress(amount = 0.05)
    
    if(is.null(input$GO)){
      ont = ""
    } else {
      ont = input$GO
    }
    
    incProgress(amount = 0.05)
    
    # For fold change, adding in the FC-selected muscle if it's not already in the list
    if(input$tabs == 'volcano') {# volcano plot     
      # Select 2 muscles from the user input.
      selMuscles = unique(c(input$muscle1, input$muscle2))
    } else if(input$adv == TRUE & input$ref != 'none') {
      selMuscles = unique(c(input$ref, input$muscles))
    } else { 
      selMuscles = input$muscles
    }
    
    
    qCol = paste0(paste0(sort(selMuscles), collapse = '.'), '_q')
    
    incProgress(amount = 0.05)
    
    
    # SELECT DATA.
    # Note: right now, if there's something in both the "gene" and "ont"
    # input boxes, they must BOTH be true (AND relationship).
    # For example, if you have gene = "Myod1" and ont = "kinase",
    # you'll find only genes w/ both the name Myod1 and kinase as an ontology (which doesn't exist).
    # To switch this to an OR relationship, combine the geneInput and ont with an '|'.
    
    basic_filter = function(df, qCol, selMuscles, data_unique_id, geneInput1, geneInput2, geneInput3, ont_var, ont) {
      selNames = input$descrip
      
      # Check if q-column exists.  If not, set Q  = NA
      if(qCol %in% colnames(df)){
        filt = df %>% 
          select_("-dplyr::contains('_q')", q = qCol)
      } else {
        filt = df %>% 
          select_("-dplyr::contains('_q')") %>% 
          mutate(q = NA)
      }
      
      if(!is.na(geneInput2)){
        # exact matching of input$gene
      filt =  filt %>% 
        filter(tissue %in% selMuscles) %>%    # muscles
        filter_(paste0("str_detect(str_to_lower(", data_unique_id, "), str_to_lower('", geneInput1, "')) |",
                       "str_detect(str_to_lower(", data_unique_id, "), str_to_lower('", geneInput2, "')) |",
                       "str_detect(str_to_lower(", data_unique_id, "), str_to_lower('", geneInput3, "'))")) %>%  # gene
        filter_(paste0("str_detect(", ont_var, ", '", ont, "')")) # gene ontology
      } else {
        # inexact matching of input$gene
        filt =  filt %>% 
          filter(tissue %in% selMuscles) %>%    # muscles
          filter_(paste0("str_detect(str_to_lower(", data_unique_id, "), str_to_lower('", geneInput1, "'))")) %>%  # gene
          filter_(paste0("str_detect(", ont_var, ", '", ont, "')")) # gene ontology
      }
      
      if(!is.null(selNames)) {
        filt = filt %>% 
          filter_(paste0(go_gene_descrip,' %in% input$descrip'))   # gene names
      }
      
      
      return(filt)
    }
    
    
    
    filter_gene = function(df, filteredDF) {
      
      nTranscripts = df %>% distinct_(data_unique_id) %>% count()
      
      
      # Check if need to filter at all
      if(length(filteredDF) != nTranscripts) {
        
        # Pulling out the base R....
        df = df[df$transcript %in% filteredDF,]
      }
      
      
      return(df)
    }
    
    
    filter_expr = function(filtered) {
      filtered %>%
        filter(expr <= input$maxExprVal,
               expr >= input$minExprVal) %>% 
        pull(data_unique_id) %>% 
        unique()
    }
    
    
    # Check if q-value filtering is turned on
    if(input$adv == FALSE & qCol %in% colnames(data)) {
      filtered = data %>% 
        basic_filter(qCol, selMuscles, data_unique_id, geneInput1, geneInput2, geneInput3, ont_var, ont)
      
      incProgress(amount = 0.25)
      
    }  else if (input$adv == FALSE) {
      filtered = data %>% 
        basic_filter(qCol, selMuscles, data_unique_id, geneInput1, geneInput2, geneInput3, ont_var, ont) %>%     
        mutate(q = NA)
      
      incProgress(amount = 0.25)
      
    } else if(qCol %in% colnames(data)){
      # Check if the q values exist in the db.
      filtered = data %>% 
        basic_filter(qCol, selMuscles, data_unique_id, geneInput1, geneInput2, geneInput3, ont_var, ont) %>% 
        filter(q < input$qVal)
      

      incProgress(amount = 0.5)
      
    } else {
      filtered = data %>% 
        basic_filter(qCol, selMuscles, data_unique_id, geneInput1, geneInput2, geneInput3, ont_var, ont) %>% 
        mutate(q = NA)
      
      incProgress(amount = 0.5)
    }
    
    
    
    # Filter on expression & fold change  ---------------------------------------------
    
    if(input$adv == TRUE | input$tabs == 'volcano'){
      
      # -- Case 1: Volcano plot. --
      # -- Special cleanup for volcano plot --
      if(input$tabs == 'volcano') {
        # Two selected muscles for comparison filtered above.
        
        # Filter on expression: find tissues with any values within the range.
        # Necessary to do a 2 stage filter to capture any transcripts with values within range for ANY tissue (not all)
        filteredTranscripts = filter_expr(filtered)
        
        filtered = filtered %>% 
          filter_gene(filteredTranscripts) %>%  # Filter
          select(gene = url, tissue, expr, q)%>%
          mutate(expr = ifelse(expr == 0, min_expr, expr) # Correction so don't divide by 0. 
          ) 
        
        
        # Check that there's something to reshape.
        if(!is.null(input$muscle1)){
          if(nrow(filtered) != 0 & input$muscle1 != input$muscle2){
            
            
            filtered = filtered %>% 
              spread(tissue, expr) %>% 
              mutate_(.dots = setNames(paste0('`', input$muscle1,'` / `', input$muscle2,'`'), 'FC')) %>% 
              mutate(logFC = log10(FC),
                     logQ = -log10(q))
            
          } else {
            filtered = NULL
          }
        } else{
          filtered = NULL
        }
        
      } else if(input$ref != 'none') {
        # -- Case 2: expr + FC filtering ---------------------------------------------
        # If advanced filtering is checked, always filter on expression.
        # Only use this case if a reference tissue is checked.
        
        # -- Filter on expr change --
        # Check to make sure that expression filtering is on.  Otherwise, don't filter.
        filteredTranscripts = filter_expr(filtered)
        
        # -- Filter on fold change --
        # Running last since it's kind of annoying. 
        # Assuming that whatever is the ref should be added no matter what...
        numMuscles = length(selMuscles)
        
        # Pull out the expression values for the selected muscles
        relExpr = filtered %>% 
          filter(tissue == input$ref) %>% 
          select_(data_unique_id, relExpr = 'expr')
        
        # Figuring out which transcripts meet the fold change conditions.
        filteredFC = left_join(filtered, relExpr,         # Safer way: doing a many-to-one merge in:
                               by = setNames(data_unique_id, data_unique_id)) %>% 
          mutate(`fold change`= expr/relExpr) %>%         # calc fold change
          filter(`fold change` >= input$foldChange) %>%       # filter FC
          pull(data_unique_id) %>% 
          unique()
        
        # Select the transcripts where at least one tissue meets the conditions.
        filtered = filtered %>% 
          filter_gene(filteredTranscripts) %>% 
          filter_gene(filteredFC)
        
      } else {
        # -- Case 3: just filter on expression. --
        filteredTranscripts = filter_expr(filtered)
        
        # Select the transcripts where at least one tissue meets the conditions.
        filtered = filtered %>%
          filter_gene(filteredTranscripts)

      }
    }
    
  
    return(filtered)

  })
})
