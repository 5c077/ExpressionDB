
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
# 4. check that the data_gene_id column contains unique values
# 5. check that the data_file contains only numeric values, aside from whatever is in `data_gene_id`
# 6. check that data_file contains the correct sample names
# 7. check that data_file and go_file have values that can merge together

prep_data = function(data_file, go_file, 
                     # variable names within data_file
                     sample_vars,
                     data_gene_id = 'gene',
                     # variable names within go_file
                     go_gene_id = 'gene',
                     go_gene_descrip = 'gene_description',
                     ont_var = 'GO',
                     entrez_var = 'geneLink',
                     entrez_link = 'http://www.ncbi.nlm.nih.gov/gene/?term=',
                     export_dir = 'data/',
                     num_digits = 2) {
  # Check inputs ------------------------------------------------------------
  # Spaces aren't allowed in column names; during import they'll be converted to periods.
  data_gene_id = replace_space(data_gene_id)
  go_gene_id = replace_space(go_gene_id)
  go_gene_descrip = replace_space(go_gene_descrip)
  ont_var = replace_space(ont_var)
  entrez_var = replace_space(entrez_var)
  
  # (1) gene ontology import ----------------------------------------------------
  
  print('loading data... this may take a few minutes (especially if your data are big)')
  # read in gene ontologies
  go = read.csv(go_file, stringsAsFactors = FALSE)
  
  # check inputs: do column names exist in the dataset
  if (!go_gene_id %in% colnames(go)) {
    stop("Please edit argument `go_gene_id` to be the column name containing the common gene id in your data set.")
  }
  
  if (!go_gene_descrip %in% colnames(go)) {
    stop("Please edit argument `go_gene_descrip` to be the column name containing the gene descriptions in your data set.")
  }
  
  if (!ont_var %in% colnames(go)) {
    stop("Please edit argument `ont_var` to be the column name containing the ontology terms in your data set.")
  }
  
  if (!entrez_var %in% colnames(go)) {
    # if entrez_var doesn't exist, initialize it with NAs
    go = go %>% mutate(entrez_var = NA)
  }
  
  
  
  
  go = go %>% group_by_(go_gene_id, go_gene_descrip, entrez_var) %>%
    # collapse gene ontologies into a nested structure, with
    # a single row for each transcript and an embedded list of 
    # ontology terms
    summarise_(GO = paste0('list(unique(setdiff(', ont_var, ', "")))')) %>% 
    # (2) create URLs for links to Entrez-Gene
    # If they're already defined in the data frame, ignore.
    mutate(
      # geneLink = ifelse(all(is.na(geneLink)),
      #                            paste0("<a href = '", entrez_link, go_gene_id,"' target = '_blank'>", 
      #                                   go_gene_var, "</a>"), geneLink)
    )  
  
  # (3) expression data import --------------------------------------------------
  df = read.csv(data_file, stringsAsFactors = FALSE) %>% 
    filter_(paste0('!is.na(',data_gene_id, ') & ', data_gene_id, '!= ""'))
  
  # -- checks --
  # check that all columns are numeric
  if(df %>% 
     select_(paste0('-', data_gene_id)) %>% 
     summarise_all(funs(sum(!is.numeric(.)))) %>% 
     t() %>% 
     sum() != 0) {
    stop("`data_file` contains more than one non-numeric columns. Please input only the gene id and numeric expression data.")
  }
  
  # check that gene_id is unique
  if(sum(duplicated(df[[data_gene_id]]))) {
    stop('The values within `data_gene_id` must be unique values to merge to the ontology terms. Remove duplicate values.')
  }
  
  # Check merging column is within the data. 
  df_cols = colnames(df) 
  
  if (!data_gene_id %in% df_cols) {
    stop("Please edit argument `data_gene_id` to be the column name containing the gene in your data set.")
  }
  
  # Check that the replicate names exist as columns within the data.
  expr_cols = setdiff(df_cols %>% str_replace_all('[0-9]+', ''), data_gene_id)
  
  if(!setequal(sample_vars, expr_cols)) {
    stop('Check that `sample_vars` within `global.R` match the column names within `data_file`.')
  }
  
  print('Data loaded. Let the fun begin.')
  
  # calculate values for expression data --------------------------------------------------
  # convert the data frame to a long format
  # assumptions: there are one columns, specified by `data_gene_id` and `data_transcript`.
  # everything else is assumed to be a replicate of expression for that sample.
  df = df %>% 
    gather('tissue_rep', 'expr', select_vars(include = c(-matches(data_gene_id)))) %>% 
    # mutate(rep_num = as.numeric(str_extract_all(tissue_rep, '[0-9]+'))) %>% 
    separate(tissue_rep, into = c('tissue', 'repinfo'), sep = '[0-9]') %>% 
    select(-repinfo)
  
  # Calculate the number of unique samples (e.g. Liver + Spleen)
  numSamples = length(unique(df$tissue))
  
  print('Calculating average expression per sample.')
  # (4) Calculate average and standard deviation for the samples
  df_sum = df %>% 
    group_by_(data_gene_id, 'tissue') %>% 
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
    anovas2 = run_anovas(df, 2, data_gene_id)
    
    # merge ANOVAs
    df_sum = df_sum %>% 
      left_join(anovas2, by = setNames(data_gene_id, data_gene_id))
    
    if(numSamples > 2) { 
      # (6) Calculate ANOVAs for all samples
      anovasAll = run_anovas(df, numSamples, data_gene_id)
      
      # merge ANOVAs
      df_sum = df_sum %>% 
        left_join(anovasAll, by = setNames(data_gene_id, data_gene_id))
    }
  }
  
  
  
  # (7) merge ontology terms, expression data, and ANOVAs --------------------------------
  
  # Check that merging will work.
  num_nonmatch = length(setdiff(df_sum[[data_gene_id]], go[[go_gene_id]]))
  
  if(num_nonmatch > 0){
    warning(paste0("Note: ", num_nonmatch, " genes within your dataset are missing within the ontology dataset. 
These genes will have their ontology terms listed as missing."))
  }
  
  # merge ont terms + expression data
  df_sum = df_sum %>% left_join(go, by = setNames(go_gene_id, data_gene_id))
  
  # (8) pull unique ontology terms that are within the merged dataset
  go_terms = df_sum %>% pull(ont_var) %>% unlist() %>% unique()
  
  # (9) round values -------------------------------------------------------
  df_sum = df_sum %>% 
    mutate(expr = round(expr, num_digits)) %>% 
    mutate_at(funs(signif(., 2)), .vars = vars(contains('_q')))
  
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


