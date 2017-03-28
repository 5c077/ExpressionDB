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

# Import in user-specified data set -----------------------------

#specify the path to your custom .csv data frame. 'blank_frame.csv' is an example data frame with all of the required fields left blank, of course.
data = read.csv('blank_frame.csv')

GOs = readRDS("allOntologyTerms.rds")

# Set the maximum of the expression, for the limits on the expr widget.
maxInit = max(data$expr)

# List of tissues; add tissue names here. Example shown!
tissueList = list('tissue1' = 'tissue1',
                'tissue2'='tissue2')

allTissues = c('tissue1', 'tissue2',
               'tissue3', 'tissue4'
               )
# These are the tissues that will be selected initially -- when the application first starts up.
selTissues = c(
               'tissue1', 'tissue2', 'tissue3'
               )
