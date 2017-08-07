# function to clean up ontology files to use as example dataset
# Ontologies exported by Scott Lewis on 4 August 2017
# Removes extraneous columns and simplifies gene descriptions

library(stringr)
library(dplyr)
library(tidyr)
library(data.table)

ont_files = list.files(path = 'data/') 
ont_files = ont_files[ont_files%like% 'annot']

# human
ont = read.csv('data/annot_expdb_humanV2.csv', stringsAsFactors = FALSE)

human = ont %>% 
  separate(Gene.description, into = c('gene_description', 'source'), sep = ' \\[') %>% 
  select(gene_id_go = Symbol, gene_description, geneLink, GO)

write.csv(human, 'data/annot_expdb_human2017-08.csv')  

# mouse
ont = read.csv('data/annot_expdb_mouseV2.csv', stringsAsFactors = FALSE)

mouse = ont %>% 
  separate(Gene.description, into = c('gene_description', 'source'), sep = ' \\[') %>% 
  select(gene_id_go = Symbol, gene_description, geneLink, GO)

write.csv(mouse, 'data/annot_expdb_mouse2017-08.csv')  

# zee rats
ont = read.csv('data/annot_expdb_ratV2.csv', stringsAsFactors = FALSE)

rat = ont %>% 
  separate(Gene.description, into = c('gene_description', 'source'), sep = ' \\[') %>% 
  select(gene_id_go = Symbol, gene_description, geneLink, GO)

write.csv(rat, 'data/annot_expdb_rat2017-08.csv')  

