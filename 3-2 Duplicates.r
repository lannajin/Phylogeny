library(seqinr)   #If this is not installed, use command: "install.packages("seqinr")"
 
a<-read.alignment("matK.txt",format="fasta")
b<-read.alignment("rbcl.txt",format="fasta")
c<-read.alignment("ITS1.txt",format="fasta")
d<-read.alignment("5.8s.txt",format="fasta")
 
a$nam[which(duplicated(a$nam))] #lists duplicated species in matK.txt
b$nam[which(duplicated(b$nam))] #lists duplicated species in rbcl.txt
c$nam[which(duplicated(c$nam))] #lists duplicated species in ITS1.txt
d$nam[which(duplicated(d$nam))] #lists duplicated species in 5.8s.txt