# About ExpressionDB
The collaborators behind [MuscleDB](https://github.com/flaneuse/muscleDB) have added Scott Lewis to the fold to spearhead a new branch in this project. Using the structure (skeleton) of MuscleDB, our objective is to establish a template intended to help researchers share and visualise their data on a user-friendly, web-based ShinyApps platform.
## Getting Started
ExprDB was built using the  “dplyr”, “tidyr”, “DT”, “d3heatmap”, “ggvis”, “ggplot2”, “dtplyr”, “data.table”, “plotly”, and “RColorBrewer” packages. You can install them with the install.packages(" ") command. These packages along with [RStudio](https://www.rstudio.com/) will need to be installed in order for ExprDB to work properly. 
## Formatting Your Data
User data will need to be formatted in order to be implemented into the ExprDB framework. 
Below is a list of the required vectors and their corresponding descriptions. Note: the names of these columns are case sensitive. 

expr 
> the quantitative expression level of the corresponding gene.

tissue 
> the name for the tissue or sample in which this gene was expressed.

SE 
> the standard error score of the corresponding gene expression replicates.

Sample1.sample2_q, sample1.sample3_q, etc 
> vectors of q scores calculated from every possible combination of gene expression sets. 

gene 
> the common, corresponding gene symbol
transcriptLink – the corresponding url that can be used to access additional information about a transcript in an external database (ucsc, etc..).

geneLink 
> the corresponding url that can be used to access additional information about a gene in an external database (ucsc, etc..).

shortName  
> the shortened form of a name for a gene. This may be a repetition of the “gene” vector, except genes without official symbols are given their unique database ID to be used as an identifier. 

GO 
> the corresponding ontology of a gene that can be used as a query tag later. A fair number are provided in the example data frame we have provided. Note that when a single gene has multiple ontologies, the ontologies are separated by a “|” character.

Save your dataframe as a .csv file and make sure it is stored in the same folder as ExprDB.

## Editing the Code
In order for the user interface to accurately represent the new user data, certain fields of the code will need to be edited. This can be done by simply opening the files in RStudio. The "Comments" that follow the # symbol will give detailed intructions of what to input and where to put it. These edits will be specific to the user data, which is why it is important that the user review the file and make these changes manually.  

Click [here](https://expressiondb.wordpress.com/) for a detailed user guide.
