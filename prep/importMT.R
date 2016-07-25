library(RSQLite)
library(stringr)
library(dplyr)
library(tidyr)
library(readr)
library(data.table)

# Import and clean data.


# Import averages and SEs. ------------------------------------------------
df <- read.delim("~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/Expression_Levels_for_webpage(10-6-15).txt")


numTranscripts = nrow(df)

# Pull out the averages and gather ----------------------------------------
avg = df %>% 
  select(transcript = Transcript, atria = ATR_mean, `left ventricle` = LV_mean,
         `total aorta` = AOR_mean, `right ventricle` = RV_mean,
         soleus = SOL_mean, `thoracic aorta` = TA_mean, 
         `abdominal aorta`  = AA_mean, diaphragm = DIA_mean,
         eye = EYE_mean, EDL = EDL_mean, FDB = FDB_mean, 
         masseter = MAS_mean, plantaris = PLA_mean, 
         tongue = TON_mean) %>% 
  mutate(id = 1:numTranscripts) %>% 
  gather(tissue, expr, -transcript, -id)


# Pull out SE and gather --------------------------------------------------
SE = df %>% 
  select(transcript = Transcript, atria = ATR_standard_error, `left ventricle` = LV_standard_error,
         `total aorta` = AOR_standard_error, `right ventricle` = RV_standard_error,
         soleus = SOL_standard_error, `thoracic aorta` = TA_standard_error, 
         `abdominal aorta`  = AA_standard_error, diaphragm = DIA_standard_error,
         eye = EYE_standard_error, EDL = EDL_standard_error, FDB = FDB_standard_error, 
         masseter = MAS_standard_error, plantaris = PLA_standard_error, 
         tongue = TON_standard_error) %>% 
  gather(tissue, SE, -transcript)


#! Need to spot check that everything is done properly.
#! SE, stdev, 95% CI, ...?



# Calculate q-values ------------------------------------------------------
# Run previously; then imported.
# source('~/GitHub/muscle-transcriptome/prep/ANOVAlookupTable.r')

# anovas = ANOVAlookupTable('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/MT_adjusted_TranscriptQuants.csv', 6)



# Pull in the outdated data to get GO and gene names ----------------------
oldFile = '~/Dropbox/Muscle Transcriptome Atlas/Website files/MTapp-v0-51/data/combData_2014-10-19.rds'

geneInfo = read_rds(oldFile) %>% 
  select(Transcript, shortName, geneSymbol, geneName, GO, EntrezLink, UCSCLink) %>% 
  mutate(uc = str_extract(Transcript, 'uc......'), # Remove extra crap from transcript ids
         NM = str_extract(Transcript, 'N...............')) %>% 
  mutate(transcript = ifelse(is.na(uc), NM, uc), # tidying up transcript name.
         
         geneLink = ifelse(geneSymbol == "", # Gene symbol w/ link to entrez page.
                           "", paste0("<a href = '", EntrezLink, 
                                      "' target = '_blank'>", geneSymbol, "</a>")), 
         transcriptLink = ifelse(UCSCLink == "",
                                 transcript, 
                                 paste0("<a href = '", UCSCLink,
                                        "' target = '_blank'>", transcript, "</a>")) # transcript name w/ link to UCSC page
  ) %>% 
  select(transcript, shortName, gene = geneSymbol, GO, geneLink, transcriptLink)

# Merge everything together -----------------------------------------------
df = full_join(avg, SE, by = c("transcript", "tissue")) %>% 
  mutate(
    lb = expr - SE,
    ub = expr + SE)



# Merge in ANOVAs ---------------------------------------------------------
anovas = readRDS('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/ANOVAs/allANOVAs_merged_2015-10-18.rds')

anovas = anovas %>% 
  group_by(transcript) %>% 
  mutate_each(funs(signif(., digits = 3)))


# Merge
df = full_join(df, anovas, by = 'transcript') %>% 
  select(-contains('_p'))

# Clean the transcript IDs into shortened versions ------------------------
df = df %>% mutate(uc = str_extract(df$transcript, 'uc......'),
                                 NM = str_extract(df$transcript, 'N...............')) %>% 
  mutate(fullTranscript = transcript, 
         expr = round(expr, digits = 2),
         SE = round(SE, digits = 2),
         lb = round(lb, digits = 2),
         ub = round(ub, digits = 2),
         transcript = ifelse(is.na(uc), NM, uc)) %>% 
  select(-fullTranscript, -uc, -NM)


