## Load required libraries
library(dplyr)
library(gridExtra)
library(rlang)
library(tidyverse)

## Import and preprocess read counts data
gRNACounts <- read_csv("data/gRNA_Counts.csv") %>%
  select(2:8)

# Modified bar plotter function
barPlotter <- function(inData, X, Y, fillColor){
  
  Y_col <- enquo(Y)
  X_col <- enquo(X)
  
  inData %>%
    select(c(!!X_col, !!Y_col)) %>%
    slice_max(!!Y_col, n=10) %>%
    mutate(!!X_col := fct_reorder(!!X_col, !!Y_col)) %>%
    ggplot(aes(x = !!X_col, y = !!Y_col)) +
    geom_col(fill = fillColor) +
    theme_bw() +
    coord_flip() +
    ggtitle(str_glue("Most abundant gRNAs: {quo_text(Y_col)}")) +
    ylab("Number of reads with gRNA")
}

p1 <- barPlotter(gRNACounts, gRNA, SRR10384085.fastq, "#1B9E77")
p1

p2 <- barPlotter(gRNACounts, gRNA, SRR10384086.fastq, "#D95F02")
p2

p3 <- barPlotter(gRNACounts, gRNA, SRR10384087.fastq, "#7570B3")
p3

p4 <- barPlotter(gRNACounts, gRNA, SRR10384088.fastq, "#E7298A")
p4

p5 <- barPlotter(gRNACounts, gRNA, SRR10384089.fastq, "#E6AB02")
p5

p6 <- barPlotter(gRNACounts, gRNA, SRR10384090.fastq, "#666666")
p6

## Save plots
pdf("data/Fig_2.pdf", width=12, height = 15)
grid.arrange(p1, p2, p3, p4, p5, p6, nrow = 3)
dev.off()
