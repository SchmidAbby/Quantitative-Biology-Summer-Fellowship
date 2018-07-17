# hclust 
# cluster samples based on variables, do we get two clusters for malignant and benin

library(dendextend)
library(colorspace)

# Data from https://archive.ics.uci.edu/ml/datasets.html
bdata <- read.csv("Wisconsin_Breast_Cancers.csv", header = TRUE)

bdata_dist <- dist(bdata[,2:10], method = "euclidean")

clust <- hclust(bdata_dist, method = "ward.D", members = NULL)

diagnosis <- unique(bdata[,11])

dend <- as.dendrogram(clust)

dend <- color_branches(dend, k=2)

labels_colors(dend) <- rainbow_hcl(2)[sort_levels_values(diagnosis[order.dendrogram(dend)])]

pdf('breast_cancer_hclust_ward.pdf', width=16, height=10)
  plot(dend, nodePar = list(cex = .007), main = "Clustering Breast Cancer Data")
  legend("topleft", legend = diagnosis, fill = rainbow_hcl(2))
dev.off()