# Merge in GO, ontology
df = left_join(df, 
                      geneInfo, by = c("transcript" = "transcript"))


# refactorise the tissue levels.
df$tissue = factor(df$tissue,
                   c('total aorta' = 'total aorta',
                     'thoracic aorta' = 'thoracic aorta',
                     'abdominal aorta' = 'abdominal aorta',
                     'atria' = 'atria', 
                     'left ventricle' = 'left ventricle',
                     'right ventricle' = 'right ventricle',
                     'diaphragm' = 'diaphragm',
                     'eye' = 'eye', 
                     'EDL' = 'EDL', 
                     'FDB' = 'FDB', 
                     'masseter' =  'masseter',
                     'plantaris' = 'plantaris',
                     'soleus' = 'soleus',
                     'tongue' = 'tongue'))

# Public version ----------------------------------------------------------

anovasWeb = readRDS('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/ANOVAs/allANOVAs_forWeb_2015-10-18.rds')

anovasWeb = anovasWeb %>% 
  group_by(transcript) %>% 
  mutate_each(funs(signif(., digits = 3)))


# For the public version, remove 4 tissues.
df_public = full_join(df, anovasWeb, by = 'transcript') %>% 
  select(-contains('_p')) %>% 
  filter(tissue != 'thoracic aorta', tissue != 'masseter', 
         tissue != 'abdominal aorta', tissue != 'tongue')



# Clean the transcript IDs into shortened versions ------------------------
df_public = df_public %>% mutate(uc = str_extract(df_public$transcript, 'uc......'),
                                 NM = str_extract(df_public$transcript, 'N...............')) %>% 
  mutate(fullTranscript = transcript, 
         expr = round(expr, digits = 2),
         SE = round(SE, digits = 2),
         lb = round(lb, digits = 2),
         ub = round(ub, digits = 2),
         transcript = ifelse(is.na(uc), NM, uc)) %>% 
  select(-fullTranscript, -uc, -NM)


# Merge in GO, ontology
df_public = left_join(df_public, 
                      geneInfo, by = c("transcript" = "transcript"))


# Refactorise
df_public$tissue = factor(df_public$tissue,
                          c('total aorta' = 'total aorta',
                            # 'thoracic aorta' = 'thoracic aorta', 
                            # 'abdominal aorta' = 'abdominal aorta', 
                            'atria' = 'atria', 
                            'left ventricle' = 'left ventricle',
                            'right ventricle' = 'right ventricle',
                            
                            'diaphragm' = 'diaphragm',
                            'eye' = 'eye', 
                            'EDL' = 'EDL', 
                            'FDB' = 'FDB', 
                            # 'masseter' =  'masseter', 
                            'plantaris' = 'plantaris',
                            'soleus' = 'soleus'))


df_public = data.table(df_public)



# save files --------------------------------------------------------------

saveRDS(df, '~/Dropbox/Muscle Transcriptome Atlas/Website files/data/expr_2016-04-10.rds')

saveRDS(df_public, '~/Dropbox/Muscle Transcriptome Atlas/Website files/data/expr_public_2016-04-10.rds')

write.csv(df_public, '~/Dropbox/Muscle Transcriptome Atlas/Website files/data/expr_public_2016-04-10.csv')

# Copy to sqlite db -------------------------------------------------------
db = src_sqlite('~/Dropbox/Muscle Transcriptome Atlas/Website files/data/expr_public_2016-04-10.sqlite3',
                create = TRUE)

data_sqlite = copy_to(db, df_public, temporary = FALSE,
                      name = 'MT',
                      indexes = list('expr', 'transcript', 'tissue'))



# Create small version ----------------------------------------------------


data = readRDS('~/Dropbox/Muscle Transcriptome Atlas/Website files/data/expr_2016-04-10.rds') %>% 
  select(-id)


df = data %>% 
  filter(!(transcript %like% 'NM'),
         transcript %like% 'uc00')

saveRDS(df, '~/Dropbox/Muscle Transcriptome Atlas/Website files/data/expr_2016-04-10_small.rds')
