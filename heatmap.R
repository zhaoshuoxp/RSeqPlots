#!/usr/bin/env Rscript
############################
# Usage : ./ggplots.R file1 file2 ...
############################

# arguments in command line
library("pheatmap")

options<-commandArgs(trailingOnly = T)
plot_heigh<-4
plot_width<-2
png_name<-unlist(strsplit(options[1],'.',fixed=T))[1]
png(file=paste(png_name,'png',sep='.'),height = plot_heigh, width = plot_width, res=600, units = "in", family="Arial")

dat<-read.table(file=options[1],header=T)
dat[,2:3]->values
logvalues<-log(values+0.1)
rownames(logvalues)<-dat$Gene

# column annotation
#labels = c('a','b', rep('x',100))
#anno = data.frame(labels)
#rownames(anno) = colnames(dat)

pheatmap(logvalues,
		cluster_rows = F,
		clustering_distance_rows = "euclidean",
		cluster_cols = F,
		clustering_distance_cols = "euclidean",
		clustering_method = "complete",
		# ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC), "centroid" (= UPGMC).
		scale = "column",
		#annotation_col = anno,
		#annotation_names_col = F,
		#breaks = seq(-2,2, length.out=100),
		labels_col = c("Ctrl","OE"))->hm
hm
dev.off()

################ END ################
#          Created by Aone          #
#     quanyi.zhao@stanford.edu      #
#####################################