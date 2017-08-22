############################################################
##what if we re-examine the median coverage?
##choose mergedcoveragedepth.txt
coveragedata=read.table("mergedcoveragedepth.txt",header=T)
##remove incomplete cases
coverageforz=na.omit(coveragedata)
##normalize
#we'll iterate over all the data columns
#and divide individual values by means for each sample
normalcoverage=coverageforz
for(i in 3:8)
{
	for(j in 1:length(normalcoverage[,1]))
	{
		normalcoverage[j,i]=normalcoverage[j,i]/mean(normalcoverage[,i])
	}
}


tmp <- t (t(coverageforz[,3:8]) / colMeans(coverageforz[,3:8]) )  #JRW
normalcoverage[,3:8] <- tmp  #JRW

plot(tmp[,1]~normalcoverage[,3])
#separate males and females and get means
malemean2=(normalcoverage[,3] + normalcoverage[,6] + normalcoverage[,8])/3
femalemean2=(normalcoverage[,4] + normalcoverage[,5] + normalcoverage[,7])/3
#now make the ratio
countratio2=log2(malemean2/femalemean2)
plot(normalcoverage$Scaffold,countratio2)


plot(log10(normalcoverage$Length),countratio2, cex = .5, pch = 19)  # JRW
points(log10(normalcoverage$Length[inds]),countratio2[inds], col="red")
abline(h=1, col="blue", lty=2)
abline(h=0, col="black", lty=2)

##cool now let's assess significance
##first focus on the non-noisy portion
subber=data.frame(normalcoverage$Scaffold[1:500],countratio2[1:500])
subber=as.numeric(subber)
answer=subber[which(subber[,2] >.5),]
##we get 12 scaffolds out of this##
inds=c(1,3,5,12,28,66,68,75,83,134,145,146,498)
plot(normalcoverage$Scaffold,countratio2, main="By Coverage Depth", xlab="Scaffold",xlim=c(0,400),ylim=c(-2,2))
#we'll flag all the scaffolds identified by coverage depth with red
points(inds,countratio2[inds],col="red")

#making a histogram of coverage differences
hist.data=hist(countratio2[1:500],breaks=seq(-2,2,.1))
hist.data$counts = log10(hist.data$counts)
plot(hist.data, ylab='log10(Frequency)',ylim=c(0,2.5),xlim=c(-1.5,1.5),
main="Distribution of coverage difference between sexes",xlab="Log2(Male/Female)")

##let's look at scaffold 28 
##choose merged28.txt
merged28=read.table(file.choose(),header=T)
merged28=na.omit(merged28)
meandude=(merged28[,3]+merged28[,5]+merged28[,7])/3
meanchick=(merged28[,4]+merged28[,6]+merged28[,8])/3
therat=log2(meandude/meanchick)
plot(merged28$Base,therat,ylim=c(-5,5),pch=19,col=rgb(0,0,0,alpha=.01))
plot(merged28$Base,merged28$M36M)