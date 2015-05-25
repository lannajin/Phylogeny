#6.2.2a
#Species not included in the supertree are listed at the bottom of the Phylomatic output
tree<-scan("my_phylomatic.new",what="character")
fams<-tree[6:(length(tree)-1)]        #Identify the excluded species

#Write a data frame text file of the excluded species' families
write.csv(data.frame(cbind(OldFamily = unique(substr(fams,1,regexpr("/",fams)-1)), NewFamily=NA)), "FindFamilies.csv", row.names=FALSE)

#6.2.2c
newfams<-read.csv("FamiliesFound.csv",header=TRUE,stringsAsFactors=FALSE)
for(i in 1:dim(newfams)[1]){ nix[which(nix$Family==newfams$OldFamily[i]),]<-newfams$NewFamily[i] }

x<-paste(nix[,7],nix[,6],gsub(" ","_",nix[,1]),sep="/")
write(x,"submit2phylomatic.txt")
write.csv(nix,"nix.txt",row.names=FALSE)