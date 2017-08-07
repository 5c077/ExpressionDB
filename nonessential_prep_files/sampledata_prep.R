# Prep GETx data
library(dplyr)
library(tidyr)
getx = read.csv('data/input_gtex_sample2.csv')

getx = getx %>% 
  select(gene = Symbol, 
         tissueA1 = GTEX.13VXT.1026.SM.5LU37, tissueA2 = GTEX.QEG5.1026.SM.4R1KT, tissueA3 = GTEX.QEL4.1026.SM.4R1JK,
         tissueB1 = GTEX.OOBJ.3026.SM.3NB1D, tissueB2 = GTEX.P4PP.3026.SM.3P61O, tissueB3 = GTEX.PX3G.3026.SM.48TZR)

set.seed(25)
getx1 = getx %>% sample_n(1250)
write.csv(getx1, 'data/sample_data.csv', row.names = FALSE)

write.csv(getx, 'data/sample_data2_getx.csv', row.names = FALSE)

# Find out intersection of ontology with sample_data
go = read.csv('data/annot_expdb_human2017-08.csv', stringsAsFactors = FALSE)

go_unique = go %>% distinct(gene_id_go)

go_matched = inner_join(go_unique, getx1, by = c('gene_id_go' = 'gene')) %>% pull(gene_id_go)

matches = go %>% filter(gene_id_go %in% go_matched)
write.csv(matches, 'data/sample_ontologies.csv', row.names = FALSE)
