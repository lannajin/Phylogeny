library(ape); library(picante); library(parallel)

#Read tree file into R
tree<-read.tree("final_tree.new")

#Cross-validation for different values of lambda
chr<-mclapply(10^(-15:15),function(x){
        chronopl(tree,lambda=x,CV=TRUE)}, mc.cores=24)
		
cv<-unlist(lapply(chr,function(x)sum(attr(x,"D2"))))
lambda<-10^(-15:15)

#Create and write data frame
cvs<-data.frame(cbind(lambda,cv))
write.csv(cvs,file="cv_output.csv",row.names=FALSE)