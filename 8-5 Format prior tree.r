######Formatting the Prior Tree

#Remove node labels
ini$node.label<-NULL

#Unroot prior tree
if(is.rooted(ini)){ini<-unroot(ini)}

#Convert tree to ultrametric tree
if(is.ultrametric(ini)){
x.ult<-chronopl(ini,lambda=0.1)
}

#Resolve polytomies randomly
x.ult<-multi2di(x.ult,random=TRUE)
write.tree(x.ult, file="prior.new")