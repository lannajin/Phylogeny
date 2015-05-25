setwd("Phylogeny/pb_mpi1.5a/data")

library(ape)
library(seqinr)

#Load trees
ini<-read.tree("prior.new")
con<-read.alignment("FcC_smatrix.fas", "fasta")

#Make sure same number of species in prior tree and in concatenated sequence file
length(ini$tip.label)==length(tolower(con$nam))

#Are there any duplicated names in any of the files?
ini$tip.label[which(duplicated(ini$tip.label))]
con$nam[which(duplicated(con$nam))]

#Are all the names in both the files the same?
all(sort(ini$tip.label) == sort((con$nam)))

#Are all the sequences the same length?
length(unique(unlist(lapply(1:con$nb, function(x) nchar(con$seq[[x]][1])))))==1