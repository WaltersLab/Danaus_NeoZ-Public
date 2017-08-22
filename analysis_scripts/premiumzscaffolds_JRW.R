library(plotrix)

# Import median coverage data
coveragedata <- read.table("../input_files/mergedcoveragedepth.txt",header=T, stringsAsFactors = F)

# coveragedata[ apply(coveragedata[3:8], 1, function(x) any(is.na(x))) , ] filter for incomplete cases



# Import data on scaffolds with genes
# genescaff.Dp  <- read.delim(file = "./input_files/dplex_gene-scaff.txt", stringsAsFactors = F, header=F, col.names = c("scaff.tar","gene.tar"))


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



##normalize coverage data
tmp <- t (t(coverageforz[,3:8]) / colMeans(coverageforz[,3:8]) )  #JRW
coverageforz[,3:8] <- tmp  #JRW
normcov <- coverageforz[order(coverageforz$Length, decreasing = T), ]
# if (is.unsorted(normcov$Length) ) {stop("normcov vector isn't sorted by length") } # 



# normalcoverage <- coverageforz[coverageforz$Scaffold %in% genescaff.Dp$scaff.tar, ]

m.ind <-c(3,6,8)
f.ind <-c(4,5,7)

malemean2 <- rowMeans(normcov[, m.ind])
femalemean2 <- rowMeans(normcov[, f.ind])
#now make the ratio
normcov$log2mf <- log2(malemean2/femalemean2)

#countratio2 <- cbind(normalcoverage[, 1:2], countratio2)


pdf(file="../output/coverage_hist.pdf", w=6, h=6 , pointsize=10)
par(mar=c(5,5,1,1))
tmp <- hist(normcov$log2mf[normcov$log2mf < 0.5], bty="n", breaks = seq(-.25,.3,.05), xlim = c(-.5,1.5), xlab=("Log2( Male:Female coverage )"), col="grey", main="", lwd=0.5)
hist(normcov$log2mf[normcov$log2mf > 0.5],  breaks = seq(.65,1.15,.05), add=T, col="red")
ablineclip(v=0.5, lty=2, y1=0, y2=60, lwd = .9)
#abline(v=0.5, lty=2)
legend("topright", legend=c("Putative Autosomal scafffolds", "Putative Z-linked scaffolds"), fill=c("grey","red"), cex = 0.9, bg="white")
dev.off()


# Write out Z-linked scaffolds
Zscaffs <- normcov[normcov$log2mf > 0.5, "Scaffold"]
write(Zscaffs, file="../output/Dplex_Zscaffs.txt", ncolumns = 1)

# dump normalized coverage and ratios to file for reading into liftover script
dump("normcov", file="../output/NormCov_DataFrame.R")






# #plot coverage ratio by length to Z-linked scaffolds
#

pdf(file = "./output/M-FCovRatio_N90all.pdf", w=6, h=4, pointsize=10)
par(mar=c(5,5,1,1))
plot(log10(normcov$Length), normcov$log2mf, cex = .5, pch = 19, ylim=c(-0.5, 1.4),  xlog=F,
	 ylab="Log2[ Male:Female coverage ]", xlab = "Log10[ Scaffold Length (bp) ]"
)  # JRW
abline(h=1, col="red", lty=2)
abline(h=0, col="blue", lty=2)
dev.off()

####################
# Below this point is scratch or previous work not needed -- 11/16/2015
####################





# # create lists of all 3 possible pairwise combinations within sex
# Mcombos <- combn(m.ind, m = 2, simplify = F)
# Fcombos <- combn(f.ind, m = 2, simplify = F)
# combos <- c(Mcombos, Fcombos)

# #create a matrix with columns of log2ratios of coverage for each possible combination.
# ratios.inSex <- sapply( combos,  FUN = function(x) { log2(normcov[,x[1]] / normcov[ , x[2]]) })

# par(mfrow =c(2, 3))
# for (i in 1:6) {
	# title <- names(normcov)[combos[[i]]]
	# plot(log10(normcov$Length),ratios.inSex[, i], cex = .5, pch = 19, ylim=c(-6,6), xlim = c(2.45, 7), main=title)
# }

# # this checks for NAs in ratios.  Shouldn't be any after filtering applied at outset...
# # apply(ratios.inSex, 2, function(x) sum(is.na(x)))
# # normcov [ apply(ratios.inSex, 1, function(x) any(is.na(x))) , ]

# apply(ratios.inSex, 2, function(x) sum(!is.finite(x)))
# normcov [ apply(ratios.inSex, 1, function(x) any(is.na(x))) , ]


# ratio.sd.inSex <- apply(ratios.inSex, 1, sd)

# sd.win <- rollapply(ratio.sd.inSex*2, width = 30, FUN =mean, fill=NA)

# lines(log10(normcov$Length), sd.win, col="red")
# lines(lowess(log10(normcov$Length), ratio.sd.inSex, f = .01), col="red")

# is.unsorted(normcov$Length)

# #proving that scaffolds are not ordered by length
# # for (i in 1:nrow(normalcoverage)) {
	# # if (normalcoverage$Length[i] < normalcoverage$Length[i+1] ) {
		# # print(normalcoverage[ i + -1:1 , 1:2])
	# # }
# # }


# hist(normcov$log2mf, ylog = F, breaks = seq(-5,5,.05))


# #making a histogram of coverage differences
# hist.data=hist(countratio2[1:500],breaks=seq(-2,2,.1))
# hist.data$counts = log10(hist.data$counts)
# plot(hist.data, ylab='log10(Frequency)',ylim=c(0,2.5),xlim=c(-1.5,1.5),
# main="Distribution of coverage difference between sexes",xlab="Log2(Male/Female)")






# plot(log10(normcov$Length),normcov$log2mf, cex = .5, pch = 19, ylim=c(-0.5, 1.4) )  # JRW
# abline(h=1, col="blue", lty=2)
# abline(h=0, col="black", lty=2)
# abline(v=log10(10000), col="red")


# sum(coveragedata$Length[coveragedata$Length > 50000])/ sum(coveragedata$Length)



# ##cool now let's assess significance
# ##first focus on the non-noisy portion
# subber=data.frame(normalcoverage$Scaffold[1:500],countratio2[1:500])
# subber=as.numeric(subber)
# answer=subber[which(subber[,2] >.5),]
# ##we get 12 scaffolds out of this##
# inds=c(1,3,5,12,28,66,68,75,83,134,145,146,498)
# plot(normalcoverage$Scaffold,countratio2, main="By Coverage Depth", xlab="Scaffold",xlim=c(0,400),ylim=c(-2,2))
# #we'll flag all the scaffolds identified by coverage depth with red
# points(inds,countratio2[inds],col="red")

# #making a histogram of coverage differences
# hist.data=hist(countratio2[1:500],breaks=seq(-2,2,.1))
# hist.data$counts = log10(hist.data$counts)
# plot(hist.data, ylab='log10(Frequency)',ylim=c(0,2.5),xlim=c(-1.5,1.5),
# main="Distribution of coverage difference between sexes",xlab="Log2(Male/Female)")

# ##let's look at scaffold 28 
# ##choose merged28.txt
# merged28=read.table(file.choose(),header=T)
# merged28=na.omit(merged28)
# meandude=(merged28[,3]+merged28[,5]+merged28[,7])/3
# meanchick=(merged28[,4]+merged28[,6]+merged28[,8])/3
# therat=log2(meandude/meanchick)
# plot(merged28$Base,therat,ylim=c(-5,5),pch=19,col=rgb(0,0,0,alpha=.01))
# plot(merged28$Base,merged28$M36M)