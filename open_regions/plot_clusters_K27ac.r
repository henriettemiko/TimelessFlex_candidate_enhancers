
##########
#name:          plot_clusters.r
#description:   plots clusters
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 30, 2020
##########


library(psych)

setwd(getwd())

args = commandArgs(trailingOnly=TRUE)

numClusters = as.numeric(args[1])
numMarks = as.numeric(args[2])
numTimePoints = as.numeric(args[3])
numcluster.dir = args[4]
timeless.dir = args[5]
signalgenerator.dir = args[6]
type = args[7]

score <- function(x){
    x = scale(x, scale = FALSE)
    x  = ((x-min(x))/(max(x)-min(x))) * 100
    return(x)
}

l = read.table(paste0(numcluster.dir, "/classes-", numClusters, ".txt"))
k = read.table(paste0(signalgenerator.dir, "/allCountsNorm_K27ac.txt"))

# 4 time points
k27ac = cbind(k[[12]], k[[13]], k[[14]], k[[15]])
#k27me3 = cbind(k[[16]], k[[17]], k[[18]], k[[19]])
#k4me3 = cbind(k[[20]], k[[21]], k[[22]], k[[23]])

k27ac = matrix(score(as.vector(k27ac)), ncol = 4, byrow = FALSE)
#k27me3 = matrix(score(as.vector(k27me3)), ncol = 4, byrow = FALSE)
#k4me3 = matrix(score(as.vector(k4me3)), ncol = 4, byrow = FALSE)

print(colMeans(k27ac))
#print(colMeans(k27me3))
#print(colMeans(k4me3))

cbbPalette <- c("gray", "#009E73", "#D50F25")
#me3 gray, me1 black, 27ac green 009E73, 27me3 red
#plot from dark to light colors: me1, k27me3, k27ac, me3

pdf(paste0(type, "_clusters_", numClusters, ".pdf"), height=6, width=10)

par(mar=c(5.1, 4.1, 4.1, 7.1), oma=c(0,0,2,0), xpd=TRUE)


par(mfrow=c(1,2))

