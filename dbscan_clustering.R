# DBSCAN clustering on Wisconsin Breast Cancer Data 

library(factoextra)
library(clustertend)
library(NbClust)
library(dbscan)
library(fpc)
library(ggplot2)

# load data
bdata <- read.csv("Wisconsin_Breast_Cancers.csv", header = TRUE)

df <- bdata[, -11]
df <- df[,-1]

# PCA on BC data
prcomp(df)

# k means
km.res <- kmeans(df, 2, nstart = 25) 
fviz_cluster(km.res, df, geom = "point", 
             ellipse= FALSE, show.clust.cent = FALSE, palette = "jco", ggtheme = theme_classic())


######### DBSCAN ##########
# to find appropriate choice of eps -- look for elbow in this plot 
dbscan::kNNdistplot(df, k= 49) #use k = minpts - 1 

db <- fpc::dbscan(df, eps = 7, MinPts = 50)

fviz_cluster(db, data = df, stand = FALSE, 
             ellipse = FALSE, show.clust.cent = FALSE, geom = "point", palette = "jco", ggtheme = theme_classic())

table(db$cluster)

####### OPTICS #######
op <- optics(df, minPts = 50)
op
op$order
plot(op) # reachability plot

opd <- extractDBSCAN(op, eps_cl = 7)
opd
opd$order
opd$cluster
