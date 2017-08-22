# Import median coverage data
#mergedcoveragedepth.txt
coveragedata <- read.table(file.choose(),header=T,stringsAsFactors = F)

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
coverageforz <- coverageforz[ nonZero & notShort , ] 


#now we get our normalizer for the individual scaffold stuff
normconverter <- apply(coverageforz[,3:8], 2, mean)

#function to normalize scaffolds
scaffoldpipe <- function(x)
{
	scaff <- read.table(x,header = T)
	scaff <- na.omit(scaff)
	scaff <- scaff[order(scaff$Base),]
	normscaff <- t(t(scaff[3:8])/normconverter)
	return(normscaff)
}


scaff01 <-scaffoldpipe("/Users/Andrew/Downloads/test/merged01.txt")
M01 <- (scaff01[,1] + scaff01[,4] + scaff01[,6])/3
F01 <- (scaff01[,2] + scaff01[,3] + scaff01[,5])/3

##pls note scaffold 28's merged file is ordered differently for some reason unknown to Man and God alike
scaff28 <-scaffoldpipe("/Users/Andrew/Downloads/test/merged28.txt")
M28 <- (scaff28[,1] + scaff28[,3] + scaff28[,5])/3
F28 <- (scaff28[,2] + scaff28[,4] + scaff28[,6])/3

##44 also has a goofy order, ten cuidado
scaff44 <-scaffoldpipe("/Users/Andrew/Downloads/test/merged44.txt")
M44 <- (scaff44[,1] + scaff44[,4] + scaff44[,6])/3
F44 <- (scaff44[,2] + scaff44[,3] + scaff44[,5])/3

scaff403 <-scaffoldpipe("/Users/Andrew/Downloads/test/merged403.txt")
M403 <- (scaff403[,1] + scaff403[,4] + scaff403[,6])/3
F403 <- (scaff403[,2] + scaff403[,3] + scaff403[,5])/3


par(mfrow=c(2,4))
plot(1:length(M01),M01,ylim=c(0,4),type="h")
plot(1:length(M28),M28,ylim=c(0,4),type="h")
plot(1:length(M44),M44,ylim=c(0,4),type="h")
plot(1:length(M403),M403,ylim=c(0,4),type="h")
plot(1:length(F01),F01,ylim=c(0,4),type="h")
plot(1:length(F28),F28,ylim=c(0,4),type="h")
plot(1:length(F44),F44,ylim=c(0,4),type="h")
plot(1:length(F403),F403,ylim=c(0,4),type="h")
