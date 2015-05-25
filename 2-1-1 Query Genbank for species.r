#This script queries GenBank for the sequences of interest for a list of species

setwd(choose.dir())        #Set working directory to where directory "Phylogeny/sequences" is

(sppList<-as.character(read.csv("species_list.csv",header=TRUE)[,1]))        #Open file with list of species, which should be in directory "Phylogeny"

library(XML)
esearch = function(...,
        database, history=NULL, webenv=NULL, key=NULL, tool='reutils',
        email=NULL, field=NULL, reldate=NULL, mindate=NULL, maxdate=NULL,
        datetype=NULL, retstart=NULL, retmax=NULL, retmode=NULL, rettype=NULL,
        sort=NULL, baseurl='http://eutils.ncbi.nlm.nih.gov/entrez/eutils/') {
    query = do.call(join, c(..., list(operator=' AND ', format='%s[%s]', order=2:1)))
    url = sprintf('%s/esearch.fcgi?%s',
        baseurl,
        do.call(join, as.list(
            c(db=database, term=query, usehistory=history, WebEnv=webenv,
                query_key=key, tool=tool, email=email, field=field, reldate=reldate,
                mindate=mindate, maxdate=maxdate, datetype=datetype,
                retstart=retstart, retmax=retmax, retmode=retmode, rettype=rettype,
                sort=sort))))
    response = xmlInternalTreeParse(url)
    c(
        list(identifiers=xpathSApply(response, '//IdList/Id', xmlValue)),
        lapply(
            list(count='Count', retmax='RetMax', retstart='RetStart', key='QueryKey', webenv='WebEnv'),
            function(name)
                xpathSApply(response, sprintf('/*/%s', name), xmlValue))) }
                                
join = function(..., operator='&', format='%s=%s', order=1:2) {
    values = c(...)
    if (!length(values))
        return('')
    parameters = names(values)
    paste(collapse=operator,
        mapply(
            function(parameter, value)
                if (parameter=='') value
                else do.call(sprintf, c(format, list(parameter, value)[order])),
            if (is.null(parameters)) '' else parameters,
            values)) }
genes<-c("rbcl","matK","5.8s","ITS1","internal transcribed spacer 1")
genB<-data.frame(cbind(Scientific.Name = sppList,rbcl=vector(length=length(sppList)[1],mode="character"),matK=vector(length=length(sppList),mode="character"),c5.8s=vector(length=length(sppList),mode="character"),ITS1=vector(length=length(sppList),mode="character"),ITS1.t=vector(length=length(sppList),mode="character") ))
for(i in 1:length(sppList)){
        for(n in 2:6){
        genB[i,n]<-ifelse(esearch(database="nucleotide",paste(as.character(sppList[i]),"[Organism] AND ",genes[n-1],sep=""))$count=="0","NA","")
        }
}

#Combine the two ITS1 searches
genB[which(genB$ITS1.t==""),"ITS1"]<-""
genB<-genB[,-6]

write.csv(genB,"geneSeq.csv",row.names=FALSE)

sppList2<-paste(">",gsub(" ","_",sppList),sep="",delim="/n")

rbcl<-paste(">", gsub(" ","_",sppList[which(genB$rbcl=="")]),sep="", collapse=" \n\n")
matK<-paste(">", gsub(" ","_",sppList[which(genB$matK=="")]),sep="", collapse=" \n\n")
s5.8s<-paste(">", gsub(" ","_",sppList[which(genB$c5.8s=="")]),sep="", collapse=" \n\n")
ITS1<-paste(">", gsub(" ","_",sppList[which(genB$ITS1=="")]),sep="", collapse=" \n\n")
ITS15.8s<-paste(">", gsub(" ","_",sppList[which(genB$ITS1=="" && genB$c5.8s=="")]),sep="", collapse=" \n\n")
write(rbcl,"run1/rbcl.txt")
write(matK,"run1/matK.txt")
write(s5.8s,"run1/5.8s.txt")
write(ITS1,"run1/ITS1.txt")
write(ITS15.8s,"run1/ITS15.8s.txt")

#Which ones have "NA"s across the board?
nas<-droplevels(genB[apply(genB,1,function(x) all(is.na(x[2:5]))),1] )
gen2<-list()
for(i in 1:length(nas)){
        gen2[i]<-esearch(database="nucleotide",paste(as.character(nas[i]),"[Organism]",sep=""))
        names(gen2)[i]<-as.character(nas[i])
}

tes<-names(gen2[which(sapply(names(gen2),function(x) length(gen2[[x]]))>0)])

write.csv(tes,"alternativeSeqs.csv",row.names=FALSE)