for (i in 1:numClusters) {

    cur.items = which(l[[1]] == i)
    stuff1.k27ac <- cbind(k27ac[cur.items,1], k27ac[cur.items,2])
    stuff2.k27ac <- cbind(k27ac[cur.items,1], k27ac[cur.items,3])
#                         k27ac[cur.items,3], k27ac[cur.items,4])
#    stuff1.k27me3 <- cbind(k27me3[cur.items,1], k27me3[cur.items,2]) 
#    stuff2.k27me3 <- cbind(k27me3[cur.items,1], k27me3[cur.items,3]) 
#                          k27me3[cur.items,3], k27me3[cur.items,4])
#    stuff1.k4me3 <- cbind(k4me3[cur.items,1], k4me3[cur.items,2]) 
#    stuff2.k4me3 <- cbind(k4me3[cur.items,1], k4me3[cur.items,3]) 
#                         k4me3[cur.items,3], k4me3[cur.items,4])

    colnames(stuff1.k27ac) <- c("10.5", "13.5")#, "XY_10.5", "XY_13.5")
    colnames(stuff2.k27ac) <- c("XX", "XY")#, "XY_10.5", "XY_13.5")

    error.bars(stuff1.k27ac, eyes = FALSE, sd = FALSE, bars = FALSE, 
               arrow.col = cbbPalette[2], labels = colnames(stuff1.k27ac), 
               ylim = c(0,50), 
               ylab = "normalized average histone mark signal", 
               xlab="time", col = cbbPalette[2], main="")
               #main = paste0("Cluster ", i, ": n=", length(cur.items)))
    lines(colMeans((cbind(k27ac[cur.items,1], k27ac[cur.items,2]))), 
                   col = cbbPalette[2], 
          ylim = c(0,50), lwd = 8, type="o", pch=16)
    lines(colMeans((cbind(k27ac[cur.items,3], k27ac[cur.items,4]))), 
                   col = cbbPalette[2], 
          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=2)
#    lines(colMeans((cbind(k27me3[cur.items,1], k27me3[cur.items,3]))), 
#                   col = cbbPalette[3], 
#          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)
#    lines(colMeans((cbind(k27me3[cur.items,2], k27me3[cur.items,4]))), 
#                   col = cbbPalette[3], 
#          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)

#    error.bars(stuff1.k4me3, eyes = FALSE, sd = FALSE, bars = FALSE, 
#               arrow.col = cbbPalette[1], ylim = c(0,50), 
#               col = cbbPalette[1], add = TRUE)
#    lines(colMeans((cbind(k4me3[cur.items,1], k4me3[cur.items,2]))), 
#                   col = cbbPalette[1], 
#          ylim = c(0,50), lwd = 8, type="o", pch=16)
#    lines(colMeans((cbind(k4me3[cur.items,3], k4me3[cur.items,4]))), 
#                   col = cbbPalette[1], 
#          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=2)
# #   lines(colMeans((cbind(k4me3[cur.items,1], k4me3[cur.items,3]))), 
# #                  col = cbbPalette[1], 
# #         ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)
# #   lines(colMeans((cbind(k4me3[cur.items,2], k4me3[cur.items,4]))), 
# #                  col = cbbPalette[1], 
# #         ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)
#
#    error.bars(stuff1.k27ac, eyes = FALSE, sd = FALSE, bars = FALSE, 
#               arrow.col = cbbPalette[2], ylim = c(0,50), 
#               col = cbbPalette[2], add = TRUE)
#    lines(colMeans((cbind(k27ac[cur.items,1], k27ac[cur.items,2]))), 
#                   col = cbbPalette[2], 
#          ylim = c(0,50), lwd = 8, type="o", pch=16)
#    lines(colMeans((cbind(k27ac[cur.items,3], k27ac[cur.items,4]))), 
#                   col = cbbPalette[2], 
#          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=2)
# #   lines(colMeans((cbind(k27ac[cur.items,1], k27ac[cur.items,3]))), 
# #                  col = cbbPalette[2], 
# #         ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)
# #   lines(colMeans((cbind(k27ac[cur.items,2], k27ac[cur.items,4]))), 
# #                  col = cbbPalette[2], 
# #         ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)
#
  


legend("topright", inset=c(-0.45,0),
           legend=c("H3K27ac"),
           col=c("#009E73"), pch=15, bty="n")

legend("bottomright", inset=c(-0.45,0),
           legend=c("female","male"),
           col="black", lty=1:2, bty="n")





    error.bars(stuff2.k27ac, eyes = FALSE, sd = FALSE, bars = FALSE,
               arrow.col = cbbPalette[2], labels = colnames(stuff2.k27ac),
               ylim = c(0,50),
               ylab = "normalized average histone mark signal",
               xlab="sex", col = cbbPalette[2], main="")
               #main = paste0("Cluster ", i, ": n=", length(cur.items)))
#     lines(colMeans((cbind(k27me3[cur.items,1], k27me3[cur.items,2]))),
#                   col = cbbPalette[3],
#          ylim = c(0,50), lwd = 8, type="o", pch=16)
#    lines(colMeans((cbind(k27me3[cur.items,3], k27me3[cur.items,4]))),
#                   col = cbbPalette[3],
#          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)
    lines(colMeans((cbind(k27ac[cur.items,1], k27ac[cur.items,3]))),
                   col = cbbPalette[2],
          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)
    lines(colMeans((cbind(k27ac[cur.items,2], k27ac[cur.items,4]))),
                   col = cbbPalette[2],
          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=6)

#    error.bars(stuff2.k4me3, eyes = FALSE, sd = FALSE, bars = FALSE,
#               arrow.col = cbbPalette[1], ylim = c(0,50),
#               col = cbbPalette[1], add = TRUE)
##    lines(colMeans((cbind(k4me3[cur.items,1], k4me3[cur.items,2]))),
##                   col = cbbPalette[1],
##          ylim = c(0,50), lwd = 8, type="o", pch=16)
##    lines(colMeans((cbind(k4me3[cur.items,3], k4me3[cur.items,4]))),
##                   col = cbbPalette[1],
##          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)
#    lines(colMeans((cbind(k4me3[cur.items,1], k4me3[cur.items,3]))),
#                   col = cbbPalette[1],
#          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)
#    lines(colMeans((cbind(k4me3[cur.items,2], k4me3[cur.items,4]))),
#                   col = cbbPalette[1],
#          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=6)
#
#
#    error.bars(stuff1.k27ac, eyes = FALSE, sd = FALSE, bars = FALSE,
#               arrow.col = cbbPalette[2], ylim = c(0,50),
#               col = cbbPalette[2], add = TRUE)
##    lines(colMeans((cbind(k27ac[cur.items,1], k27ac[cur.items,2]))),
##                   col = cbbPalette[2],
##          ylim = c(0,50), lwd = 8, type="o", pch=16)
##    lines(colMeans((cbind(k27ac[cur.items,3], k27ac[cur.items,4]))),
##                   col = cbbPalette[2],
##          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)
#    lines(colMeans((cbind(k27ac[cur.items,1], k27ac[cur.items,3]))),
#                   col = cbbPalette[2],
#          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=3)
#    lines(colMeans((cbind(k27ac[cur.items,2], k27ac[cur.items,4]))),
#                   col = cbbPalette[2],
#          ylim = c(0,50), lwd = 8, type="o", pch=16, lty=6)
#
    mtext(paste0("Cluster ", i, " (", length(cur.items), " regions)"), 
          outer=TRUE, cex=1.5,font=2)



legend("topright", inset=c(-0.45,0), 
           legend=c("H3K27ac"), 
           col=c("#009E73"), pch=15, bty="n") 

legend("bottomright", inset=c(-0.45,0), 
           legend=c("10.5","13.5"), 
           col="black", lty=c(3,6), bty="n") 

#legend("bottomright", inset=c(-0.45,0), 
#           legend=c("female","male","10.5","13.5"), 
#           col="black", lty=1:4, bty="n") 
}


dev.off()
warnings()


q()

