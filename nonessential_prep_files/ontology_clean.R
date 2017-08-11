# function to clean up ontology files to use as example dataset
# Ontologies exported by Scott Lewis on 4 August 2017
# Removes extraneous columns and simplifies gene descriptions

library(stringr)
library(dplyr)
library(tidyr)
library(data.table)

ont_files = list.files(path = 'data/', full.names = TRUE) 
ont_files = ont_files[ont_files%like% 'V3']

for(file in ont_files) {
  ont = read.csv(file, stringsAsFactors = FALSE)
  
  species = str_replace_all(str_replace_all(file, "data//annot_expdb_", ""), 'V3.csv', '')
  
  ont = ont %>% 
    # separate(Gene.description, into = c('gene_description', 'source'), sep = ' \\[') %>% 
    select(gene_id_go = Symbol, gene_description = description, geneLink, GO)
  
  write.csv(ont, paste0('data/annot_expdb_', species, '2017-08.csv')) 
}