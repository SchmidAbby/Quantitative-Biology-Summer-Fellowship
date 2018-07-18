# hclust 
# cluster samples based on variables, do we get two clusters for malignant and benign

library(dendextend)
library(colorspace)
library(dplyr)

# Data from https://archive.ics.uci.edu/ml/datasets.html
bdata <- read.csv("Wisconsin_Breast_Cancers.csv", header = TRUE)

# calculating distances and dendrogram 
bdata_dist <- dist(bdata[,2:10], method = "euclidean")
clust <- hclust(bdata_dist, method = "average", members = NULL)
dend <- as.dendrogram(clust)

# color based on two groups (prediction of diagnosis)
group <- c("2","4")
dend <- color_branches(dend, k=2)
labels_colors(dend) <- rainbow_hcl(2)[sort_levels_values(group[order.dendrogram(dend)])]

#adding labels for actual point diagnosis 
dend2order <- order.dendrogram(dend)
bdata <- as.tbl(bdata)
dend2_classes <- pull(bdata[dend2order, 11])
labels_colors(dend) <- dend2_classes

#plotting 
  plot(dend, nodePar = list(cex = .007), main = "Clustering Breast Cancer Data")
  legend("topleft", legend = group, fill = rainbow_hcl(2))
