# The server.R file creates the server side of the Shiny App.
# This Shiny App was written and mintained by Kasun Buddika to distribute 
# analyzed data for EBio.

## Load required libraries
library(DT)
library(ggiraph)
library(tidyverse)

## Data import and pre-processing
primerReads <- read_csv("data/primer_Counts.csv")
names(primerReads) <-c("Dataset", "Raw Read Count", "Reads With Primer")

gRNACounts <- read_csv("data/gRNA_Counts.csv") %>%
  select(2:8)
datasets <- colnames(gRNACounts)

function(input, output, session) {
  
  ## Enable switching between datasets
  updateSelectInput(session,
                    "select_data_plot",
                    choices = c("Raw Read Count",
                                "With Primer Count",
                                "% Count")
  )
  
  ## Enable downloading data tables
  output$download_datatables <- downloadHandler(
    filename = function() {
      paste0(Sys.Date(), "_primer_data.csv")
    },
    content = function(file) {
      primerReads %>%
        write_csv(file)
    }
  )
  
  ## Render data tables with the DT package
  output$primerData <- renderDT({
    primerReads %>%
      datatable(rownames = FALSE) %>%
      DT::formatStyle(1:3, color="black")
  })

  ## Render plots for visualization
  output$plot <- renderPlot({
    
    if (input$select_data_plot == "Raw Read Count"){
      primerReads %>%
        ggplot(aes(x = Dataset, y = `Raw Read Count`)) +
        geom_bar(stat = "identity", fill = "#D55E00") +
        theme_bw() +
        coord_flip() +
        ggtitle("Raw Read Count") +
        scale_y_continuous(labels = scales::scientific)
    }
    
    else if (input$select_data_plot == "With Primer Count"){
      primerReads %>%
        ggplot(aes(x = Dataset, y = `Reads With Primer`)) +
        geom_bar(stat = "identity", fill = "#CC79A7") +
        theme_bw() +
        coord_flip() +
        ggtitle("Primer Containing Read Count") +
        scale_y_continuous(labels = scales::scientific) 
    }
    
    else {
      rearrData <- primerReads %>%
        mutate(No_Primer = `Raw Read Count` - `Reads With Primer`) %>%
        gather(key = Primer, 
               value = Counts, 
               c(`Reads With Primer`:No_Primer))

      rearrData %>%
        ggplot(aes(x = Dataset, y = Counts, fill = Primer)) +
        geom_bar(stat = "identity", position="fill") +
        theme_bw() +
        scale_fill_manual(values = c("#1B9E77", "#7570B3")) +
        coord_flip() +
        ggtitle("Grouped Read Count") +
        theme(legend.position="bottom") +
        ylab("% Count")
    }
  })
  
  updateSelectInput(session,
                    "select_sgRNA_plot",
                    choices = datasets[-1]
  )
  
  output$download_sgRNAdatatables <- downloadHandler(
    filename = function() {
      paste0(Sys.Date(), "_gRNA_data.csv")
    },
    content = function(file) {
      gRNACounts %>%
        write_csv(file)
    }
  )
  
  output$sgRNAData <- renderDT({
    gRNACounts %>% 
      datatable(rownames = FALSE)
  })
  
  output$sgRNAplot <- renderPlot({
    
    if (input$select_sgRNA_plot == datasets[2]){

      gRNACounts %>%
        select(1:2) %>%
        arrange(desc(SRR10384085.fastq)) %>%
        slice_head(n = 10) %>%
        mutate(gRNA = factor(gRNA, gRNA)) %>%
        ggplot(aes(reorder(gRNA, SRR10384085.fastq), y = SRR10384085.fastq)) +
        geom_col(fill = "#1B9E77") +
        theme_bw() +
        coord_flip() +
        ggtitle(str_glue("Most abundant sgRNAs: SRR10384085.fastq")) +
        ylab("Number of reads with sgRNA") +
        xlab("sgRNA sequence")
    }
    
    else if (input$select_sgRNA_plot == datasets[3]){
      gRNACounts %>%
        select(c(1,3)) %>%
        arrange(desc(SRR10384086.fastq)) %>%
        slice_head(n = 10) %>%
        ggplot(aes(x = reorder(gRNA, SRR10384086.fastq), y = SRR10384086.fastq)) +
        geom_col(fill = "#D95F02") +
        theme_bw() +
        coord_flip() +
        ggtitle(str_glue("Most abundant sgRNAs: SRR10384086.fastq")) +
        ylab("Number of reads with sgRNA") +
        xlab("sgRNA sequence")
    }
    
    else if (input$select_sgRNA_plot == datasets[4]){
      gRNACounts %>%
        select(c(1,4)) %>%
        arrange(desc(SRR10384087.fastq)) %>%
        slice_head(n = 10) %>%
        ggplot(aes(x = reorder(gRNA, SRR10384087.fastq), y = SRR10384087.fastq)) +
        geom_col(fill = "#7570B3") +
        theme_bw() +
        coord_flip() +
        ggtitle(str_glue("Most abundant sgRNAs: SRR10384087.fastq")) +
        ylab("Number of reads with sgRNA") +
        xlab("sgRNA sequence")
    }
    
    else if (input$select_sgRNA_plot == datasets[5]){
      gRNACounts %>%
        select(c(1,5)) %>%
        arrange(desc(SRR10384088.fastq)) %>%
        slice_head(n = 10) %>%
        ggplot(aes(reorder(gRNA, SRR10384088.fastq), y = SRR10384088.fastq)) +
        geom_col(fill = "#E7298A") +
        theme_bw() +
        coord_flip() +
        ggtitle(str_glue("Most abundant sgRNAs: SRR10384088.fastq")) +
        ylab("Number of reads with sgRNA") +
        xlab("sgRNA sequence")
    }
    
    else if (input$select_sgRNA_plot == datasets[6]){
      gRNACounts %>%
        select(c(1,6)) %>%
        arrange(desc(SRR10384089.fastq)) %>%
        slice_head(n = 10) %>%
        ggplot(aes(reorder(gRNA, SRR10384089.fastq), y = SRR10384089.fastq)) +
        geom_col(fill = "#E6AB02") +
        theme_bw() +
        coord_flip() +
        ggtitle(str_glue("Most abundant sgRNAs: SRR10384089.fastq")) +
        ylab("Number of reads with sgRNA") +
        xlab("sgRNA sequence")
    }
    
    else {
      gRNACounts %>%
        select(c(1,7)) %>%
        arrange(desc(SRR10384090.fastq)) %>%
        slice_head(n = 10) %>%
        ggplot(aes(reorder(gRNA, SRR10384090.fastq), y = SRR10384090.fastq)) +
        geom_col(fill = "#666666") +
        theme_bw() +
        coord_flip() +
        ggtitle(str_glue("Most abundant sgRNAs: SRR10384090.fastq")) +
        ylab("Number of reads with sgRNA") +
        xlab("sgRNA sequence")
    }
    
  })
}