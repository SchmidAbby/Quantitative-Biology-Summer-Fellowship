# validation and testing on generated data 

library(ggplot2)
library(factoextra)
library(clustertend)
library(NbClust)
library(fpc)
library(grid)
library(gridExtra)

# generate dataset
set.seed(101)
x <- matrix(rnorm(100*7), 100, 7)
which <- sample(1:4, 100, replace = TRUE, prob = c(.3, .2, .35, .15))
xmean <- matrix(rnorm(5*7, sd = 2), 5, 7) # 4 clusters, 7 variables 
blob <- x + xmean[which, ]
blob <- as.data.frame(blob)
ggplot(data = blob) +
  geom_point(aes(x = V1, y = V2, color = as.factor(which)), alpha = 0.5)


# export dataset 
write.csv(blob, "blob.csv", sep = ",", row.names = TRUE, col.names = NA)
write.table(which, "which.csv", sep = ",")


# PCA, k-means, cool 
blob.kmeans <- kmeans(blob, 4, iter.max = 100)
blob.kmeans <- blob.kmeans$cluster
blobpca <- prcomp(blob)
blobpca2 <- as.data.frame(blobpca$x)
blobpca2$sample <- sapply(strsplit(as.character(row.names(blob)), "_"), "[[", 1)
blobpca2$kmeans <- blob.kmeans
blobpca2$actual <- which

percentage <- round(blobpca$sdev/sum(blobpca$sdev) * 100, 2)
percentage <- paste(colnames(blobpca2), "(", paste(as.character(percentage)), "%", ")", sep = "")

ggplot(data = blobpca2) +
  geom_point(aes(x = PC1, y = PC2, color = as.factor(kmeans), shape = as.factor(actual))) +
  xlab(percentage[1]) +
  ylab(percentage[2]) +
  labs(title = "PCA") +
  theme_classic()


# PCA 
fviz_pca_ind(prcomp(blob), title = "PCA - Generated Cluster Data", 
             geom = "point", ggtheme = theme_classic(), 
             palette = "jco", habillage = which)

# K-Means on Data
km.res <- kmeans(blob, 4, iter.max = 100)
fviz_cluster(list(data = blob, cluster = km.res$cluster),
             ellipse.type = "norm", geom = "point", stand = FALSE, ggtheme = theme_classic())

# Hierarchical clustering on the random dataset 
hc.res <- hclust(dist(blob))
fviz_dend(hc.res, k = 4, as.ggplot = TRUE, show_labels = FALSE)


# HOPKINS STATISTIC 
# using n = 120 to use about 20% of the points 
# Compute Hopkins statistic for actual dataset 
hopkins(blob, n = 10)


# VISUAL ASSESSMENT (VAT APPROACH)
fviz_dist(dist(blob), show_labels = FALSE)+ labs(title = "Breast Cancer data")

# all 30 indices
nb1 <- NbClust(blob, distance = "euclidean", min.nc = 2, max.nc = 10, method = "ward.D")
fviz_nbclust(nb1)

nb2 <- NbClust(blob, distance = "euclidean", min.nc = 2, max.nc = 10, method = "single")
fviz_nbclust(nb2)

nb3 <- NbClust(blob, distance = "euclidean", min.nc = 2, max.nc = 10, method = "complete")
fviz_nbclust(nb3)

nb4 <- NbClust(blob, distance = "euclidean", min.nc = 2, max.nc = 10, method = "average")
fviz_nbclust(nb4)

nb5 <- NbClust(blob, distance = "euclidean", min.nc = 2, max.nc = 10, method = "kmeans")
fviz_nbclust(nb5)

# tables 
table(which, km.res$cluster)


# DBSCAN 
dbscan::kNNdistplot(blob, k= 2) # use k = minpts - 1 

db <- fpc::dbscan(blob, eps = 3.25, MinPts = 3) 

fviz_cluster(db, data = blob, stand = FALSE, 
             ellipse = FALSE, show.clust.cent = FALSE, geom = "point", palette = "jco", ggtheme = theme_classic())
table(db$cluster)

# OPTICS
op <- dbscan::optics(blob, minPts = 3)
op
op$order
plot(op) # reachability plot

opd <- dbscan::extractDBSCAN(op, eps_cl = 7)
opd
opd$order
opd$cluster

