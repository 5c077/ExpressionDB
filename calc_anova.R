
# calculates an ANOVA for each gene/transcript ---------------------------------------
# For every gene/transcript, calculate the ANOVA q-value for a detectable difference between 2 or more samples.

calc_anova = function(geneExpr, gene_var, sd_thresh) {
  genes = unique(geneExpr[[gene_var]])
  
  # pre-populate empty matrix:
  # 1 x number of genes
  
  anova_data = data.frame(p = rep(NA, length(genes)))
  # , obs = rep(NA, length(genes)))
  
  # loop over each transcript/gene
  for(i in 1:length(genes)) {
    # pull data for that gene
    expr = geneExpr[get(gene_var) == genes[i]]
    
    # calculate linear model
    lin_model = lm(expr ~ tissue, data = expr)
    
    # Pull out ANOVA value 
    if(sd(lin_model$residuals) > sd_thresh){
      # calc ANOVA
      d_anova = anova(lin_model)
      
      # pull out ANOVA value
      anova_val = d_anova$`Pr(>F)`[1]
      
    } else {
      anova_val =  NA
    }
    
    anova_data[i, 'p'] = anova_val
    
    # Display every 10,000 transcripts how many calcs have been done.
    if (! i%% 1000) {
      print(paste("completed ", i, " of ", length(genes), " ANOVA calcs."))
    }
  } # -- end of loop over genes
  
  anova_data = anova_data %>% mutate(q = p.adjust(p, method = "BH"))
  
  return(anova_data %>% select(-p))
  
}

