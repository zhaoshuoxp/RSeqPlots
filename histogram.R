#!/usr/bin/env Rscript
#####################################
# Usage:                            #
# Manual:                           #
#####################################
library("ggplot2")
library('dplyr')
library('scales')
options<-commandArgs(trailingOnly = T)
plot_heigh<-4
plot_width<-5
png_name<-unlist(strsplit(options[1],'.',fixed=T))[1]
png(file=paste(png_name,'png',sep='.'),height = plot_heigh, width = plot_width, res=600, units = "in", family="Arial")

dat<-read.table(file=options[1],header=T)
#5FBBA3 brightgreen
#4169A0 darkblue
#C96486 pink
cdat <- ddply(dat, "name", summarise, dist.median=median(dist))
ggplot(dat,aes(x=dist,fill=name))+
	geom_histogram(binwidth= 1000, position='stack',
	aes(y = (..count..)/sum(..count..))
	)+
	geom_vline(data=cdat, aes(xintercept=dist.median,color=name), c)+
	xlim(c(-600,50000))+
	#ylim(c(0,1000))+
	scale_fill_manual(
		breaks=c("TCF21ToJUN","JUNToTCF21","TCF21ToHNF1A"),
		values=c("TCF21ToJUN"="#76b2A3","JUNToTCF21"="#bc6985","TCF21ToHNF1A"="grey"),
		labels=c("TCF21 to JUN","JUN to TCF21", "TCF21 to HNF1A"))+
	scale_color_manual(
		breaks=c("TCF21ToJUN","JUNToTCF21","TCF21ToHNF1A"),
		values=c("TCF21ToJUN"="forestgreen","JUNToTCF21"="firebrick","TCF21ToHNF1A"="darkgrey"),
		labels=c("TCF21 to JUN","JUN to TCF21","TCF21 to HNF1A"))+
	theme(
	 	legend.position = c(0.78,0.9), 
		legend.text = element_text(size=12), 
		legend.title = element_blank(),
		legend.background = element_rect(fill="transparent"),
		axis.text.y = element_text(size=10,colour = 'black'),
		axis.title = element_text(size=16,colour = 'black'),
		axis.text.x = element_text(size=12,colour = 'black')
	)+
		scale_y_continuous(labels=percent)+
		xlab("Distance to center (bp)")+
		ylab("Percent")->pic
	
pic
dev.off()

################ END ################
#          Created by Aone          #
#     quanyi.zhao@stanford.edu      #
################ END ################