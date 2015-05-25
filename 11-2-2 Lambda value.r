#Read in the file with Lambda and CV values into R
x<-read.csv("cv_output.csv",header=TRUE)

#Plot CV vs. Lambda
plot(seq(1,length(lambda),by=1),cv,xlab="lambda number")

