# Week 1 -- data viz in R 

library(ggplot2)

for (REGION in c("A","B","C","D","E","F","G","H")){
  data_file <- paste("path", REGION, "summary.txt", sep="")
  DATA <- read.table(data_file, sep = "\t", header = TRUE)
  
  p <- ggplot(data=DATA, aes(x = DATA$gene_callers_id, y = DATA$num_genes_in_gene_cluster)) + 
    geom_boxplot(aes(group = DATA$gene_callers_id)) +
    scale_x_continuous(breaks = round(seq(min(DATA$gene_callers_id), max(DATA$gene_callers_id), by = 1),1)) +
    labs(x = "position", y = "number of genes in gene cluster")
  
  pdf(paste(REGION, "_R_boxplot.pdf", sep=""), width=16, height=9)
  print(p)
  dev.off()
}


