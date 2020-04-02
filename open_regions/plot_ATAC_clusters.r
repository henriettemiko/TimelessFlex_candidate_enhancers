
##########
#name:          plot_ATAC_clusters.r
#description:   plots ATAC signal for clusters
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 30, 2020
##########


library(ggplot2)
library(reshape2)
library(plyr)
library(limma)

args = commandArgs(trailingOnly=TRUE)

curdir <- getwd()
setwd(curdir)

overlaps.prom = read.table(args[1], header=F, sep = "\t")
numTimePoints=as.numeric(args[2])
numReplicates=as.numeric(args[3])
numClusters=as.numeric(args[4])
model.dir=getwd()
numcluster.dir=getwd()

print(numReplicates)
print(numTimePoints)
print(numClusters)
print(head(overlaps.prom))


pdf(paste0(numcluster.dir,"/ATAC_cutsites_", numClusters, "_normalized.pdf"), 
    height=7, width=5)

#quantile normalization over time (rows are regions, cols are time points)
#this replaces normalization for number of cut sites
overlaps.prom.normalized = normalizeQuantiles(overlaps.prom[,2:5])

for (i in 1:numClusters) {

    cur.items.prom = which(overlaps.prom[[1]] == i)
    print(length(cur.items.prom))

    cur.overlaps.prom <- overlaps.prom.normalized[cur.items.prom,]
    print(dim(cur.overlaps.prom))

    #divide by 2 because 2 replicates were summed up
    boxplot(1000*(cur.overlaps.prom/2), 
            main=paste0("Cluster ", i, " (n=" , length(cur.items.prom), ")"), 
            ylab="normalized mean ATAC-seq cut sites",xlab="time", 
            ylim=c(0,25), col=rep("orange",4), 
            names = c("XX_10.5", "XX_13.5", "XY_10.5", "XY_13.5"),  outline = F)

}

dev.off()
warnings()


q()

