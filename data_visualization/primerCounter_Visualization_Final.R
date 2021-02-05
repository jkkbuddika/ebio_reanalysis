## Load required libraries
library(tidyverse)
library(gridExtra)

## Import and preprocess read counts data
primerReads <- read_csv("data/primer_Counts.csv")
names(primerReads) <-c("Dataset", "Raw_Count", "With_Primer")

## Bar plotter function
barPlotter <- function(inData, X, Y, fillColor, Title, labY){
  
  Y_col <- enquo(Y)
  X_col <- enquo(X)
  
  inData %>%
    select(c(!!X_col, !!Y_col)) %>%
    mutate(!!X_col := fct_reorder(!!X_col, !!Y_col)) %>%
    ggplot(aes(x = !!X_col, y = !!Y_col)) +
    geom_col(fill = fillColor) +
    theme_bw() +
    coord_flip() +
    ggtitle(str_glue(Title)) +
    ylab(labY) +
    scale_y_continuous(labels = scales::scientific)
}

## Plot total read count
p1 <- barPlotter(primerReads, Dataset, 
           Raw_Count, "#D55E00", "Raw Read Count", "Read Count")
p1

## Plot primer containing read count
p2 <- barPlotter(primerReads, Dataset, 
                Raw_Count, "#CC79A7", 
                "Primer Containing Read Count", "Read Count")
p2

## To make a grouped plot for better visualization
rearrData <- primerReads %>%
  mutate(No_Primer = Raw_Count - With_Primer) %>%
  gather(key = Primer, 
         value = Counts, 
         c(With_Primer:No_Primer))

## A grouped plot
p3 <- rearrData %>%
  ggplot(aes(x = Dataset, y = Counts, fill = Primer)) +
  geom_bar(stat = "identity", position="fill") +
  theme_bw() +
  scale_fill_manual(values = c("#1B9E77", "#7570B3")) +
  coord_flip() +
  ggtitle("Grouped Read Count") +
  theme(legend.position="bottom") +
  ylab("% Count")
p3

## Save plots
pdf("data/Fig_1.pdf", width=12, height = 6)
grid.arrange(p1, p2, p3, nrow = 2)
dev.off()
