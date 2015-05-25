lambdamincv = 0 #Change this value to whatever lambda value your CV is minimized at

#Read tree file into R
tree<-read.tree("final_tree.new")

#Ultrametricize tree
phy<-chronopl(tree,lambda=lambdamincv)

#Write your ultrametric tree
write.tree(phy, file="molecular_tree.new") 