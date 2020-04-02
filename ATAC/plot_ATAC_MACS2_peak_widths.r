##########
#name:  	plot_ATAC_MACS2_peak_widths.r
#description:   plot widths of MACS2 peaks
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 28, 2020
##########


library(reshape2)
library(ggplot2)

args = commandArgs(trailingOnly=TRUE)
out.dir <- args[1]
quality.dir <- args[2]

setwd(getwd())

peaksXX10 <- read.delim(paste0(out.dir, 
                             "/ATAC/XX_10.5/MACS2_peaks/XX_10.5_pooled_p005_peaks_",
                             "IDR_summitpos_final.narrowPeak"), 
                      header=F, sep="\t")

peaksXX13 <- read.delim(paste0(out.dir, 
                             "/ATAC/XX_13.5/MACS2_peaks/XX_13.5_pooled_p005_peaks_",
                             "IDR_summitpos_final.narrowPeak"), 
                      header=F, sep="\t")

peaksXY10 <- read.delim(paste0(out.dir, 
                             "/ATAC/XY_10.5/MACS2_peaks/XY_10.5_pooled_p005_peaks_",
                             "IDR_summitpos_final.narrowPeak"), 
                      header=F, sep="\t")

peaksXY13 <- read.delim(paste0(out.dir, 
                             "/ATAC/XY_13.5/MACS2_peaks/XY_13.5_pooled_p005_peaks_",
                             "IDR_summitpos_final.narrowPeak"), 
                      header=F, sep="\t")


colnames(peaksXX10) <- c("chrom", "chromStart", "chromEnd", "name", "summit")
peaksXX10.widths = peaksXX10$chromEnd - peaksXX10$chromStart

colnames(peaksXX13) <- c("chrom", "chromStart", "chromEnd", "name", "summit")
peaksXX13.widths = peaksXX13$chromEnd - peaksXX13$chromStart

colnames(peaksXY10) <- c("chrom", "chromStart", "chromEnd", "name", "summit")
peaksXY10.widths = peaksXY10$chromEnd - peaksXY10$chromStart

colnames(peaksXY13) <- c("chrom", "chromStart", "chromEnd", "name", "summit")
peaksXY13.widths = peaksXY13$chromEnd - peaksXY13$chromStart

allwidths = list("XX_10.5"= peaksXX10.widths, "XX_13.5"=peaksXX13.widths, 
                 "XY_10.5"=peaksXY10.widths, "XY_13.5"= peaksXY13.widths)

allwidths.melted = melt(allwidths)

allwidths.melted$L1 = as.factor(allwidths.melted$L1)
allwidths.melted$L1 = factor(allwidths.melted$L1, 
                             levels=c(names(allwidths)), ordered=TRUE)

medians=aggregate(value ~ L1, allwidths.melted, median)

lengths=aggregate(value ~ L1, allwidths.melted, length)


pdf(paste0(quality.dir, "/ATAC_MACS2_peaks_widths.pdf"), height=6, width=8)

ggplot(allwidths.melted, aes(x=L1, y=value, fill=L1)) + 
geom_violin(trim=TRUE, scale="count") + 
labs(x="time point", y ="width in bp") + 
theme(panel.grid=element_blank(), panel.background=element_blank(), 
      panel.border=element_rect(fill=NA), legend.position="none") + 
scale_fill_manual(values=c("#e8f6f3", "#abd5ee", "#63acd8","#55b7bf", 
                           "#12a8b4")) + 
geom_boxplot(width=0.1, outlier.shape=NA) + 
geom_text(data=medians, aes(label=value), hjust=-0.55) + 
geom_text(data=lengths, aes(y=0,label=paste0("n=",value)), vjust=-20, 
          hjust=-4,angle=45) + 
ggtitle("ATAC-seq peak widths") + 
theme(plot.title=element_text(hjust=0.5))

dev.off()
warnings()


q()

