# Import median coverage data
#mergedsistercount.txt
coveragedata <- read.table(file.choose(),header=T,stringsAsFactors = F)
#it appears some rows are duped for whatever reason
#let's get rid of em
coveragedata <- unique(coveragedata[,1:8])
# calculate N90 scaffold size.  
scaffL <- sort(coveragedata$Length, decreasing=T)
genomeSize <- sum(scaffL)
scaffCumsum <- cumsum(scaffL)
genome90 <- 0.90 * genomeSize
n90bp <- scaffL[ scaffCumsum > genome90][1]


##remove incomplete cases
coverageforz <- na.omit(coveragedata)
# require scaffolds have non-zero median coverages in all samples

nonZero <- apply(coverageforz[,3:8],1, function(x) {all(x > 0)} ) 
notShort <- coverageforz$Length > n90bp # exclude short scaffolds
coverageforz <- coverageforz[ nonZero & notShort, ] 

#now normalize
normconverter <- apply(coverageforz[,3:8], 2, mean)
normcoverage <- t(t(coverageforz[3:8])/normconverter)

#visualize 
layout(matrix(c(1,1,1,2,3,4), 2, 3, byrow = TRUE))
plot(coverageforz$Length,log2(normcoverage[,1]/normcoverage[,2]), 
main = "Danaus spp. median depth of coverage by scaffold", ylab="Log2(M/F)",xlab="Scaffold length", col ="blue", ylim=c(-.5,1.08))
points(coverageforz$Length,log2(normcoverage[,3]/normcoverage[,4]), 
col ="red")
points(coverageforz$Length,log2(normcoverage[,5]/normcoverage[,6]), 
col="green")
abline(h=.5, lty = 2)
legend(5.5e6, .2, c("erippus", "erisimus", "gilippus"), col=c("blue", "red", "green"), pch = 1)
plot(coverageforz$Length,log2(normcoverage[,1]/normcoverage[,2]), 
main = "D. erippus", ylab="Log2(M/F)",xlab="Scaffold length", col ="blue",ylim=c(-.5,1.08))
plot(coverageforz$Length,log2(normcoverage[,3]/normcoverage[,4]), 
main = "D. erisimus", ylab="Log2(M/F)",xlab="Scaffold length", col="red",ylim=c(-.5,1.08))
plot(coverageforz$Length,log2(normcoverage[,5]/normcoverage[,6]), 
main = "D. gilippus", ylab="Log2(M/F)",xlab="Scaffold length", col="green",ylim=c(-.5,1.08))

#around 200000bp scaffold erippus and gilippus drop

#so what are these scaffolds?
sisratios <- cbind(log2(normcoverage[,1]/normcoverage[,2]),
log2(normcoverage[,3]/normcoverage[,4]),log2(normcoverage[,5]/normcoverage[,6]))

suspectscaffolds <- apply(sisratios, 2, function(x) {x > 0.5} ) 
erippus <-coverageforz$Scaffold[as.logical(suspectscaffolds[,1])]
erisimus <-coverageforz$Scaffold[as.logical(suspectscaffolds[,2])]
gilippus <-coverageforz$Scaffold[as.logical(suspectscaffolds[,3])]

#unique eris is scaffold 340, which is lacking in erip and gili

