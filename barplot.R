#!/usr/bin/env Rscript
############################
# Usage : ./ggplots.R file1 file2 ...
############################
# arguments in command line
library("ggplot2")
options<-commandArgs(trailingOnly = T)
plot_heigh<-2.7
plot_width<-4
png_name<-unlist(strsplit(options[1],'.',fixed=T))[1]
png(file=paste(png_name,'png',sep='.'),height = plot_heigh, width = plot_width, res=600, units = "in", family="Arial")
options(scipen=200000000)
dat<-read.table(file=options[1],header=T)
dat<- dat[seq(dim(dat)[1],1),]
dat<-transform(dat,Gene=factor(Gene,levels=unique(Gene)))

dat$color<-ifelse(dat$log2FoldChange >0, "Increase",  "Decrease")
bp_data<-data.frame(gen=dat$Gene,value=dat$log2FoldChange,col=dat$color)
ggplot(data=bp_data,aes(x=gen,y=value,fill=col))+
	geom_bar(stat="identity")+
	scale_fill_manual(values=c("steelblue","palevioletred"))+
	theme(
	 	legend.position = c(0.1,0.87), 
		legend.text = element_text(size=7), 
		legend.title = element_blank(),
		legend.background = element_rect(fill="transparent"),
		axis.text.y = element_text(size=8,colour = 'black'),
		axis.title = element_text(size=10,colour = 'black'),
		axis.text.x =element_text(size=8,colour = 'black',angle = 45, hjust=1)
	)+
		xlab("Genes")+
		ylab("log2(fold change)") -> bp
bp
dev.off()

################ END ################
#          Created by Aone          #
#     quanyi.zhao@stanford.edu      #
################ END ################