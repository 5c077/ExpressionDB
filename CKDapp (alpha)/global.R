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

data = read.csv('data_CKD_16-08-02.csv')

GO = readRDS("allOntologyTerms.rds")

# Set the maximum of the expression, for the limits on the expr widget.
maxInit = max(data$expr)

# List of tissues
shortName = list(
                  'wild-type' = 'wild-type',
                  'chronic kidney disease' = 'chronic kidney disease')

#allTissues = c('wild-type', 'chronic kidney disease')
               
#shortName <- c('wild-type' = 'WT', 'chronic kidney disease' = 'CKD')


# List of tissues
tissueList = list(
  #'total aorta' = 'total aorta',
  #'thoracic aorta' = 'thoracic aorta',
  #'abdominal aorta' = 'abdominal aorta',
  #'atria' = 'atria', 
  #'left ventricle' = 'left ventricle',
  #'right ventricle' = 'right ventricle',
  #'diaphragm' = 'diaphragm',
 # 'eye' = 'eye', 
#'EDL' = 'EDL', 
  #'FDB' = 'FDB', 
  #'masseter' =  'masseter',
  #'plantaris' = 'plantaris',
  #'soleus' = 'soleus',
  #'tongue' = 'tongue', 
'Chronic Kidney Disease' = 'CKD', 'Wild-Type' = 'WT')

allTissues = c(#'atria', 'left ventricle',
               #'total aorta', 'right ventricle',
               #'soleus', 
               #'thoracic aorta',
               #'abdominal aorta',
               #'diaphragm',
               #'eye', 'EDL', 'FDB', 
               #'masseter', 'tongue',
               #'plantaris', 
               'WT', 'CKD')

