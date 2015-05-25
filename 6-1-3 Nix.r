#6.1.3a

#Which species do not have class/order/family/genus information?
nix<-read.delim("nix.txt",header=TRUE,sep="\t",stringsAsFactors=FALSE)

nix[which(is.na(nix$MatchRank)),] #Pick out species with no matches

x<-sapply(1:dim(nix)[1], function(x)paste(nix[x, c(7,6,5)], collapse="/"))
write(x,"submit2phylomatic.txt")
write.csv(nix,"nix.txt",row.names=FALSE)

#Output a .csv file with corrected Genus and Family names for unmatched species
write.csv(data.frame(cbind(OriginalName = nix[which(is.na(nix$MatchRank)),"OriginalName"], AcceptedName =  nix[which(is.na(nix$MatchRank)),"OriginalName"], Genus = substr(nix[which(is.na(nix$MatchRank)),"OriginalName"],1,regexpr(" ",nix[which(is.na(nix$MatchRank)),"OriginalName"])-1), Family= NA)),"FindMatches.csv",row.names=FALSE)

#Search http://www.theplantlist.org and check what the accepted name of each species should be. If the name is unresolved, but has an accepted synonym: 1. Change the "AcceptedName"; 2. Change the genus; 3. add a family. If your species name is accepted, fill out the Family name.
#6.1.3c
matches<-read.csv("MatchesFound.csv",header=TRUE,stringsAsFactors=FALSE)        #read in file
nix[which(is.na(nix$MatchRank)),c("OriginalName","AcceptedName","Genus","Family")]<-matches        #replace unmatched species with new genus and families
x<-paste(nix[,7],nix[,6],gsub(" ","_",nix[,1]),sep="/")
write(x,"submit2phylomatic.txt")
write.csv(nix,"nix.txt",row.names=FALSE)