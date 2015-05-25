#6.1.2
library(seqinr)
x<-read.alignment("../../3 FASconCAT/run2/FcC_smatrix.fas",format="fasta")
write(gsub("_"," ",x$nam),"submit2nix.csv")
#Take this list to http://phylodiversity.net/nix and submit with exact match and "tab-delimited spreadsheet format"
#Save file as "phylocom-4.2/run1/nix.txt"