library(dplyr)
library(tidyr)
library(shiny)
library(shinydashboard)
library(DT)
library(d3heatmap)
library(ggvis)
library(ggplot2)
# library(rCharts)
library(dtplyr)
library(data.table)
#library(llamar)
library(plotly)
library(RColorBrewer)



# Source javascript pagination code ---------------------------------------
# Forked from https://github.com/wleepang/shiny-pager-ui
# source('pagerui.R')

# Import in the Muscle Transcriptome database -----------------------------

# mt_source = src_sqlite('~/Dropbox/Muscle Transcriptome Atlas/Website files/data/expr_public_2015-11-08.sqlite3', create = FALSE)
# data = tbl(mt_source, 'MT')

data = readRDS('template.rds')
GOs = readRDS('data/allOntologyTerms.rds')

# Set the maximum of the expression, for the limits on the expr widget.
maxInit <- max(data$expr)


# List of tissues
tissueList = list(
'tissue A' = "tissue A", 'Tissue B' = 'Tissue B')

allTissues = c(
  
               'Tissue A', 'Tissue B')

