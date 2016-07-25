source('ANOVAlookupTable.r')

anovas = ANOVAlookupTable('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/MT_adjusted_TranscriptQuants.csv', onlyPairwise = TRUE)
saveRDS(anovas, 'pairwiseANOVAs_2015-10-18.rds')
write.csv(anovas, 'pairwiseANOVAs_2015-10-18.csv')

anovas = anovas[,1:182]
write.csv(anovas, 'pairwiseANOVAs_trimmed_2015-10-18.csv')
saveRDS(anovas, 'pairwiseANOVAs_trimmed_2015-10-18.rds')

# All tissues.
anovas = ANOVAlookupTable('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/MT_adjusted_TranscriptQuants.csv', onlyPairwise = TRUE, n = 14)
saveRDS(anovas, 'allANOVAs_2015-10-18.rds')
write.csv(anovas, 'allANOVAs_2015-10-18.csv')

anovas2 = ANOVAlookupTable('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/MT_adjusted_TranscriptQuants.csv', 
                          onlyPairwise = TRUE, n = 10,
                          muscles = c('ATR', 'LV', 'RV', 'DIA', 'AOR',
                                      'EDL', 'EYE', 'SOL', 'FDB', 'PLA'))
saveRDS(anovas2, 'allWebANOVAs_2015-10-18.rds')
write.csv(anovas2, 'allWebANOVAs_2015-10-18.csv')

# Smooth
smooth = ANOVAlookupTable('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/MT_adjusted_TranscriptQuants.csv', onlyPairwise = TRUE, n = 3, muscles = c('TA, AA, AOR'))
smooth = ANOVAlookupTable('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/MT_adjusted_TranscriptQuants.csv', onlyPairwise = TRUE, n = 3, muscles = c('TA', 'AA', 'AOR'))
write.csv(smooth, 'allSmoothANOVAs_2015-10-18.csv')
saveRDS(smooth, 'allSmoothANOVAs_2015-10-18.rds')

# Cardiac
card = ANOVAlookupTable('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/MT_adjusted_TranscriptQuants.csv', onlyPairwise = TRUE, n = 3, muscles = c('ATR', 'LV', "RV"))
write.csv(card, 'allCardiacANOVAs_2015-10-18.csv')
saveRDS(card, 'allCardiacANOVAs_2015-10-18.rds')

# Skeletal
skel = ANOVAlookupTable('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/MT_adjusted_TranscriptQuants.csv', onlyPairwise = TRUE, n = 8, muscles = c('DIA', 'EDL', 'EYE', 'SOL', 'TON','FDB', 'MAS', 'PLA'))
saveRDS(skel, 'allSkelANOVAs_2015-10-18.rds')
write.csv(skel, 'allSkelANOVAs_2015-10-18.csv')

skel = ANOVAlookupTable('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/MT_adjusted_TranscriptQuants.csv', onlyPairwise = TRUE, n = 6, muscles = c('DIA', 'EDL', 'EYE', 'SOL','FDB', 'PLA'))
saveRDS(skel, 'SkelANOVAs_2015-10-18.rds')
write.csv(skel, 'skelANOVAs_2015-10-18.csv')

# Striated
striated = ANOVAlookupTable('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/MT_adjusted_TranscriptQuants.csv', onlyPairwise = TRUE, n = 11, muscles = c('ATR', 'LV', 'RV', 'DIA', 'EDL', 'EYE', 'SOL', 'TON','FDB', 'MAS', 'PLA'))
write.csv(striated, 'allStriatedANOVAs_2015-10-18.csv')
saveRDS(striated, 'allStriatedANOVAs_2015-10-18.rds')

striated = ANOVAlookupTable('~/Dropbox/Muscle Transcriptome Atlas/RUM_Re-analysis/Muscle_Re-run_Mapstats_Quantfiles/MT_adjusted_TranscriptQuants.csv', onlyPairwise = TRUE, n = 9, muscles = c('ATR', 'LV', 'RV', 'DIA', 'EDL', 'EYE', 'SOL', 'FDB', 'PLA'))
saveRDS(striated, 'striatedANOVAs_2015-10-18.rds')
write.csv(striated, 'striatedANOVAs_2015-10-18.csv')


# Merge all together.
anovas = readRDS('allANOVAs_2015-10-18.rds')
anovas = data.frame(transcript = row.names(anovas), anovas)

anovasWeb = readRDS('allWebANOVAs_2015-10-18.rds')
anovasWeb = data.frame(transcript = row.names(anovasWeb), anovasWeb)


striatedWeb = readRDS('striatedANOVAs_2015-10-18.rds')
striatedWeb = data.frame(transcript = row.names(striatedWeb), striatedWeb)
striated = readRDS('allStriatedANOVAs_2015-10-18.rds')
striated = data.frame(transcript = row.names(striated), striated)

cardiac = readRDS('allCardiacANOVAs_2015-10-18.rds')
cardiac = data.frame(transcript = row.names(cardiac), cardiac)

skeletalWeb = readRDS('SkelANOVAs_2015-10-18.rds')
skeletalWeb = data.frame(transcript = row.names(skeletalWeb), skeletalWeb)
skeletal = readRDS('allSkelANOVAs_2015-10-18.rds')
skeletal = data.frame(transcript = row.names(skeletal), skeletal)

smooth = readRDS('allSmoothANOVAs_2015-10-18.rds')
smooth = data.frame(transcript = row.names(smooth), smooth)


pairwise = readRDS('pairwiseANOVAs_trimmed_2015-10-18.rds')
pairwise = data.frame(transcript = row.names(pairwise), pairwise)


library(dplyr)
allANOVAs = full_join(pairwise, smooth)
allANOVAs = full_join(allANOVAs, cardiac)
allANOVAs = full_join(allANOVAs, skeletal)
allANOVAs = full_join(allANOVAs, skeletalWeb)
allANOVAs = full_join(allANOVAs, striated)
allANOVAs = full_join(allANOVAs, striatedWeb)
allANOVAs = full_join(allANOVAs, anovas)
allANOVAs = full_join(allANOVAs, anovasWeb)

write.csv(allANOVAs, 'allANOVAs_merged_2015-10-18.csv')
saveRDS(allANOVAs, 'allANOVAs_merged_2015-10-18.rds')


ANOVAs4Web = allANOVAs %>% 
  select(-contains('TA'), -contains('AA'), -contains('MAS'), -contains('TON'))

write.csv(ANOVAs4Web, 'allANOVAs_forWeb_2015-10-18.csv')
saveRDS(ANOVAs4Web, 'allANOVAs_forWeb_2015-10-18.rds')


ANOVAs4Web = allANOVAs %>% 
  select(-contains('_p'),
         -contains('TA'), -contains('AA'), 
         -contains('MAS'), -contains('TON'))

saveRDS(ANOVAs4Web, 'q_forWeb_2015-10-18.rds')
