
# prep_data.R ---------------------------------------------------------------
# prep_data is called by global.R once initially to set up the data for use within the Shiny app.
# # It does the following things:
# 1) imports a gene ontology look up table
# 2) creates links to Entrez Gene websites for every gene, if not already specified
# 3) imports gene expression data
# 4) calculates average and standard deviation for expression data for each sample type (e.g. Liver tissue)
# 5) calculates pairwise ANOVAs to detect significant differences between pairs of samples (e.g. Liver and Spleen)
# 6) calculates ANOVAs for all the samples
# 7) merges expression data with ontologies and ANOVAs
# 8) finds unique ontology terms that are within the dataset (for use in the app to search by ontology term)
# 9) rounds all values
# 10) saves everything into an RMD file for later use 

# -- checks performed --
# 1. check if column names have spaces; convert to periods (e.g. 'gene name' to 'gene.name')
# 2. check that column names exist within `go` and `df` data files.
# 3. check if entrez_var column exists. If not, create it.
# 4. check that the data_unique_id column contains unique values
# 5. check that the data_file contains only numeric values, aside from whatever is in `data_unique_id`
# 6. check that data_file contains the correct sample names
# 7. check that data_file and go_file have values that can merge together

prep_data = function(data_file, go_file, 
                     # variable names within data_file
                     sample_vars,
                     data_unique_id = 'gene',
                     data_merge_id = 'gene_id_data',
                     # variable names within go_file
                     go_merge_id = 'gene_id_go',
                     go_gene_descrip = 'gene_description',
                     ont_var = 'GO',
                     entrez_var = 'geneLink',
                     entrez_link = 'http://www.ncbi.nlm.nih.gov/gene/?term=',
                     export_dir = 'data/',
                     num_digits = 2) {
  # Check inputs ------------------------------------------------------------
  # Spaces aren't allowed in column names; during import they'll be converted to periods.
  data_unique_id = replace_space(data_unique_id)
  go_merge_id = replace_space(go_merge_id)
  go_gene_descrip = replace_space(go_gene_descrip)
  ont_var = replace_space(ont_var)
  entrez_var = replace_space(entrez_var)
  
  # (1) gene ontology import ----------------------------------------------------
  
  print('loading data... this may take a few minutes (especially if your data are big)')
  # read in gene ontologies
  go = read.csv(go_file, stringsAsFactors = FALSE)
  
  # check inputs: do column names exist in the dataset
  if (!go_merge_id %in% colnames(go)) {
    stop(paste0("Please edit argument `go_merge_id` to be the column name containing the common gene id in your data set. ",
                "You entered: ", go_merge_id, "; possible columns in `go_file` are: ",
                paste(colnames(go), collapse = ', ')))
  }
  
  if (!go_gene_descrip %in% colnames(go)) {
    stop(paste0("Please edit argument `go_gene_descrip` to be the column name containing the gene descriptions in your data set.",
                "You entered: ", go_gene_descrip, "; possible columns in `go_file` are: ",
                paste(colnames(go), collapse = ', ')))
  }
  
  if (!ont_var %in% colnames(go)) {
    stop(paste0("Please edit argument `ont_var` to be the column name containing the ontology terms in your data set.",
                "You entered: ", ont_var, "; possible columns in `go_file` are: ",
                paste(colnames(go), collapse = ', ')))
  }
  
  if (!entrez_var %in% colnames(go)) {
    # if entrez_var doesn't exist, initialize it with NAs
    go = go %>% mutate(entrez_var = NA)
  }
  
  
  
  
  go = go %>% 
    group_by_(go_merge_id, go_gene_descrip, entrez_var) %>%
    # collapse gene ontologies into a nested structure, with
    # a single row for each transcript and an embedded list of 
    # ontology terms
    summarise_(GO = paste0('list(unique(setdiff(', ont_var, ', "")))')) 
  
  # (2) create URLs for links to Entrez-Gene
  make_html = function(url1, name,
                       url2 = NULL,
                       start = "<a href='",
                       mid = "' target='_blank'>", end = "</a>") {
    paste0(start, url1, url2, mid, name, end)
  }
  
  if(all(is.na(go[[entrez_var]]))) {
    # doesn't exist; create it
    go = go %>%
      mutate_(url = paste0('make_html(', entrez_var, ',', go_merge_id, ')'))
  } else {
    # If they're already (partially) defined in the data frame, convert into HTML
    go = go %>%
      mutate_(url = paste0('make_html(url1 = entrez_link, url2 =', go_merge_id, ', name = ', go_merge_id, ')'))
  }
  
  # remove the original `entrez_var`; replaced by url
  go = go %>%
    select_(paste('-', entrez_var))
  
  # (3) expression data import --------------------------------------------------
  df = read.csv(data_file, stringsAsFactors = FALSE) %>% 
    filter_(paste0('!is.na(', data_unique_id, ') & ', data_unique_id, '!= ""'))
  
  # -- checks --
  df_cols = colnames(df) 
  
  # Check unique column is within the data. 
  if (!data_unique_id %in% df_cols) {
    stop(paste0("Please edit argument `data_unique_id` to be the column name containing the gene in your data set.",
                "You entered: ", data_unique_id, "; possible columns in `data_file` are: ",
                paste(df_cols, collapse = ', ')))
  }
  
  # Check merging column is within the data. 
  if (!data_merge_id %in% df_cols) {
    stop(paste0("Please edit argument `data_merge_id` to be the column name in your data set containing the values that match the ontology data.",
                "You entered: ", data_merge_id, "; possible columns in `data_file` are: ",
                paste(df_cols, collapse = ', ')))
  }
  
  
  # Check that the replicate names exist as columns within the data.
  # Remove both the name of the data_unique_id and data_merge_id from the set of all columns
  expr_cols = setdiff(
    setdiff(df_cols %>% str_replace_all('[0-9]+', ''), data_unique_id), data_merge_id)
  
  # Calculate the number of unique samples (e.g. Liver + Spleen)
  numSamples = length(expr_cols)
  
  # check that all columns are numeric
  if(df %>% 
     select_(paste0('-', data_unique_id), paste0('-', data_merge_id)) %>% 
     summarise_all(funs(sum(!is.numeric(.)))) %>% 
     t() %>% 
     sum() != 0) {
    stop("`data_file` contains more than one non-numeric columns. Please input only the gene id and numeric expression data.")
  }
  
  
  
  
  if(!setequal(sample_vars, expr_cols)) {
    stop('Check that `sample_vars` within `global.R` match the column names within `data_file`.')
  }
  
  
  # check that gene_id is unique
  if(sum(duplicated(df[[data_unique_id]]))) {
    stop('The values within `data_unique_id` must be unique values to merge to the ontology terms. Remove duplicate values.')
  }
  
  print('Data loaded. Let the fun begin.')
  
  # calculate values for expression data --------------------------------------------------
  # convert the data frame to a long format
  # assumptions: there are 1-2 columns which may be strings, specified by `data_unique_id` and `data_merge_id`.
  # everything else is assumed to be a replicate of expression for that sample.
  df = df %>% 
    # convert to a long dataset
    gather('tissue_rep', 'expr', select_vars(include = c(-matches(data_unique_id), -matches(data_merge_id)))) %>% 
    # mutate(rep_num = as.numeric(str_extract_all(tissue_rep, '[0-9]+'))) %>% 
    separate(tissue_rep, into = c('tissue', 'repinfo'), sep = '[0-9]') %>% 
    select(-repinfo)
  
  
  print('Calculating average expression per sample.')
  # (4) Calculate average and standard deviation for the samples
  df_sum = df %>% 
    group_by_(data_unique_id, data_merge_id, 'tissue') %>% 
    summarise(sem = sd(expr) / sqrt(length(expr)),
              expr = mean(expr))
  
  # ANOVAs --------------------------------------------------------------------------
  print('Time to calculate ANOVAs.')
  print('Note: this will take awhile if your data are big. You will receive updates on how far it has progressed through all the pairwise ANOVA calculations.')
  print('Luckily, you only need to do this once.')
  
  if(numSamples == 1) {
    # There's only one sample.  Set ANOVA q-values to NA
    df_sum = df_sum %>% 
      mutate_(.dots = setNames(NA, paste0(df$tissue[1], '_q')))
  } else {
    
    source('run_anovas.R')
    
    # (5) Calculate pairwise ANOVAs
    # Drop `data_merge_id` from ANOVA calcs.
    if(data_merge_id != data_unique_id) {
      df_anova = df %>% select_(paste0('-', data_merge_id))
    } else{
      df_anova = df
    }
    
    anovas2 = run_anovas(df_anova, 2, data_unique_id)
    
    # merge ANOVAs
    df_sum = df_sum %>% 
      left_join(anovas2, by = setNames(data_unique_id, data_unique_id))
    
    if(numSamples > 2) { 
      # (6) Calculate ANOVAs for all samples
      anovasAll = run_anovas(df_anova, numSamples, data_unique_id)
      
      # merge ANOVAs
      df_sum = df_sum %>% 
        left_join(anovasAll, by = setNames(data_unique_id, data_unique_id))
    }
  }
  
  
  
  # (7) merge ontology terms, expression data, and ANOVAs --------------------------------
  
  # Check that merging will work.
  num_nonmatch = length(setdiff(df_sum[[data_merge_id]], go[[go_merge_id]]))
  
  if(num_nonmatch > 0){
    warning(paste0("Note: ", num_nonmatch, " genes within your dataset are missing within the ontology dataset. 
These genes will have their ontology terms listed as missing."))
  }
  
  # merge ont terms + expression data
  df_sum = df_sum %>% left_join(go, by = setNames(go_merge_id, data_merge_id))
  
  # (8) pull unique ontology terms that are within the merged dataset
  go_terms = df_sum %>% pull(ont_var) %>% unlist() %>% unique()
  
  # (9) round values -------------------------------------------------------
  df_sum = df_sum %>% 
    mutate_at(funs(round(., num_digits)), .vars = c('expr', 'sem')) %>%
    mutate_at(funs(signif(., num_digits)), .vars = vars(contains('_q'))) %>% 
    ungroup()
  
  # if data_merge_id != data_unique_id, drop merge_id
  if(data_merge_id != data_unique_id) {
    df_sum = df_sum %>% 
      select_(paste0('-', data_merge_id))
  }
  
  # (10) export ------------------------------------------------------------------
  
  # save the necessary variables
  saveRDS(go_terms, paste0(export_dir, 'go_terms.rds'))
  saveRDS(df_sum, paste0(export_dir, 'expr_db.rds'))
  
  
  
  return(list(go_terms = go_terms, df = df_sum))
  
  print('data loaded! starting Shiny app')
}






# If a column name has a space in it, replace it with a period.
# csv.read will replace any spaces with .
replace_space = function (var_name) {
  str_replace_all(var_name, ' ', '.')
}


