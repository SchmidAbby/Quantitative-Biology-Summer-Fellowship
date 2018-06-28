# Week 1 -- data viz in R 

library(ggplot2)

for (CPS_REGION in c("A","B","C","D","E","F","G","H")){
  data_file <- paste("./synteny_plots_and_summary_tables/CP", CPS_REGION, "_NONREDUNDANT_gene_clusters_summary.txt", sep="")
  CPS_DATA <- read.table(data_file, sep = "\t", header = TRUE)
  
  p <- ggplot(data=CPS_DATA, aes(x = CPS_DATA$gene_callers_id, y = CPS_DATA$num_genes_in_gene_cluster)) + 
    geom_boxplot(aes(group = CPS_DATA$gene_callers_id)) +
    scale_x_continuous(breaks = round(seq(min(CPS_DATA$gene_callers_id), max(CPS_DATA$gene_callers_id), by = 1),1)) +
    labs(x = "position", y = "number of genes in gene cluster")
  
  pdf(paste("CP", CPS_REGION, "_R_boxplot.pdf", sep=""), width=16, height=9)
  print(p)
  dev.off()
}


