# function to clean up ontology files to use as example dataset
# Ontologies exported by Scott Lewis on 1 August 2017
# Removes extraneous columns and simplifies gene descriptions

library(stringr)
library(dplyr)
library(tidyr)

ont = read.csv('data/annot_expDB_human.csv', stringsAsFactors = FALSE)

ont2 = ont %>% 
  separate(Gene.description, into = c('gene_description', 'source'), sep = ' \\[') %>% 
  select(gene = Gene.name, gene_description, geneLink, GO)

write.csv(ont2, 'data/sample_ontologies')  
