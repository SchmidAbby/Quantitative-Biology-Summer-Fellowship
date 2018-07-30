# Clustering Week 3
# Cluster validation Techniques from "Practical guide to cluster analysis in R : unsupervised machine learning"

library(factoextra)
library(clustertend)
library(NbClust)
library(fpc)
library(ggplot2)

bdata <- read.csv("Wisconsin_Breast_Cancers.csv", header = TRUE)

# actual data 
df <- bdata[, -11]
df <- df[,-1]

########## Showing that even if data doesn't have an underlying clustered structure, one will be imposed ##########

# random data 
random_df <- apply(df, 2, function(x){runif(length(x), min(x), (max(x)))})
random_df <- as.data.frame(random_df)

# plot PCA actual data 
fviz_pca_ind(prcomp(df), title = "PCA - Breast Cancer data", habillage = bdata$Class,
             palette = "jco", geom = "point", ggtheme = theme_classic())

# plot PCA random data 
fviz_pca_ind(prcomp(random_df), title = "PCA - Random data", geom = "point", ggtheme = theme_classic())

# K-means on actual data set
km.res1 <- kmeans(df, 2) 
fviz_cluster(list(data = df, cluster = km.res1$cluster), 
             ellipse.type = "norm", geom = "point", stand = FALSE, palette = "jco", ggtheme = theme_classic())


# K-means on the random dataset 
km.res2 <- kmeans(random_df, 2) 
fviz_cluster(list(data = random_df, cluster = km.res2$cluster), 
             ellipse.type = "norm", geom = "point", stand = FALSE, palette = "jco", ggtheme = theme_classic())

# Hierarchical clustering on the random dataset 
fviz_dend(hclust(dist(random_df)), k= 2, k_colors = "jco", as.ggplot = TRUE, show_labels = FALSE)


################################ Assessing Clustering Tendency ##################################

# HOPKINS STATISTIC 
# using n = 120 to use about 20% of the points 
# Compute Hopkins statistic for actual dataset 
hopkins(df, n = 120)

# Compute Hopkins statistic for a random dataset 
hopkins(random_df, n = 120)

# The Breast Cancer data set is highly clusterable (the H value = 0.28 is below the threshold of 0.5)

# VISUAL ASSESSMENT (VAT APPROACH)
fviz_dist(dist(df), show_labels = FALSE)+ labs(title = "Breast Cancer data")
fviz_dist(dist(random_df), show_labels = FALSE)+ labs(title = "Random data")

# These images confirm that there is a cluster structure in the Breast Cancer data but not the random one


############################# Determining Optimal Number of Clusters ##################################
# Elbow method 
fviz_nbclust(df, kmeans, method = "wss") + 
  labs(subtitle = "Elbow method")

# Silhouette method 
fviz_nbclust(df, kmeans, method = "silhouette") + labs(subtitle = "Silhouette method")

# Gap statistic 
# nboot = 50 to keep the function speedy. 
# recommended value: nboot= 500 for your analysis. 
# Use verbose = FALSE to hide computing progression. 
fviz_nbclust(df, kmeans, nstart = 25, method = "gap_stat", nboot = 500)+ labs(subtitle = "Gap statistic method")

# all 30 indices
nb <- NbClust(df, distance = "euclidean", min.nc = 2, max.nc = 10, method = "kmeans")
fviz_nbclust(nb)



####################### Cluster Validation Statistics ######################################
# K-means clustering 
km.res <- eclust(df, "kmeans", k= 2, nstart = 25, graph = FALSE) 
# Visualize k-means clusters 
fviz_cluster(km.res, geom = "point", ellipse.type = "norm", palette = "jco", ggtheme = theme_minimal())

# Hierarchical clustering
hc.res <- eclust(df, "hclust", k= 2, hc_metric = "euclidean", hc_method = "ward.D2", graph = FALSE)
# Visualize dendrograms 
fviz_dend(hc.res, show_labels = FALSE, palette = "jco", as.ggplot = TRUE)


# SILHOUETTE METHOD
fviz_silhouette(km.res, palette = "jco", ggtheme = theme_classic())

# Silhouette information 
silinfo <- km.res$silinfo 
names(silinfo) 
# Silhouette widths of each observation 
head(silinfo$widths[, 1:3], 10)
# Average silhouette width of each cluster 
silinfo$clus.avg.widths 
# The total average (mean of all individual silhouette widths) 
silinfo$avg.width
# The size of each clusters 
km.res$size

# Silhouette width of observation 
sil <- km.res$silinfo$widths[, 1:3] 
# Objects with negative silhouette 
neg_sil_index <- which(sil[, 'sil_width']< 0) 
sil[neg_sil_index, , drop = FALSE]

# DUNN INDEX AND OTHER INDICES
# Statistics for k-means clustering 
km_stats <- cluster.stats(dist(df), km.res$cluster) 
# Dun index 
km_stats$dunn
# All indices 
km_stats

# EXTERNAL CLUSTERING VALIDATION 
table(bdata$Class, km.res$cluster)

clust_stats <- cluster.stats(d = dist(df), bdata$Class, km.res$cluster)
# Corrected Rand index 
clust_stats$corrected.rand
# Meila's VI
clust_stats$vi

# Agreement between classess and HC clusters 
res.hc <- eclust(df, "hclust", k= 2, graph = FALSE) 
table(bdata$Class, res.hc$cluster) 
cluster_stats <- cluster.stats(d= dist(df), bdata$Class, res.hc$cluster)
cluster_stats$corrected.rand
cluster_stats$vi

