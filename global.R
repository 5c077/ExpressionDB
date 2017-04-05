library(dplyr)
library(tidyr)
library(shiny)
library(shinydashboard)
library(DT)
library(d3heatmap)
library(ggvis)
library(ggplot2)
library(dtplyr)
library(data.table)
library(plotly)
library(RColorBrewer)



# Source javascript pagination code ---------------------------------------
# Forked from https://github.com/wleepang/shiny-pager-ui
# source('pagerui.R')

# Import user-specified data set -----------------------------

#specify the path to your custom .csv data frame. 'sample_data.csv' is an example data frame with sample data and all of the required fields.
data = read.csv("sample_data.csv")

GOs = readRDS("allOntologyTerms.rds")

# Set the maximum of the expression, for the limits on the expr widget.
maxInit = max(data$expr)

# List of tissues; add tissue names here. Example shown!
tissueList = list('pancreas' = 'pancreas','liver'='liver','kidney'='kidney'
                  )

allTissues = c('pancreas', 'liver',
               'kidney'
               )
# These are the tissues that will be selected initially -- when the application first starts up.
selTissues = c(
               'pancreas', 'liver', 'kidney'
               )
abbreviations = c('PAN', 'LIV', 'KID')