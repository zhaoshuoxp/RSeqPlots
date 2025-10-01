#!/usr/bin/env Rscript
#####################################
# Usage:circ_plot.R DAVID_output DEseq(logFC)_output genes_terms_list                           

library('dplyr')
library('stringr')
library('GOplot')
options<-commandArgs(trailingOnly = T)
#size
plot_heigh<-13.5
plot_width<-12
png_name<-unlist(strsplit(options[1],'.',fixed=T))[1]
png(file=paste(png_name,'png',sep='.'),height = plot_heigh, width = plot_width, res=600, units = "in", family="Arial")

#read DAVID
david<-read.table(file=options[1],header=T,sep="\t")
david$PValue->david$adj_pval
# DAVID,BP, for KEGG, sep=":"
david$ID<-str_split_fixed(david$Term,"~",2)[,1]
david$Term<-str_split_fixed(david$Term,"~",2)[,2]

#read genes/terms list
sub<-read.table(file=options[3],header=F,fill=NA,sep="\t")
#in case duplicates
unique(sub$V1)->genes
#get terms and remove NA
sub$V2[sub$V2 != ""]->term

#read DEGs/fold change
degs<-read.table(file=options[2],header=T,sep="\t")
degs$log2FoldChange->degs$logFC
degs$Genes->degs$ID

#combine data
circle_dat(david,degs)->circ
#get genes and logFC only in genelist
subset(degs, degs$ID %in% genes,select=c(ID,logFC))->genelist

#prepare data for plot
chord_dat(data=circ,process = term, genes = genelist)->chord
GOChord(chord, space = 0.02, gene.order = 'logFC', gene.space = 0.25, gene.size = 5)->pic
pic

dev.off()

################ END ################
#          Created by Aone          #
#     quanyi.zhao@stanford.edu      #
################ END ################