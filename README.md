# About ExpressionDB
ExpressionDB is an open source, [Shiny](https://shiny.rstudio.com/)-based application for exploring, visualizing, and sharing gene expression data with minimal coding required. Users can create a copy of the application, add in their own RNA-seq or microarray expression data, and deploy it locally or on a server. Built-in visualization tools include dot plots, heatmaps, volcano plots, and principal component analysis, in addition to capabilities for users to dynamically filter by gene name, gene symbol, gene description, gene ontologies, tissue type, and expression level. All of the scripts for building an ExpressionDB with user-supplied data are freely available on this website, and the Creative Commons license ([CC-BY-SA](https://creativecommons.org/licenses/by-sa/4.0/)) allows fully open customization by end-users.

## Sample Database
Using ExpressionDB, we built a customized version to share [RNA-seq expression data of muscle tissues](http://muscledb.org/). 

## Getting Started
After downloading this [repository](https://github.com/5c077/ExpressionDB/archive/master.zip), [R](https://cran.r-project.org/), and [RStudio](https://www.rstudio.com/products/rstudio/download/), you can launch the ExpressionDB app in RStudio with a sample dataset. Full instructions are available on our [Wiki page](https://github.com/5c077/ExpressionDB/wiki/Getting-Started). 

## Customizing with Your Own Data
To add in your own data, view instructions on our [Wiki page](https://github.com/5c077/ExpressionDB/wiki/User's-Guide).

## Questions?
[Post an issue](https://github.com/5c077/ExpressionDB/issues/new) on the ExpressionDB GitHub page.

### Required dependencies:
* data.table version 1.10.4
* dplyr version 0.7.2
* DT version 0.2             
* dtplyr version 0.0.2         
* ggplot2 version 2.2.1
* heatmaply version 0.10.1         
* RColorBrewer version 1.1-2
* shiny version 1.0.3         
* shinydashboard version 0.6.1
* stringr version 1.2.0    
* tidyr version 0.6.3
