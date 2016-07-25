ANOVAlookupTable <- function (geneExprFileName, 
                              numRep = 6, 
                              muscles = c('AOR', 'ATR', 'DIA', 'EDL', 'EYE', 
                                          'LV', 'RV', 'SOL', 'TON', 'TA',
                                          'AA', 'FDB', 'MAS', 'PLA'),
                              n = 2,  # Starting point for comparison.
                              onlyPairwise = FALSE) {
  
  source("calcANOVA.r")
  
  print('Starting ANOVA calculation.')
  
  # Read in file
  print('Reading in file... this will take a second.')
  geneExpr = as.matrix(read.csv(geneExprFileName, row.names=1))
  
  print('... done!  Let the calculation begin.')
  
  # Define the muscle tissues to be examined.
  muscles = sort(muscles) # Check that the muscles are in the proper order to match the tissues to the lookup table
  
  numMuscles = length(muscles)
  
  # Initialize data frame containing all the values.
  if (onlyPairwise) {
    numCombs = choose(numMuscles,n) * 2
  } else {
    numCombs = (2^numMuscles - numMuscles - 1) * 2 # Since not calculating the ANOVA of a single tissue...
    
  }
  
  ANOVAvals = matrix(data=NA,nrow = nrow(geneExpr), ncol= numCombs)
  colnames(ANOVAvals) = rep(" ",numCombs)
  rownames(ANOVAvals) = rownames(geneExpr)
  counter = 1
  
  for (i in n:numMuscles) {
    # Update console so you know where you're at in the loop.
    print(paste("Finding all combinations of", i, "(of", numMuscles, ") ..."))
    print(paste("Counter is at", counter, "of", numCombs))
    
    # find all the combinations of possibilities; each column is the group of muscles to sample.
    combMusc = combn(muscles, i)
    
    for (j in 1:ncol(combMusc)) {
      # Update console so you know where you're at in the loop.
      print(paste("Calculating ANOVA for",paste(combMusc[,j], collapse = "-")))
      
      # Calculate p- and q-values.
      PQvals = calcANOVA(combMusc[,j], geneExpr, numRep)
      
      # Save p-values
      ANOVAvals[,counter] = PQvals$p 
      # Rename the column to be the muscle tissue names, concatanated together.
      colnames(ANOVAvals)[counter] <- paste(paste(combMusc[,j], collapse = "-"), "p", sep="_")
      counter = counter + 1
      
      # Save q-values
      ANOVAvals[,counter] = PQvals$q
      colnames(ANOVAvals)[counter] <- paste(paste(combMusc[,j], collapse = "-"), "q", sep="_")
      counter = counter + 1
      
      
      if (! j%%5) {
        # Save a temp version each time a set of comparisons is done.
        saveRDS(ANOVAvals, "temp_allPQ.rds")
        write.csv(ANOVAvals, "temp_allPQ.csv")
      }
    }
    
    
  }
  
  return(ANOVAvals)
}