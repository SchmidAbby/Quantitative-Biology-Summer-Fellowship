# QBio Fellowship -- Week 3 
# Multiple Correspondence Analysis (MCA)
# http://www.sthda.com/english/articles/31-principal-component-methods-in-r-practical-guide/
#                  114-mca-multiple-correspondence-analysis-in-r-essentials/#mca-data-format

library(ggplot2)
library("FactoMineR")
library("factoextra")

# data prep -- importing and cleaning 
gc_summary <- read.table("path_to_file.txt", sep = "\t", header = TRUE)
layers <- read.table("other_file.txt", sep = "\t", header = TRUE)
combined_data <- merge(gc_summary, layers, by.x="genome_name", by.y="item", all=TRUE)
combined_data$COG_CATEGORY <- substr(combined_data$COG_CATEGORY, 1, 1)
combined_data$COG_CATEGORY <- as.factor(combined_data$COG_CATEGORY)
vars <- c("unique_id", "genome_name", "gene_callers_id", "gene_cluster_id", "COG_CATEGORY")


active_data <- combined_data[vars]
row.names(active_data) <- active_data[,1]
active_data[,1] <- NULL

active_data["gene_callers_id"] <- as.factor(active_data$gene_callers_id)


res_mca <- MCA(active_data, quali.sup = c(1,3), graph = FALSE)

# Supplementary qualitative variable categories
res_mca$quali.sup

fviz_mca_biplot(res_mca, ggtheme = theme_minimal(), invisible = "quali.sup")

fviz_mca_var(res_mca, choice = "mca.cor")

fviz_mca_var(res_mca, ggtheme= theme_minimal())

fviz_mca_var(res_mca, invisible = "quali.sup")

fviz_mca_var(res_mca, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             ggtheme = theme_minimal())

fviz_mca_ind(res_mca, 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             ggtheme = theme_minimal())

fviz_mca_ind(res_mca, 
             label = "none", # hide individual labels
             habillage = "gene_cluster_id", # color by groups 
             ggtheme = theme_minimal()) 

