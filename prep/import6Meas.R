# Testing out what data would look like showing ALL the measurements (6 replicates)

# import data -------------------------------------------------------------
# Importing a subset for testing purposes

library(llamar)
loadPkgs()

df = read_excel('~/Dropbox/Muscle Transcriptome Atlas/Website files/data/expr_6tissues_subset.xlsx')


# Reshape into a tidy dataset ---------------------------------------------
# Sequentially transpose from a wide to long dataset.
df1 = df %>%
  gather(muscle, expr1, -contains('2'), -contains('3'),
         -contains('4'),-contains('5'), -contains('6'), -Transcript) %>% 
  mutate(muscle = str_replace_all(muscle, '[0-9]_MIN_ANTI', '')) %>% 
  select(Transcript, muscle, expr1)

df2 = df%>% 
  gather(muscle, expr2, -contains('1'), -contains('3'), 
         -contains('4'),-contains('5'), -contains('6'), -Transcript) %>% 
  mutate(muscle = str_replace_all(muscle, '[0-9]_MIN_ANTI', '')) %>% 
  select(Transcript, muscle, expr2)


df3 = df%>% 
  gather(muscle, expr3, -contains('1'), -contains('2'), 
         -contains('4'),-contains('5'), -contains('6'), -Transcript) %>% 
  mutate(muscle = str_replace_all(muscle, '[0-9]_MIN_ANTI', '')) %>% 
  select(Transcript, muscle, expr3)


df4 = df%>% 
  gather(muscle, expr4, -contains('1'), -contains('2'), 
         -contains('3'),-contains('5'), -contains('6'), -Transcript) %>% 
  mutate(muscle = str_replace_all(muscle, '[0-9]_MIN_ANTI', ''),
         muscle = str_replace_all(muscle, '[0-9]\\(MIN_ANTI', '')) %>% 
  select(Transcript, muscle, expr4)


df5 = df%>% 
  gather(muscle, expr5, -contains('1'), -contains('2'), 
         -contains('3'),-contains('4'), -contains('6'), -Transcript) %>% 
  mutate(muscle = str_replace_all(muscle, '[0-9]_MIN_ANTI', '')) %>% 
  select(Transcript, muscle, expr5)


df6 = df%>% 
  gather(muscle, expr6, -contains('1'), -contains('2'), 
         -contains('3'),-contains('4'), -contains('5'), -Transcript) %>% 
  mutate(muscle = str_replace_all(muscle, '[0-9]_MIN_ANTI', '')) %>% 
  select(Transcript, muscle, expr6)



df_tidy = full_join(df1, df2, by = c('Transcript', 'muscle'))
df_tidy = full_join(df_tidy, df3, by = c('Transcript', 'muscle'))
df_tidy = full_join(df_tidy, df4, by = c('Transcript', 'muscle'))
df_tidy = full_join(df_tidy, df5, by = c('Transcript', 'muscle'))
df_tidy = full_join(df_tidy, df6, by = c('Transcript', 'muscle'))


# Calc avg ----------------------------------------------------------------

df_tidy = df_tidy %>% 
  rowwise() %>% 
  mutate(expr = sum(expr1, expr2, expr3, expr4, expr5, expr6)/6, 
         std = sd(c(expr1, expr2, expr3, expr4, expr5, expr6)),
         lb = expr - (1.96*std)/sqrt(6),
         ub = expr + (1.96*std)/sqrt(6),
         minExpr = min(expr1, expr2, expr3, expr4, expr5, expr6),
         maxExpr = max(expr1, expr2, expr3, expr4, expr5, expr6),
         uc = str_extract(Transcript, 'uc......'), # Remove extra crap from transcript ids
         NM = str_extract(Transcript, 'N...............')) %>% 
  mutate(transcript = ifelse(is.na(uc), NM, uc)) %>% 
  ungroup() %>% 
  group_by(transcript) %>% 
  mutate(muscleID = row_number()) # tidying up transcript name.


# fully long df -----------------------------------------------------------

df_tidiest = df_tidy %>% 
  gather(repNum, indivExpr, -Transcript, -transcript, -muscle, -expr) %>% 
  mutate(indivExpr = as.numeric(indivExpr))

# reorder -----------------------------------------------------------------
df_tidy$tissue = factor(df_tidy$tissue,
                   c('AOR', 'AA', 'TA',
                     'ATR', 'LV', 'RV',
                     'DIA', 'EYE', 'EDL',
                     'FDB', 'MAS', 'PLA',
                     'SOL', 'TON'))

# plot --------------------------------------------------------------------
sizeDot = 3
alphaDot = 0.15


# Hideous dot plot w/ all vals --------------------------------------------


