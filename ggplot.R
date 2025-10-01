#!/usr/bin/env Rscript
############################
# Usage : ./ggplots.R file1 file2 ...
############################
# arguments in command line
library("ggplot2")
options<-commandArgs(trailingOnly = T)
plot_heigh<-5
plot_width<-7
png_name<-unlist(strsplit(options[1],'.',fixed=T))[1]
png(file=paste(png_name,'png',sep='.'),height = plot_heigh, width = plot_width, res=600, units = "in", family="Arial")

#awk -v OFS="\t" '{if ($5<0.001){print $3,$4,"p<e-3"}else if($4<0.01){print $3,$4,"e-2<p<e-3"}else if($5<0.05){print $3,$4,"e-2<p<0.05"}else{print $3,$4,"non_sig"}}' prepost.txt > plot.txt

dat<-read.table(file=options[1],header=T)

ggplot(dat,aes(x=pre_freq,y=post_freq,group=sig,colour=sig))+
	geom_jitter(size=0.3)+	
	#scale_color_manual(
	#		breaks=c("e-3","e-4","ns"),
	#		values=c("e-3"="green","e-4"="violetred","ns"="steelblue")
	#		)+
	theme(
		#legend.position = c(0.10,0.90), 
		legend.text = element_text(size=16), 
		legend.title = element_blank(), 
		legend.background = element_rect(fill="transparent"),
		axis.text.y = element_text(size=10,colour = 'black'),
		axis.title = element_text(size=20,colour = 'black'),
		axis.text.x = element_text(size=14,colour = 'black')
		)+
	guides(colour = guide_legend(override.aes = list(size=5)))+
	xlab("Pre Freq")+
	ylab("Post Freq")->pic
pic
dev.off()

################ END ################
#          Created by Aone          #
#     quanyi.zhao@stanford.edu      #
################ END ################