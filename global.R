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


data <- read.csv("user_data.csv")
  if exists(data) == FALSE
  data_all<-read.csv("quant.csv")
  annot_all<-read.csv("annot.csv")
  data <- dplyr::left_join(data_all,annot_all,by="gene")
  end

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