ggplot(df_tidy, aes(y = muscle, yend = muscle,
                    fill = expr)) +
  geom_point(aes(x = expr1), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  geom_point(aes(x = expr2), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  geom_point(aes(x = expr3), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  geom_point(aes(x = expr4), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  geom_point(aes(x = expr5), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  geom_point(aes(x = expr6), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  geom_segment(aes(xend = 0, x = expr), 
               size = 0.5,
               colour = grey50K) +
  geom_point(aes(x = expr), size = sizeDot,
             alpha = 1,
             colour = grey90K, shape = 21) +
  scale_fill_gradientn(colours = brewer.pal(9, 'YlGnBu')) +
  facet_wrap(~transcript) +
  theme_xgrid() +
  theme(axis.text.y = element_text(size = 10), 
        panel.border = element_rect(colour = grey90K, fill = NA, size = 0.2))



# ugly violin, possibly wrong ---------------------------------------------


ggplot(df_tidiest, aes(y = indivExpr, x = muscle))+
  geom_violin()+
  coord_flip() +
  facet_wrap(~transcript)


# With error bard ---------------------------------------------------------

ggplot(df_tidy, aes(x = muscle, xend = muscle,
                    fill = expr)) +
  # geom_point(aes(y = expr1), size = sizeDot,
  #            alpha = alphaDot,
  #            colour = grey90K, shape = 21) +
  # geom_point(aes(y =  expr2), size = sizeDot,
  #            alpha = alphaDot,
  #            colour = grey90K, shape = 21) +
  # geom_point(aes(y =  expr3), size = sizeDot,
  #            alpha = alphaDot,
  #            colour = grey90K, shape = 21) +
  # geom_point(aes(y =  expr4), size = sizeDot,
  #            alpha = alphaDot,
  #            colour = grey90K, shape = 21) +
  # geom_point(aes(y =  expr5), size = sizeDot,
  #            alpha = alphaDot,
  #            colour = grey90K, shape = 21) +
  # geom_point(aes(y =  expr6), size = sizeDot,
  #            alpha = alphaDot,
  #            colour = grey90K, shape = 21) +
  # geom_segment(aes(yend = 0, y =  expr), 
               # # size = 0.2,
               # colour = grey50K) +
  geom_linerange(aes(colour = expr, 
                 ymin = lb, ymax = ub),
                 size = 1,
             alpha = 0.6) +
    geom_point(aes(y = expr, ymin = lb, ymax = ub), 
             alpha = 1, size = sizeDot,
             colour = grey90K, shape = 21) +
  scale_fill_gradientn(colours = brewer.pal(9, 'YlGnBu')) +
  scale_colour_gradientn(colours = brewer.pal(9, 'YlGnBu')) +
  facet_wrap(~transcript) +
  theme_xgrid() +
  theme(axis.text.y = element_text(size = 10), 
        panel.border = element_rect(colour = grey90K, fill = NA, size = 0.2)) +
  coord_flip()



# with all points, banded -------------------------------------------------

ggplot(df_tidy, aes(x = muscle, xend = muscle,
                    fill = expr)) +
geom_point(aes(y = expr1), size = sizeDot,
           alpha = alphaDot,
           colour = grey90K, shape = 21) +
geom_point(aes(y =  expr2), size = sizeDot,
           alpha = alphaDot,
           colour = grey90K, shape = 21) +
geom_point(aes(y =  expr3), size = sizeDot,
           alpha = alphaDot,
           colour = grey90K, shape = 21) +
geom_point(aes(y =  expr4), size = sizeDot,
           alpha = alphaDot,
           colour = grey90K, shape = 21) +
geom_point(aes(y =  expr5), size = sizeDot,
           alpha = alphaDot,
           colour = grey90K, shape = 21) +
geom_point(aes(y =  expr6), size = sizeDot,
           alpha = alphaDot,
           colour = grey90K, shape = 21) +
# geom_segment(aes(yend = 0, y =  expr), 
# # size = 0.2,
# colour = grey50K) +
geom_linerange(aes(colour = expr, 
                   ymin = minExpr, 
                   ymax = maxExpr),
               size = 0.25,
               alpha = 1) +
  geom_point(aes(y = expr), 
             alpha = 1, size = sizeDot,
             colour = grey90K, shape = 21) +
  scale_fill_gradientn(colours = brewer.pal(9, 'YlGnBu')) +
  scale_colour_gradientn(colours = brewer.pal(9, 'YlGnBu')) +
  facet_wrap(~transcript) +
  theme_xgrid() +
  theme(axis.text.y = element_text(size = 10), 
        panel.border = element_rect(colour = grey90K, fill = NA, size = 0.2)) +
  coord_flip()


# gradient plot -----------------------------------------------------------
xWidth = 0.3

ggplot(df_tidy, aes(x = muscleID,
                    xend = muscleID + xWidth,
                    fill = expr)) +
  geom_rect(aes(ymin = lb, ymax = ub,
                xmin = muscleID,
                xmax= muscleID + xWidth),
            alpha = .7) +
  geom_segment(aes(y = expr, yend = expr),
               colour = grey90K) +
  facet_wrap(~transcript) +
  theme_xgrid() +
  scale_fill_gradientn(colours = brewer.pal(9, 'YlGnBu')) +
  coord_flip()


# all points, banded, hollow centers --------------------------------------


ggplot(df_tidy, aes(x = muscle, xend = muscle)) +
  geom_point(aes(y = expr1), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  geom_point(aes(y =  expr2), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  geom_point(aes(y =  expr3), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  geom_point(aes(y =  expr4), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  geom_point(aes(y =  expr5), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  geom_point(aes(y =  expr6), size = sizeDot,
             alpha = alphaDot,
             colour = grey90K, shape = 21) +
  # geom_segment(aes(yend = 0, y =  expr), 
  # # size = 0.2,
  # colour = grey50K) +
  geom_linerange(aes(colour = expr, 
                     ymin = minExpr, 
                     ymax = maxExpr),
                 size = 0.25,
                 alpha = 1) +
  geom_point(aes(y = expr, fill = expr), 
             alpha = 1, size = sizeDot,
             colour = grey90K, shape = 21) +
  scale_fill_gradientn(colours = brewer.pal(9, 'YlGnBu')) +
  scale_colour_gradientn(colours = brewer.pal(9, 'YlGnBu')) +
  facet_wrap(~transcript) +
  theme_xgrid() +
  theme(axis.text.y = element_text(size = 10), 
        panel.border = element_rect(colour = grey90K, fill = NA, size = 0.2)) +
  coord_flip()

