##########
#name:          get_normalized_FC_K27ac.r
#description:   compute normalized fold changes of consecutive time points
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 30, 2020
##########

library(limma)

args = commandArgs(trailingOnly=TRUE)

curdir <- getwd()
setwd(curdir)

l = read.table(args[1])
name <- args[2]
titlename <- args[3]

print(dim(l))

#select columns for histone mark (columns = time points)
#regions have 11 columns at beginning of file
m1 = normalizeQuantiles(cbind(l[[12]], l[[13]], l[[14]],l[[15]])) 
#m2 = normalizeQuantiles(cbind(l[[16]], l[[17]], l[[18]],l[[19]])) 
#m3 = normalizeQuantiles(cbind(l[[20]], l[[21]], l[[22]],l[[23]])) 

mean1=mean(m1)
#mean2=mean(m2)
#mean3=mean(m3)

print(mean1)
#print(mean2)
#print(mean3)

#filter regions that are above mean for at least one time point for one 
#histone mark
getThis1 = which((apply(m1,1,function(x) any(x>=mean1)))==TRUE)
#getThis2 = which((apply(m2,1,function(x) any(x>=mean2)))==TRUE)
#getThis3 = which((apply(m3,1,function(x) any(x>=mean3)))==TRUE)

m1.filtered=m1[getThis1,]
#m2.filtered=m2[getThis2,]
#m3.filtered=m3[getThis3,]

print(dim(m1.filtered))
#print(dim(m2.filtered))
#print(dim(m3.filtered))

g=unique(sort(c(getThis1)))
#g=unique(sort(c(getThis1,getThis2,getThis3)))

print(length(g))

filtered1=m1[g,]
#filtered2=m2[g,]
#filtered3=m3[g,]

print(dim(filtered1))

#write regions and normalized counts for each time point
#it is ordered for XX_10.5 XX_13.5 XY_10.5 XY_13.5
#order stays for each histone modification
#regions 1-11
#histone modification 1: col 12-16 etc
n.reordered = cbind(l[g,seq(1:11)],filtered1)
print(dim(n.reordered))

write.table(n.reordered, sep = "\t", file = paste0("allCountsNorm_K27ac.txt"), 
            quote = F, row.names = F, col.names = F)
write.table(l[g,seq(1:11)], sep = "\t", file = paste0("regions_filtered_K27ac.bed"), 
            quote = F, row.names = F, col.names = F)

f1=m1[g,]+1
#f2=m2[g,]+1
#f3=m3[g,]+1

#compute FC
#ordering of time points: XX_10.5 XX_13.5 XY_10.5 XY_13.5
#ordering of columns: col1 col2 col3 col4
#FC of time points XX_13.5/XX_10.5 XY_13.5/XY_10.5 XY_10.5/XX_10.5 XY_13.5/XX_13.5
#FC columns: col2/col1 col4/col3 col3/col1 col4/col2

fc1=cbind(log2(f1[,2] / f1[,1]), log2(f1[,4] / f1[,3]), log2(f1[,3] / f1[,1]), 
          log2(f1[,4] / f1[,2]))
#fc2=cbind(log2(f2[,2] / f2[,1]), log2(f2[,4] / f2[,3]), log2(f2[,3] / f2[,1]), 
#          log2(f2[,4] / f2[,2]))
#fc3=cbind(log2(f3[,2] / f3[,1]), log2(f3[,4] / f3[,3]), log2(f3[,3] / f3[,1]), 
#          log2(f3[,4] / f3[,2]))

fc.reordered = cbind(l[g,seq(1:11)],fc1*100)

print(dim(fc.reordered))
write.table(fc.reordered, sep = "\t", file = paste0("allFold_K27ac.txt"), quote = F, 
            row.names = F, col.names = F)

write.table(fc.reordered[,-(1:11)], sep = "\t", 
            file = paste0("allFold_data_K27ac.txt"), quote = F, row.names = F, 
            col.names = F)

q()


#histogram of fold changes
#around 0: stays the same
#right side: increasing
#left side: decreasing
#plot distribution of log-FC, should be normal/Gaussian


pdf(paste0("logFC_H3K27ac", name, ".pdf"), width=8, height=6)
par(mfrow=c(2,2),oma=c(0,0,2,0))
hist(fc1[,1], breaks = 100, main=paste0("XX_13.5/XX_10.5"), xlab=("log2FC"))
hist(fc1[,2], breaks = 100, main=paste0("XY_13.5/XY_10.5"), xlab=("log2FC"))
hist(fc1[,3], breaks = 100, main=paste0("XY_10.5/XX_10.5"), xlab=("log2FC"))
hist(fc1[,4], breaks = 100, main=paste0("XY_13.5/XX_13.5"), xlab=("log2FC"))
mtext("H3K27ac", outer=TRUE, cex=1.5)
dev.off()

pdf(paste0("logFC_H3K27me3", name, ".pdf"), width=8, height=6)
par(mfrow=c(2,2),oma=c(0,0,2,0))
hist(fc2[,1], breaks = 100, main=paste0("XX_13.5/XX_10.5"), xlab=("log2FC"))
hist(fc2[,2], breaks = 100, main=paste0("XY_13.5/XY_10.5"), xlab=("log2FC"))
hist(fc2[,3], breaks = 100, main=paste0("XY_10.5/XX_10.5"), xlab=("log2FC"))
hist(fc2[,4], breaks = 100, main=paste0("XY_13.5/XX_13.5"), xlab=("log2FC"))
mtext("H3K27me3", outer=TRUE, cex=1.5)
dev.off()

pdf(paste0("logFC_H3K4me3", name, ".pdf"), width=8, height=6)
par(mfrow=c(2,2),oma=c(0,0,2,0))
hist(fc3[,1], breaks = 100, main=paste0("XX_13.5/XX_10.5"), xlab=("log2FC"))
hist(fc3[,2], breaks = 100, main=paste0("XY_13.5/XY_10.5"), xlab=("log2FC"))
hist(fc3[,3], breaks = 100, main=paste0("XY_10.5/XX_10.5"), xlab=("log2FC"))
hist(fc3[,4], breaks = 100, main=paste0("XY_13.5/XX_13.5"), xlab=("log2FC"))
mtext("H3K4me3", outer=TRUE, cex=1.5)
dev.off()


#plot distribution of counts

pdf(paste0("Hist_H3K27ac", name, ".pdf"), width=8, height=6)
hist(m1, breaks = 100, main=paste0("H3K27ac"), xlab=("normalized counts"))
lines(rep(mean1, 100), seq(0,200000,length.out=100), col = "red", lty = 1, 
      lwd=2)
dev.off()

pdf(paste0("Hist_H3K27me3", name, ".pdf"), width=8, height=6)
hist(m2, breaks = 100, main=paste0("H3K27me3"), xlab=("normalized counts"))
lines(rep(mean2, 100), seq(0,200000,length.out=100), col = "red", lty = 1, 
      lwd=2)
dev.off()

pdf(paste0("Hist_H3K4me3", name, ".pdf"), width=8, height=6)
hist(m3, breaks = 100, main=paste0("H3K4me3"), xlab=("normalized counts"))
lines(rep(mean3, 100), seq(0,200000,length.out=100), col = "red", lty = 1, 
      lwd=2)
dev.off()




q()

