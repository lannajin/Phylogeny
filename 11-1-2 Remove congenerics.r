library(ape); library(phytools)
#Load molecular tree file into R. This should be your tree from your final run
tr<-read.tree("Phylogeny/PhyML/run8/fcc_smatrix_phy_phyml_tree.txt")
#Function to add any species missing from your species pool into the same node as congenerics
spp2genus<-function (tree, species, genus = NULL, where = c("root", "random"))
{
    where <- where[1]
    if (is.null(genus)) {
        x <- strsplit(species, "")[[1]]
        i <- 1
        while (x[i] != "_" && x[i] != " ") i <- i + 1
        genus <- paste(x[2:i - 1], collapse = "")
    }
    ii <- grep(paste(genus, "_", sep = ""), tree$tip.label)
    if (length(ii) > 1) {
        if (!is.monophyletic(tree, tree$tip.label[ii]))
            warning(paste(genus, "may not be monophyletic\n  attaching to the most inclusive group containing members of this genus"))
        nn <- findMRCA(tree, tree$tip.label[ii])
        if (where == "root")
            tree <- bind.tip(tree, gsub(" ", "_", species), where = nn, edge.length=0.00000001)
        else if (where == "random") {
            tt <- splitTree(tree, list(node = nn, bp = tree$edge.length[which(tree$edge[,
                2] == nn)]))
            tt[[2]] <- add.random(tt[[2]], tips = gsub(" ", "_",
                species))
            tree <- paste.tree(tt[[1]], tt[[2]])
        }
        else stop("option 'where' not recognized")
    }
    else if (length(ii) == 1) {
        nn <- ii
        if (where == "root")
            tree <- bind.tip(tree, gsub(" ", "_", species), where = nn,
                position = 0.5 * tree$edge.length[which(tree$edge[,
                  2] == nn)], edge.length=0.00000001)
        else if (where == "random")
            tree <- bind.tip(tree, gsub(" ", "_", species), where = nn,
                position = runif(n = 1) * tree$edge.length[which(tree$edge[,
                  2] == nn)], edge.length=0.00000001)
        else stop("option 'where' not recognized")
    }
    else warning("could not match your species to a genus\n  check spelling, including case")
    tree
}
#Read in list of species that are supposed to be in this phylogeny (regional species pool).
spp<-read.csv("spp_list.csv",header=TRUE)
#Species list's names are supposed to be in the same format at the phylogeny, e.g., there should be a "_" between genus and species name.
spp<-gsub(" ","_",spp[,1])
#Here, we identify species that are missing from the current phylogeny that should be added in at the genus node level
missing<-sort(spp[-which(spp %in% tr$tip.label)])
#Add each missing species in at the node the formed by congenerics
for(i in missing){
        tr<-spp2genus(tr,i, where="root")
}
#Determine which species in the phylogeny are congenerics that were added into the molecular phylogeny as "glue" or to form genus nodes for missing species
rmsp<-sort(tr$tip.label[-which(tr$tip.label %in% spp)])
#Remove congenerics from the tree
tr<-drop.tip(tr,rmsp)
#root the tree
tr<-root(tr,"Equisetum_arvense",r=TRUE) #change the outgroup to your own
#Write the tree
write.tree(tr,"final_tree.new")