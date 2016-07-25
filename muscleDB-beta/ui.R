# Define sidebar for inputs -----------------------------------------------

sidebar <- dashboardSidebar(
  
  # -- Gene filtering --
  # Search form for symbols
  sidebarSearchForm(label = "search symbol (Myod1)", "geneInput", "searchButton"),
  
  # Search form for ontology
  # sidebarSearchForm(label = "search ontology (axon)", "GO", "searchButton"),
  selectizeInput('GO', label = 'search ontology', 
                 choices = NULL, 
                 multiple = FALSE, 
                 options = list(maxOptions = 500,
                                placeholder = 'search ontology',
                                onInitialize = I('function() { this.setValue(""); }'))),
  
  # -- Muscle filtering --
  checkboxGroupInput("muscles","muscle type", inline = FALSE,
                     choices = tissueList,
                     selected = allTissues),
  
  # Conditional for advanced filtering options.
  checkboxInput("adv", "advanced filtering", value = FALSE),
  conditionalPanel(
    condition = "input.adv == true",
    
    # -- Expression filtering. --
    HTML("<div style = 'padding-left:1em; color:#00b3dd; font-weight:bold'>
      expression level </div>"),
    fluidRow(column(6,
                    numericInput("minExprVal", "min:", 0,
                                 min = 0, max = maxInit)),
             column(6,
                    numericInput("maxExprVal", "max:", 
                                 value = maxInit, min = 0, max = maxInit))),
    
    # -- fold change. --
    HTML("<div style = 'padding-left:1em; color:#00b3dd; font-weight:bold'> fold change </div>"),
    helpText(em(HTML("<div style= 'font-size:10pt; padding-left:1em'> 
        Filters by the increase in expression, 
                         relative to a single muscle tissue</div>"))),
    radioButtons("ref", label = "reference tissue:", 
                 choices = c('none',tissueList), selected = "none"),
    numericInput("foldChange", label = 'fold change threshold', min = 0, value = 1, step = 0.5, width="100%"),
    
    # -- q-value. --
    HTML("<div style = 'padding-left:1em; color:#00b3dd; font-weight:bold'>
      q value </div>"),
    fluidRow(column(6,
                    numericInput("qVal", "maximum q value:", 0,
                                 min = 0, max = 1, value = 1)))
  ),
  
  # -- Sidebar icons --
  sidebarMenu(
    # Setting id makes input$tabs give the tabName of currently-selected tab
    id = "tabs",
    menuItemOutput("minExprInput"),
    menuItemOutput("maxExprInput"),
    menuItem("plot", tabName = "plot", icon = icon("bar-chart")),
    menuItem("table", tabName = "table", icon = icon("table")),
    menuItem("volcano plot", tabName = "volcano", icon = icon("ellipsis-v")),
    menuItem("heat map", tabName = "heatMap", icon = icon("th", lib = "glyphicon")),
    menuItem("PCA", tabName = "PCA", icon = icon("arrows")),
    menuItem("compare genes", tabName = "compare", icon = icon("line-chart")),
    menuItem("code", tabName = "code", icon = icon("code"))
  )
)



# Header ------------------------------------------------------------------
header <- dashboardHeader(
  title = "MuscleDB (beta)",
  # -- Message bar --
  dropdownMenu(type = "messages", badgeStatus = NULL, icon = icon("question-circle"),
               messageItem("Muscle Transcriptome Atlas",
                           "about the database",
                           icon = icon("bar-chart"),
                           href="http://flaneuse.github.io/muscleDB/about.html"
               ),
               messageItem("Need help getting started?",
                           "click here", icon = icon("question-circle"),
                           href="http://flaneuse.github.io/muscleDB/help.html"
               ),
               messageItem("Website code and data scripts",
                           "find the code on Github", icon = icon("code"),
                           href = "https://github.com/flaneuse/muscleDB")
  )
)



# Body --------------------------------------------------------------------

body <- dashboardBody(
  
  # -- Import custom CSS --
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "customStyle.css"),
    includeScript("google-analytics.js")), # -- Include Google Analytics file --
  
  # -- Each tab --
  tabItems(
    
    # -- Basic plot -- 
    tabItem(tabName = "plot", 
            fluidRow(h5("MuscleDB is a database containing RNAseq expression
                        levels for mouse muscle tissues.")),
            fluidRow(h6("Explore the database by filtering the data on the toolbar 
                        at the left and with different visualizations on the bottom left. 
                        Need help getting started? See our help page.")),
            fluidRow(column(2, fluidRow(actionButton("prevPage", label="", icon = icon("chevron-left")))),
                     column(4, fluidRow(h5('view next results'))),
                     column(2, 
                            fluidRow(actionButton("nextPage", label="", icon = icon("chevron-right"))))),
            plotOutput("plot1", height = "1000px")),
    
    
    # -- Full table with mini-stats. --
    tabItem(tabName = "table",
            
            # fluidRow(pageruiInput('pager', page_current = 1, pages_total = 1)),
            # valueBoxes of min, max, avg.
            fluidRow(
              infoBoxOutput("maxExpr", width = 4),
              infoBoxOutput("avgExpr", width = 4),
              # infoBoxOutput("minExpr", width = 4),
              
              # Download data button
              column(1,
                     downloadButton('downloadTable', label = NULL, 
                                    class = 'btn btn-lg active btn-inverted hover btn-inverted'),
                     h5(""))),
            #           actionButton("saveRowsTable", "save rows",
            #                        icon = NULL)
            #     infoBox("dwndTable", downloadLink('downloadTable'), icon = icon("download"), width = 1)
            
            
            # Main table
            fluidRow(
              div(dataTableOutput("table"), style = "font-size:80%")),
            
            # Summary stats @ bottom of table
            fluidRow(
              box(title = "Summary Statistics", solidHeader = TRUE, status = 'primary', width = 12,
                  dataTableOutput("summaryTable")))),
    
    
    # -- Volcano plot --
    tabItem(tabName = "volcano", 
            fluidRow(h4('Select two tissues to compare.')),
            fluidRow(column(4, uiOutput('m1')),
                     column(4, uiOutput('m2'))),
            fluidRow(plotOutput("volcanoPlot", 
                                dblclick = "volcanoDblclick",
                                brush = brushOpts(
                                  id = "volcanoBrush",
                                  resetOnNew = TRUE
                                ))),
            fluidRow(column(10, dataTableOutput("volcanoTable")),
                     column(1, 
                            fluidRow(br()),
                            fluidRow(br()),
                            fluidRow(br()),
                            fluidRow(br()),
                            # fluidRow(actionButton('saveVolcano', 'save selected rows')),
                            fluidRow(br())))),
    # fluidRow(downloadButton('csvVolcano', 'save to .csv'))))),    
    # -- PCA --
    tabItem(tabName = "PCA",
            fluidRow(h4('Principal Components of Selected Tissues')),
            fluidRow(column(5,
                            plotOutput("pcaPlot", 
                                       click = "pcaDblclick",
                                       brush = brushOpts(
                                        id = "pcaBrush",
                                        resetOnNew = TRUE)),
                            dataTableOutput("PCAload")),
                     column(4,
                            infoBoxOutput("PCAstats", width = 12),
                            helpText('Zoom on a region by highlighting the graph and double clicking'),
                            helpText('Highlight a point on the graph by clicking a row in the table'),
                            dataTableOutput("PCApts")))),
    
    
    # -- Compare genes --
    tabItem(tabName = "compare",
            fluidRow(column(3, uiOutput('g1')), # selectize input to select the ref. tissue
                     column(6, radioButtons("sortBy", label = 'sort by',
                                            choices = c('most similar' = 'most', 
                                                        'least similar' = 'least', 
                                                        'alphabetically' = 'alpha'), 
                                            selected = 'most',
                                            inline = TRUE))),
            fluidRow(column(2, fluidRow(actionButton("prevComp", label="", icon = icon("chevron-left")))),
                     column(4, fluidRow(h5('view next results'))),
                     column(2, 
                            fluidRow(actionButton("nextComp", label="", icon = icon("chevron-right"))))),
            fluidRow(plotOutput("compPlot", height = "1500px"))),
    
    # -- Heat map --
    tabItem(tabName = "heatMap", 
            fluidRow(column(2, fluidRow(actionButton("prevPageHeat", label="", icon = icon("chevron-left")))),
                     column(2, fluidRow(h5('view next 100 results'))),
                     column(2, 
                            fluidRow(actionButton("nextPageHeat", label="", icon = icon("chevron-right"))))),
            fluidRow(column(7,
                            d3heatmapOutput("heatmap",
                                            width = 500,
                                            height = 550)),
                     column(5,
                            selectInput("scaleHeat", label = "heat map scaling",
                                        choices = c("none" = "none", "by row" = "row", 
                                                    "by column" = "col", "log" = "log")),
                            checkboxInput("orderHeat", label = "group genes by similarity?", value = FALSE)
                     ))
            # fluidRow(plotOutput("heatmapScale"))
    ),
    
    # -- Code --
    tabItem(tabName = "code",
            source("abtCode.R", local = TRUE))
  ))



# Dashboard definition (main call) ----------------------------------------

dashboardPage(
  title = "MuscleDB: A muscle transcriptome atlas",  
  header,
  sidebar,
  body
)