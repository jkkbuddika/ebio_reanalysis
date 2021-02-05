# The ui.R file creates the user interface of the Shiny App.
# This Shiny App was written and mintained by Kasun Buddika to distribute 
# analyzed data for EBio.

## Load required libraries
library(DT)
library(ggiraph)
library(tidyverse)
library(shinycustomloader)
library(shinythemes)

navbarPage(
  theme = shinytheme("yeti"),
  "Reanalyzed Data for EBio",
  
  tabPanel(
    ## Home page
    "Home",
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          "This Shiny App has been written and deployed by", strong("Kasun Buddika"), 
          "to distribute reanalyzed data from",
          a(href = "https://www.nature.com/articles/s41592-020-0826-8",
            "Wheeler et al. 2020", style = "color: darkgreen"), ", a study 
          published in Nature Methods.",
          "Developed by Gene Yeo's group at UCSD, this novel method, CRaft-ID 
      (CRISPR-based microRaft followed by guide RNA identification), combines 
      pooled CRISPR–Cas9 screening with microraft array technology and
      high-content imaging to screen image-based phenotypes. For more details,
      read the abstract to the right.",
          style = "background: #E6E6FA"
        ),
        mainPanel(
          h4(strong("Pooled CRISPR screens with imaging on microraft arrays reveals 
      stress granule-regulatory factors")),
          "Genetic screens using pooled CRISPR-based approaches are scalable and 
      inexpensive, but restricted to standard readouts, including survival, 
      proliferation and sortable markers. However, many biologically relevant 
      cell states involve cellular and subcellular changes that are only 
      accessible by microscopic visualization, and are currently impossible to 
      screen with pooled methods. Here we combine pooled CRISPR–Cas9 screening 
      with microraft array technology and high-content imaging to screen 
      image-based phenotypes (CRaft-ID; CRISPR-based microRaft followed by guide 
      RNA identification). By isolating microrafts that contain genetic clones 
      harboring individual guide RNAs (gRNA), we identify RNA-binding proteins 
      (RBPs) that influence the formation of stress granules, the punctate 
      protein–RNA assemblies that form during stress. To automate hit 
      identification, we developed a machine-learning model trained on nuclear 
      morphology to remove unhealthy cells or imaging artifacts. In doing so, 
      we identified and validated previously uncharacterized RBPs that modulate 
      stress granule abundance, highlighting the applicability of our approach 
      to facilitate image-based pooled CRISPR screens.",
          style = "background: #F0F8FF"
        )
      ))),
  
  ## Primer data page
  tabPanel(
    "Primer Data",
    fluidPage(
      tabsetPanel(
        tabPanel(
          "Description",
          br(),
          wellPanel(
            "The deviced CRaft-ID approach requires a high-throughput two-step 
            PCR-based sequencing approach to definitively identify the gRNA and 
            hence the affected gene(s) in each microRaft. Therefore, it is 
            important to quantify the reads originating from proper PCR 
            amplification. This page summarises, details about library sizes 
            and the number of reads with primers in each library. You can 
            download spreadsheets and also take a look at graphical 
            representations of this data in next two tabs.",
            style = "background: #FFFFE0"
          )),
        tabPanel(
          "Table View", 
          br(),
          downloadButton(
            "download_datatables",
            "Download Data"
          ),
          hr(),
          DTOutput("primerData")
          ),
        tabPanel(
          "Graphical View", 
          br(),
          sidebarLayout(
            sidebarPanel(
              selectInput(
                "select_data_plot",
                label = h5(strong("Select a Plot")),
                choices = NULL),
              style = "background: #FFEFD5"),
            
            mainPanel(
              withLoader(plotOutput("plot"))),
          )
      )))),
  
  ## gRNA data page
  tabPanel(
    "sgRNA Data",
    fluidPage(
      tabsetPanel(
        tabPanel(
          "Description",
          br(),
          wellPanel(
            "The next goal of the analysis is to identify the specific sgRNA(s) 
            in each microRaft. The analysis given in this page provides CSV 
            files summarizing the number of read counts with each sgRNA used 
            in the analysis. Also, a graphical view of the number of read counts 
            for top 10 sgRNAs are given. Proceed to subsequent tabs in this 
            page.",
            style = "background: #E0FFFF"
          )),
        tabPanel(
          "Table View", 
          br(),
          downloadButton(
            "download_sgRNAdatatables",
            "Download"
          ),
          hr(),
          DTOutput("sgRNAData")
        ),
        tabPanel(
          "Graphical View", 
          br(),
          sidebarLayout(
            sidebarPanel(
              selectInput(
                "select_sgRNA_plot",
                label = h5(strong("Pick a Plot")),
                choices = NULL),
              style = "background: #b8d5cd"),
            
            mainPanel(
              withLoader(plotOutput("sgRNAplot"))),
          )
        )))))