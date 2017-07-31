
# prep_data.R ---------------------------------------------------------------
# prep_data is called by global.R once initially to set up the data fro 

prep_data = function(data_file, go_file, 
                     # variable names within data_file
                     data_gene_id = 'gene_id',
                     # variable names within go_file
                     go_gene_id = 'gene_id',
                     go_gene_var = 'gene',
                     ont_var = 'GO_term',
                     entrez_link = 'http://www.ncbi.nlm.nih.gov/gene/?term=',
                     export_dir = 'data/') {
  
  # gene ontology import ----------------------------------------------------
  print('loading data... this may take a few minutes (especially if your data are big)')
  # read in gene ontologies
  go = read.csv(go_file, stringsAsFactors = FALSE)
  
  if (!go_gene %in% colnames(go)) {
    error("Please edit argument `go_gene` to be the column name containing the gene in your data set.")
  }
  
  if (!go_gene_id %in% colnames(go)) {
    error("Please edit argument `go_gene_id` to be the column name containing the Ensembl gene id in your data set.")
  }
  
  if (!go_transcript %in% colnames(go)) {
    error("Please edit argument `go_transcript` to be the column name containing the transcript name in your data set.")
  }
  
  # pull unique ontology terms
  go_terms = go %>% distinct_(ont_var) %>% pull(ont_var)
  
  
  go = go %>% group_by_(go_gene) %>%
    # collapse gene ontologies into a nested structure, with
    # a single row for each transcript and an embedded list of 
    # ontology terms
    summarise_(GO = paste0('list(', ont_var, ')')) %>% 
    # create URLs for links to UCSC and Entrez-Gene
    # If they're already defined in the data frame, ignore.
    mutate(geneLink = ifelse(is.na(geneLink) | geneLink == '', 
                             paste0("<a href = '", entrez_link, go_gene_id,"' target = '_blank'>", go_gene, "</a>"),
                             geneLink),
           transcriptLink = ifelse(is.na(transcriptLink) | transcriptLink == '', 
                                   paste0("<a href = '", ucsc_link, "' target = '_blank'>", go_transcript, "</a>"),
                                   geneLink)
    )  
  # expression data import --------------------------------------------------
  df = read.csv(data_file, stringsAsFactors = FALSE)
  
  # convert the data frame from a wide format
  # assumptions: there are two columns, specified by `data_gene` and `data_transcript`.
  # everything else is assumed to be the average expression for that sample.
  df = df %>% 
    gather('tissue', 'expr', select_vars(include = c(-matches(data_gene), -matches(data_transcript))))
  
  # merge ontology terms and expression data --------------------------------
  # Check column is within the data.
  if (!data_gene %in% colnames(df)) {
    error("Please edit argument `data_gene` to be the column name containing the gene in your data set.")
  }
  
  df = df %>% left_join(go, by = setNames(go_gene, data_gene))
  
  # export ------------------------------------------------------------------
  
  # save the necessary variables
  saveRDS(go_terms, paste0(export_dir, 'go_terms.rds'))
  saveRDS(df, paste0(export_dir, 'expr_db.rds'))
  
  return(list(go_terms = go_terms, df = df))
  
  print('data loaded! starting Shiny app')
}




