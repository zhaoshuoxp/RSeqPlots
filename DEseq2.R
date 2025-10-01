#!/usr/bin/env Rscript
#####################################
# Usage: DEseq.r featureCount.txt condition.txt

library("DESeq2")
options<-commandArgs(trailingOnly = T)
	
data <- read.table(options[1], header=T, quote="\t", check.names=F, skip=1)
SampCond <- read.table(options[2], header=T, quote="\t")

names(data)[7:ncol(data)] ->sample
sub(pattern=".bam", replacement="", sample) ->sampleNames
if (all(SampCond$sample==sampleNames)){
	
	names(data)[7:ncol(data)] <- sampleNames
	countData <- as.matrix(data[7:ncol(data)])
	rownames(countData) <- data$Geneid
	database <- data.frame(name=sampleNames, condition=SampCond$condition)
	rownames(database) <- sampleNames
	
	dds <- DESeqDataSetFromMatrix(countData, colData=database, design= ~ condition)
	dds <- dds[ rowSums(counts(dds)) > 1, ]
	dds <- DESeq(dds)
	res <- results(dds)
	#res <- results(dds, contrast=c("condition","condition1","condition2"))
	resdata <- merge(as.data.frame(res), as.data.frame(counts(dds, normalized=TRUE)),by="row.names",sort=FALSE)
	names(resdata)[names(resdata)=="Row.names"]="Genes"
	write.table(resdata, "all_genes_exp.txt", row.names=F, sep="\t", quote=F)

}else{
	stop("Sample names in conditions.txt don't match featureCount output!")	
}

################ END ################
#          Created by Aone          #
#     quanyi.zhao@stanford.edu      #
################ END ################