# Using ExpressionDB
Test out Expression DB by customizing the app with different data sources.  
Here are some example datasets to try.

* For all of these examples, open ```global.R`` and change lines 26-50 to contain the following code.
* Navigate to the directory containing the ExpressionDB files, and set the working directory to this location (```setwd('mydir')```)
* Launch the app by typing ```shiny::runApp()``` at the command line, or by clicking the **Run App** button in Rstudio at the top right of the global.R file.
* The first time the code will run, it will import all the data, calculate average expression across replicates, calculate ANOVAs, and merge to gene ontology terms. This data will be saved in R .rds files, so you only have to load the cleaned data next time.
* However... that means if you want to change the input files, you need to delete ```expr_db.rds``` and ```go_terms.rds``` from the ```data``` folder.


## Sample 1: Subset of GETx data
``` 
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

# column within `go_file` that contains gene ontology terms
ont_var = 'GO'

# Create lookup table for all the tissues in your samples
# List of tissues; add tissue names here. Example shown to match with sample_data.csv
# variable names of samples within your dataset
sample_vars = c('tissueA', 'tissueB')

# names you want displayed in the app. These must match the order of sample_vars.
sample_names = c('tissueA', 'tissueB')
# ********************** end of stuff you need to change **********************
```

## Sample 2: Larger subset of GETx data
```
# [1] User-specified options -----------------------------------------------
# ********************** CHANGE THESE LINES **********************
# specify the path to your custom .csv data frame. 'sample_data.csv' 
# is an example data frame with sample data and all of the required fields.
data_file = 'data/sample_data2_getx.csv'
go_file = 'annot_expdb_human2017-08.csv'
data_dir = 'data/' # location where the data are stored

# column name w/i `data_file` to ID unique observations (typically a gene name/id, or transcript name/id)
data_unique_id = 'gene' # !! MUST CONTAIN UNIQUE VALUES

# column names to use to merge the expression data to the ontology.
# Can be the same column as data_unique_id
data_merge_id = 'gene' # column within `data_file` to link to `go_file`
go_merge_id = 'gene_id_go' # column within `go_file` to link to `data_file`

# column within `go_file` that contains gene descriptions
go_gene_descrip = 'gene_description' 

# column within `go_file` that contains gene ontology terms
ont_var = 'GO'

# Create lookup table for all the tissues in your samples
# List of tissues; add tissue names here. Example shown to match with sample_data.csv
# variable names of samples within your dataset
sample_vars = c('tissueA', 'tissueB')

# names you want displayed in the app. These must match the order of sample_vars.
sample_names = c('tissueA', 'tissueB')
# ********************** end of stuff you need to change **********************
```

## Sample 3: MuscleDB data
Mouse expression of muscle tissues from [MuscleDB](www.muscledb.org)

```
# ********************** CHANGE THESE LINES **********************
# specify the path to your custom .csv data frame. 'sample_data.csv' 
# is an example data frame with sample data and all of the required fields.
data_file = 'sample_data3_muscledb.csv'
go_file = 'annot_expdb_mouse2017-08.csv'
data_dir = 'data/' # location where the data are stored

# column name w/i `data_file` to ID unique observations (typically a gene name/id, or transcript name/id)
data_unique_id = 'transcript' # !! MUST CONTAIN UNIQUE VALUES

# column names to use to merge the expression data to the ontology.
# Can be the same column as data_unique_id
data_merge_id = 'gene' # column within `data_file` to link to `go_file`
go_merge_id = 'gene_id_go' # column within `go_file` to link to `data_file`

# column within `go_file` that contains gene descriptions
go_gene_descrip = 'gene_description' 

# column within `go_file` that contains gene ontology terms
ont_var = 'GO'

# Create lookup table for all the tissues in your samples
# List of tissues; add tissue names here. Example shown to match with sample_data.csv
# variable names of samples within your dataset
sample_vars = c('AOR', 'ATR', 'LV', 'RV')

# names you want displayed in the app. These must match the order of sample_vars.
sample_names = c('total aorta', 'atria', 'left ventricle', 'right ventricle')
# ********************** end of stuff you need to change **********************
```

## Sample 4: Mouse microarray data