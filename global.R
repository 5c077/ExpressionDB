
# global.R ----------------------------------------------------------------
# global.R is the starting point for an ExpressionDB app.
# It does the following things:
# 1. Imports in your data for expression levels, with replicates
# 2. Sets the names of samples within your data (for example, pancreas, liver, and kidney)
# 3. Loads (and installs, if needed) the necessary packages to create a Shiny app
# 4. Merges gene expression levels to ontology table
# 5. Calculates a few constants for later use.


# LINES YOU NEED TO CHANGE
# line 26: input the name of your data file, surrounded by quotes
# line: input the name of your ontology file, surrounded by quotes

# STARTING THE APP
# To start the application, click the Green Arrow that says "Run App" in RStudio
# (located in the top right corner of this file)
# Or set the working directory to this folder and type "runApp()" at the command prompt



# [1] User-specified options -----------------------------------------------
# ********************** CHANGE THESE LINES **********************
# specify the path to your custom .csv data frame. 'sample_data.csv' 
# is an example data frame with sample data and all of the required fields.
data_file = 'sample_data.csv'
go_file = 'sample_ontologies.csv'
data_dir = 'data/' # location where the data are stored

data_gene_id = 'gene'
go_gene_id = 'gene'
go_gene_descrip = 'gene_description'
ont_var = 'GO'
entrez_var = 'geneLink'

# Create lookup table for all the tissues in your samples
# List of tissues; add tissue names here. Example shown!
# variable names of samples within your dataset
sample_vars = c('LV', 'SPL')

# names you want displayed in the app. These should match the order of sample_vars
sample_names = c('liver', 'spleen')


# [2] Import required libraries -----------------------------------------------

libraries = c('dplyr', 'tidyr', 'shiny', 'shinydashboard', 'stringr',
              'DT', 'd3heatmap', 'ggvis', 'ggplot2', 'dtplyr',
              'data.table', 'RColorBrewer')

# Built using: 
# * d3heatmap version 0.6.1.1  
# * data.table version 1.10.4
# * dplyr version 0.7.2
# * DT version 0.2             
# * dtplyr version 0.0.2         
# * ggplot2 version 2.2.1
# * ggvis version 0.4.3         
# * RColorBrewer version 1.1-2
# * shiny version 1.0.3         
# * shinydashboard version 0.6.1
# * stringr version 1.2.0    
# * tidyr version 0.6.3

# check if packages are installed; if not, install them
installed = row.names(installed.packages())

to_install = setdiff(libraries, installed)

lapply(to_install, function(x) install.packages(x))

# load packages
pk = lapply(libraries, function(x) library(x, character.only = TRUE))


# [3] Import user-specified data set -----------------------------

# Check if prep_data has already been called.
if(length(setdiff(c('go_terms.rds', 'expr_db.rds'), list.files(path = data_dir))) > 0) {
  source('prep_data.R')
  
  # If the data hasn't been converted to an R data object, run the prep_data script
  imported_data = prep_data(data_file = paste0(data_dir, data_file), 
                            go_file = paste0(data_dir, go_file),
                            sample_vars = sample_vars,
                            data_gene_id = data_gene_id,
                            go_gene_id = go_gene_id,
                            go_gene_descrip = go_gene_descrip,
                            ont_var = ont_var,
                            entrez_var = entrez_var,
                            entrez_link = entrez_link,
                            export_dir = data_dir)
  
  data = imported_data$df
  GOs = imported_data$go_terms
  
  gene_names = data[[go_gene_descrip]]
  
} else {
  # If the prep script has already been run, load the saved data
  data = readRDS(paste0(data_dir, "expr_db.rds"))
  
  GOs = readRDS(paste0(data_dir, "go_terms.rds"))
  
  gene_names = data[[go_gene_descrip]]
}





# [5] Pre-calculate constants -------------------------------------------------

# Set the maximum of the expression, for the limits on the expression widget.
maxInit = max(data$expr)
