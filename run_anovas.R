# ANOVA procedure:
#   
#   1. replace any 0 expression data with the minimum expresion level (to avoid -Inf when log2-transform data)
#   2. log2-transform all data
#   3. Find all combinations of samples
#   4. Loop over those combinations of samples to run calc_anova, which loops over every gene to calculate the ANOVA q-values

run_anovas = function(geneExprData, 
                      n, # number of comparisons to make, e.g. n = 2 is for pairwise ANOVAs
                      gene_var,
                      min_expr = 1e-3, # minimum detectable expression.  All 0s replaced by min_expr.,
                      sd_thresh = 1e-6 # Threshold to assume that there's no variation within the tissues, so don't calculate the ANOVA.
) {
  
  source('calc_anova.R')
  
  sample_vars = sort(sample_vars) # Check that the muscles are in the proper order to match the tissues to the lookup table
  
  # (1) replace any 0s with minimum expression
  geneExpr = lapply(geneExprData, function(x) ifelse(x == 0, min_expr, x))
  
  # (2) log2 transform all expression data
  geneExpr = lapply(geneExpr, 
                    function(x) if(is.numeric(x)) {
                      log2(x)
                    } else {
                      x
                    }
  )
  
  geneExpr = as.data.table(geneExpr)
  
  # (3) Find all combinations of samples
  combMusc = combn(sample_vars, n)
  
  # (4) Prep result table
  num_obs = geneExpr %>% distinct_(gene_var) %>% nrow()
  anovas = matrix(data = NA, nrow = num_obs, ncol = ncol(combMusc))
  
  # add in a column with the gene name.
  anovas = data.frame(anovas) %>% bind_cols(data.frame(obs = geneExpr[[gene_var]][1:num_obs])) %>%
    rename_(.dots = setNames('obs', gene_var))
  
  # (4) loop over all combinations 
  for (i in 1:ncol(combMusc)) {
    samples = combMusc[,i]
    print(paste0('Calculating ANOVAs between ', paste(samples, collapse = ' & ')))
    
    # select only the samples for this particular iteration
    anovas[,i] = calc_anova(geneExpr[tissue %in% samples], gene_var, sd_thresh)
    colnames(anovas)[i] = paste(paste(samples, collapse = "."), "q", sep="_")
    
  }
  
  return(anovas)
  
}
