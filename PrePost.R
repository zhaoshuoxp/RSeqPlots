#!/usr/bin/env Rscript
#####################################
# Usage:                            #
# Manual:                           #
#####################################
library("ggplot2")
options<-commandArgs(trailingOnly = T)
plot_heigh<-3.3
plot_width<-7
png_name<-unlist(strsplit(options[1],'.',fixed=T))[1]
png(file=paste(png_name,'png',sep='.'),height = plot_heigh, width = plot_width, res=600, units = "in", family="Arial")


# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
	library(grid)
 
	# Make a list from the ... arguments and plotlist
	plots <- c(list(...), plotlist)
 
	numPlots = length(plots)
 
	# If layout is NULL, then use 'cols' to determine layout
	if (is.null(layout)) {
		# Make the panel
		# ncol: Number of columns of plots
		# nrow: Number of rows needed, calculated from # of cols
		layout <- matrix(seq(1, cols * ceiling(numPlots/cols)), ncol = cols, nrow = ceiling(numPlots/cols))
	}
 
 if (numPlots==1) {
		print(plots[[1]])
 
	} else {
		# Set up the page
		grid.newpage()
		pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
 
		# Make each plot, in the correct location
		for (i in 1:numPlots) {
			# Get the i,j matrix positions of the regions that contain this subplot
			matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
 
			print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row, layout.pos.col = matchidx$col))
		}
	}
}

dat<-read.table(file=options[1],header=T)
dat$stat<-ifelse(dat$post_freq>dat$pre_freq,"Post","Pre")

sum(dat$stat=="Post")->v2
sum(dat$stat=="Pre")->v1
bar_dat<-data.frame(sample=c("pre","post"),nu=c(v1,v2))
ggplot(data=bar_dat, aes(x=sample, y=nu))+
		geom_bar(stat="identity",fill = c("steelblue","palevioletred"),width = 0.5)+
		geom_text(aes(label=nu),size=2,vjust=1.5)+
		theme(axis.text.x = element_text(size=12,color='black'))+
		xlab("")+
		ylab("SNP count")->bar
bar

m <- round(mean(dat$post_freq/dat$pre_freq),3)
subset(dat, dat$p_value<0.05)->dat_sig
m_sig <- round(mean(dat_sig$post_freq/dat_sig$pre_freq),3)
ggplot()+
	geom_density(data=dat,aes(x=post_freq, fill='steelblue',color='steelblue'),alpha = 0.4)+
	geom_density(data=dat,aes(x=pre_freq, fill='palevioletred',color='palevioletred'),alpha = 0.4)+
	annotate("text", x=0.2, y=4, label=paste("Mean(all):",m,"\nMean(sig):",m_sig),size=3)+
	scale_fill_identity(name='', guide='legend',labels=c('Pre','Post'))+
	scale_colour_manual(name ='', values=c('steelblue'='steelblue','palevioletred'='palevioletred'), labels=c('Pre','Post'))+
	ylab("Density")+
	xlab("Frequency")->hist
	
hist
layout <- matrix(c(1,2,2), ncol = 3)
multiplot(plotlist = list(bar, hist), cols=3, layout = layout)
dev.off()

################ END ################
#          Created by Aone          #
#     quanyi.zhao@stanford.edu      #
################ END ################