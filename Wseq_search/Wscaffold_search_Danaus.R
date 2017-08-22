# setwd("/Users/jamiewalters/Documents/Projects/Danaus_NeoZ/Wseq_search")

####################
# Searching for potential W-linked scaffold
####################

coveragedata <- read.table("../input_files/mergedcoveragedepth.txt",header=T, stringsAsFactors = F)

# Exploring missing data
apply(coveragedata, MARGIN = 2, function(x) {sum(is.na(x))}) # how many scaffolds with missing data in each sample
coveragedata[apply(coveragedata, MARGIN = 1, function(x) {any(is.na(x))}) ,] # print data for scaffolds with NAs


##normalize coverage data
tmp <- t (t(coveragedata[,3:8]) / colMeans(coveragedata[,3:8], na.rm = T) )  #JRW
covw <- cbind(coveragedata[, 1:2], tmp)
normcov <- covw[order(covw$Length, decreasing = T), ]  # reorder data by scaffold length
# if (is.unsorted(normcov$Length) ) {stop("normcov vector isn't sorted by length") } # 



# normalcoverage <- coverageforz[coverageforz$Scaffold %in% genescaff.Dp$scaff.tar, ]

m.ind <-c(3,6,8)
f.ind <-c(4,5,7)

malemean2 <- rowMeans(normcov[, m.ind], na.rm = T)
femalemean2 <- rowMeans(normcov[, f.ind], na.rm = T)
#now make the ratio
normcov$log2mf <- log2(malemean2/femalemean2)

sum(is.na(normcov$log2mf)) # about 500 scaffolds are NA for M/F ratio, but this because they are all hugely missing data. best to remove them
normcov[ is.na(normcov$log2mf), ]
normcov<- normcov[! is.na(normcov$log2mf), ]


# Plot male vs female coverage by scaffold length
plot(normcov$log2mf ~ log10(normcov$Length), pch = 19, cex = .4, main = "Male:Female Scaffold Coverage in Dplex")
abline(v = log10(3000))
# Clear line at 3kb where scaffolds were not assembled.


normcov[normcov$Length > 3000 & normcov$log2mf < -1,]
possible.w <- cbind(normcov[normcov$Length > 3000 & normcov$log2mf < -1, 1:2], round(normcov[normcov$Length > 3000 & normcov$log2mf < -1,3:9], 3))

write.csv(possible.w, file = "Possible_W_seqs_Dplex.csv", row.names = F, quote = F)

gooddata <- apply(normcov[,3:8], MARGIN = 1, function(x) {sum(na.omit(x) > 0) > 3} ) # logical vector subsetting where >3 samples have good data.
normcov[gooddata & normcov$log2mf < -2 ,]
