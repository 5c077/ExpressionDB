# global.R ----------------------------------------------------------------
# global.R is the starting point for an ExpressionDB app.
# It does the following things:
# 1. Imports in your data for expression levels, with replicates
# 2. Sets the names of samples within your data (for example, pancreas, liver, and kidney)
# 3. Loads (and installs, if needed) the necessary packages to create a Shiny app
# 4. Merges gene expression levels to ontology table
# 5. Calculates a few constants for later use.


# LINES YOU NEED TO CHANGE
# lines 26-50

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

# column name w/i `data_file` to ID unique observations (typically a gene name/id, or transcript name/id)
data_unique_id = 'gene' # !! MUST CONTAIN UNIQUE VALUES

# column names to use to merge the expression data to the ontology.
# Can be the same column as data_unique_id
data_merge_id = 'gene' # column within `data_file` to link to `go_file`
go_merge_id = 'gene_id_go' # column within `go_file` to link to `data_file`

# column within `go_file` that contains gene descriptions
go_gene_descrip = 'gene_description' 


# column within `go_file` (line #27) that contains gene ontology terms
ont_var = 'GO'

# Create lookup table for all the tissues in your samples
# List of tissues; add tissue names here. Example shown to match with sample_data.csv
# variable names of samples within your dataset

sample_vars = c('tissueA', 'tissueB')

# names you want displayed in the app. These must match the order of sample_vars.
sample_names = c('tissueA', 'tissueB')

# ********************** end of stuff you need to change **********************


# Optional things to change -- mostly aesthetics

# If you've already specified links to Entrez Gene website, specify its column here
entrez_var = 'geneLink'
entrez_link = 'http://www.ncbi.nlm.nih.gov/gene/?term='

# number of digits to display in expression values and q values. Q's displayed in scientific notation.
num_digits = 2

# number of plots to display in each page of the home page
nPlots = 25
nObsHeat = 50 # number of observations in heatmap

# color of the dots on the dot plot of the home page.
dot_color = '#5254a3'
accent_color = '#ce1256' # for PCA highlightinh

dot_size = 4 # size of dots in dot plots

min_expr = 1e-3 # minimum detectable expression.  All 0s replaced by min_expr. for log transformations and ANOVA calculations
sd_thresh = 1e-6 # standard deviation threshold for ANOVA calculation; if there's little difference in all the samples, don't calc ANOVA (no variation)

# [2] Import required libraries -----------------------------------------------

libraries = c('dplyr', 'tidyr', 'shiny', 'shinydashboard', 'stringr',
              'DT', 'heatmaply', 'ggplot2', 'dtplyr',
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
library('dplyr')
library('tidyr')
library('shiny') 
library('shinydashboard')
library('stringr')
library('DT')
library('heatmaply') 
library('ggplot2')
library('dtplyr')
library('data.table')
library('RColorBrewer')

# [3] Import user-specified data set -----------------------------

# Check if prep_data has already been called.
if(length(setdiff(c('go_terms.rds', 'expr_db.rds'), list.files(path = data_dir))) > 0) {
  source('prep_data.R')
  
  # If the data hasn't been converted to an R data object, run the prep_data script
  imported_data = prep_data(data_file = paste0(data_dir, data_file), 
                            go_file = paste0(data_dir, go_file),
                            sample_vars = sample_vars,
                            data_unique_id = data_unique_id,
                            data_merge_id = data_merge_id,
                            go_merge_id = go_merge_id,
                            go_gene_descrip = go_gene_descrip,
                            ont_var = ont_var,
                            entrez_var = entrez_var,
                            entrez_link = entrez_link,
                            export_dir = data_dir,
                            num_digits = num_digits,
                            min_expr = min_expr,
                            sd_thresh = sd_thresh)
  
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

# More aesthetics
comparison_palette = brewer.pal(10, 'RdYlBu') # series of hexadecimal colors for comparison dot plot color scale
heatmap_palette = magma(n = 256) # series of hexadecimal colors for heatmap color scale


grey90K = '#414042'
grey60K = '#808285'

# look of the ggplot plots (main dot plot, comparison)
theme_xOnly = function(textSize) {
  theme(title = element_text(size = 32, color = grey90K),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_text(size = textSize, color = grey60K),
        axis.text.y = element_text(vjust = 0.1),
        axis.title.x = element_text(size = 19, color = grey60K), 
        axis.title.y = element_blank(), 
        legend.position="none",
        panel.border = element_rect(colour = grey90K, size = 0.25, fill = NA),
        panel.grid.major = element_line(color = grey60K, size = 0.2),
        panel.grid.major.y = element_blank(),
        panel.spacing = unit(15, units = 'points'),
        panel.background = element_blank(), 
        strip.text = element_text(size = 13, face = 'bold', color = grey60K),
        strip.background = element_blank()
  )
}


# look of the ggplot PCA plot
theme_xy = function(textSize) {
  theme(title = element_text(size = 32, color = grey90K),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_text(size = textSize, color = grey60K),
        axis.text.y = element_text(vjust = 0.1),
        axis.title.x = element_text(size = 19, color = grey60K), 
        axis.title.y = element_blank(), 
        legend.position="none",
        panel.border = element_rect(colour = grey90K, size = 0.25, fill = NA),
        panel.grid.major = element_line(color = grey60K, size = 0.2),
        panel.spacing = unit(15, units = 'points'),
        panel.background = element_blank(), 
        strip.text = element_text(size = 13, face = 'bold', color = grey60K),
        strip.background = element_blank()
  )
}



