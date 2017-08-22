# Instructions for use of these functions

# The "do.liftover()" function requires 3 dataframes with very specific names.  Here "target" genome refers to genome to which chromosomal linkage is being assigned and "reference" is the genome for which linkage mapping has already assigned scaffolds & genes to chromosomes.

# 1)  orthos         : a 2-column dataframe of 1:1 orthologs between target genome and reference genome. DF names must be "gene.tar" (representing gene IDs for target species) and "gene.ref" for reference species gene IDs.  NOTE: only 1:1 orthologs should be included.
# 2)  genechr.ref    : a 2-column dataframe specifying the chromosome ID (where known) for genes in the reference species.  DF names must be "gene.ref" and "chr.ref" for reference gene and chromosome IDs, respectively.
# 3)  genescaff.tar  : a 2-column dataframe specifying the scaffold for each gene in the target species.  DF names must be "gene.tar" and "scaff.tar" for gene and scaffold IDs, respectively.


max.ind <- function(x) {which(x == max(na.omit(x)))}  #function to find index of largest value in array

do.liftover <- function (orthos, genechr.ref, genescaff.tar, filebase) {
	
	#lift over dataframe
	lo <-  merge( orthos , genechr.ref, by="gene.ref") # this gives reference chromosome assignments to each ortholog pair
	lo <-  merge( lo, genescaff.tar, by="gene.tar")  # this adds in target scaffold assignments for each ortholog pair
	
	# tabulate ortholog counts across reference chromosomes for each target scaffold
	scaff.chr.tab <- tapply(X=lo$scaff.tar, INDEX=list(lo$scaff.tar, lo$chr.ref), length)
	scaff.chr.tab[is.na(scaff.chr.tab)] <- 0  # Assign 0 to positions where no orthologs are observed
	
	max.ind <- function(x) {which(x == max(na.omit(x)))}  #function to find index of largest value in vector
	
	scaff.maxchr.list <- apply(scaff.chr.tab, 1, max.ind) # this gives a list because in some cases, for a given scaffold, there are ties between reference chromosomes fro the maximum number of orthologs.  So we can figure out how many 'max' reference chromosomes are reported for each target scaffold by checking length of each list item.  Then we can get the names of those target scaffolds and look at the original counts of matched orthologs per chromosome.  Typically they are all ties of one or two genes, so not worth worrying about, and there only a few.  Ultimately I just remove these as if they simply had unmapped orthologs.
	
	maxchr.count <- sapply(scaff.maxchr.list, length) # count the number of "max chromosomes" per target scaffold, which may be > 1 with ties.
	tied.chroms <- scaff.maxchr.list[maxchr.count > 1] #tied.chroms is a list of target scaffolds with ties for chromosomes with maximum count of ortholos.
	tied.chroms.mat <- scaff.chr.tab[which(rownames(scaff.chr.tab) %in% names(tied.chroms) ) , ]
	
	final.vec <- unlist(scaff.maxchr.list[maxchr.count == 1], use.names = F)  
	# have to drop names, since it appends the matrix column name to the scaffold (list)
	# only report target scaffolds with a single max count of orthologs per reference chrom
	
	tar.scaff.chr <- data.frame("scaff.tar"= names(scaff.maxchr.list[maxchr.count == 1]), chr.tar=levels(genechr.ref$chr.ref)[final.vec]  )
	# thus tar.scaff.chr provides the assigned chromosome for each target scaffold, based on max ortholog counts.
	
	lo.chrtar.orthos <- merge(lo, tar.scaff.chr)
	# assigns target genes to putative target chromosome based on target scaffold assignment

	all.tar.genes <- merge(genescaff.tar, tar.scaff.chr, all.x=TRUE)

	write.table(tar.scaff.chr, file = paste(filebase, "_scaff-chrom.txt", sep=''), quote = F, sep="\t", row.names=FALSE)
	write.table(tied.chroms.mat, file = paste(filebase, "_tied-chroms.txt", sep=''), quote = F, sep="\t", row.names=FALSE)
	write.table(all.tar.genes, file = paste(filebase, "_genes-chrom.txt", sep=''), quote = F, sep="\t", row.names=FALSE)
	
	Ntar.genes <- nrow(genescaff.tar) # total number of protein coding genes in target
	Ntar.genesOnChrom <- sum( ! is.na(all.tar.genes$chr.tar)) # number of target genes assigned to chromosome
	Ntar.scaffsOnChrom <- nrow(tar.scaff.chr) # number of target scaffolds assigned to chromosomes
	N1to1 <- nrow(orthos) # number of 1:1 orthologs identified
	Northos.refChr <- nrow(lo) # number of 1:1 orthologs assigned to reference chromosome
	
	sumryFile <- paste(filebase, "_summary.txt", sep='')
	cat(Ntar.genes, "total number of protein coding genes in target\n", sep="\t", file = sumryFile)
	cat(Ntar.genesOnChrom, "number of target genes assigned to chromosome\n", sep="\t", file = sumryFile, append=T)
	cat(round(Ntar.genesOnChrom/Ntar.genes, digits=3), "percent of target genes assigned to chromosome\n", sep="\t", file = sumryFile, append=T)
	cat(Ntar.scaffsOnChrom, "number of target scaffolds assigned to chromosomes\n", sep="\t", file = sumryFile, append=T)
	cat(N1to1, "number of 1:1 orthologs identified\n", sep="\t", file = sumryFile, append=T)
	cat(Northos.refChr, "number of 1:1 orthologs assigned to reference chromosome\n",  sep="\t", file = sumryFile, append=T)
	cat(round(Northos.refChr/N1to1, digits=3), "percent of 1:1 orthologs assigned to reference chromosome\n",  sep="\t", file = sumryFile, append=T  )
	
	
	outdata <- list("scaffolds.assigned"= tar.scaff.chr,  # target scaffolds assigned to a reference chromosome
					"gene.assigned.orthos" = lo.chrtar.orthos,  # Orthologous genes with chromosomal linkage assigned in each species, for bubble plot
					"tied.chroms" = tied.chroms.mat, # matrix of target scaffolds ortholog count per ref chr with ties for "max" orthologs
					"target.genes.chr" = all.tar.genes,
					"scaff.chr.table" = scaff.chr.tab
					 )
	return(outdata)

}



make.bubplot <- function(genes, fore="white", back="steelblue", inches = 0.2, ...) {
	# create matrx of cross-tabulating orthologs per chromosome in target and reference
	syn <- tapply(genes$chr.tar, list(genes$chr.tar, genes$chr.ref), length)
	ord <- apply(syn, 1, max.ind )          # gives index(i.e. ref chrom) of each target chrom with most orthologs
	syn.ord <- syn[names(sort(ord)),]  # reorders matrix so target chroms are 'on diagonal' with reference chrom. 


	#pre-allocate dataframe for plotting
	nChrom <- nrow(syn.ord)
	n <- nChrom^2
	bub.dat <- data.frame( 	"ref.chrom"=rep(NA,n),
					   		"y.val"=rep(1:nChrom, nChrom),
					   		"orth.count"=rep(NA,n),
					   		"targ.chr"= rep(names(sort(ord)), nChrom)
					   )
	for (i in 0:(nChrom-1)) {
		index<-1:nChrom+i* nChrom 
		bub.dat$ref.chrom[index] <- rep(i+1, nChrom)
		bub.dat$orth.count[index] <- syn.ord[,i+1]
	}
	
	orth.not0 <- bub.dat$orth.count > 0
	
	symbols(x = bub.dat$ref.chrom[orth.not0], y = bub.dat$y.val[orth.not0], circles = sqrt(bub.dat$orth.count[orth.not0]),
			inches = inches, fg=fore, bg=back, 
			xlim=c(1,nChrom), ylim=c(1,nChrom), bty="n", yaxt = 'n', xaxt = 'n',
			panel.first=abline(v=1:nChrom, h=1:nChrom,  col="lightgray", lty="dotted"), ...
	 )
	axis(side=1, at=seq(1, nChrom, by=1), labels=c("Z",2:(nChrom)), cex.axis=0.8) # pos=0, 
	axis(side=2, at=1:nChrom, labels=names(sort(ord)), cex.axis=.8)
	
	return(bub.dat)

}





make.bubplot.grey1 <- function(genes, fore="grey40", back="black", inches = 0.2, ...) {
	# create matrx of cross-tabulating orthologs per chromosome in target and reference
	syn <- tapply(genes$chr.tar, list(genes$chr.tar, genes$chr.ref), length)
	ord <- apply(syn, 1, max.ind )          # gives index(i.e. ref chrom) of each target chrom with most orthologs
	syn.ord <- syn[names(sort(ord)),]  # reorders matrix so target chroms are 'on diagonal' with reference chrom. 


	#pre-allocate dataframe for plotting
	nChrom <- nrow(syn.ord)
	n <- nChrom^2
	bub.dat <- data.frame( 	"ref.chrom"=rep(NA,n),
					   		"y.val"=rep(1:nChrom, nChrom),
					   		"orth.count"=rep(NA,n),
					   		"targ.chr"= rep(names(sort(ord)), nChrom)
					   )
	for (i in 0:(nChrom-1)) {
		index<-1:nChrom+i* nChrom 
		bub.dat$ref.chrom[index] <- rep(i+1, nChrom)
		bub.dat$orth.count[index] <- syn.ord[,i+1]
	}
	
	orth.not0 <- bub.dat$orth.count > 0
	par(bg="grey90")
	symbols(x = bub.dat$ref.chrom[orth.not0], y = bub.dat$y.val[orth.not0], circles = sqrt(bub.dat$orth.count[orth.not0]),
			inches = inches, fg=fore, bg=back, 
			xlim=c(1,nChrom), ylim=c(1,nChrom), bty="o", yaxt = 'n', xaxt = 'n',
			panel.first=abline(v=1:nChrom, h=1:nChrom,  col="white", lty=1, lwd=0.5), ...
	 )
	axis(side=1, at=seq(1, nChrom, by=1), labels=c("Z",2:(nChrom)), cex.axis=0.8) # pos=0, 
	axis(side=2, at=1:nChrom, labels=names(sort(ord)), cex.axis=.8)
	
		return(bub.dat)

}




make.bubplot.grey <- function(genes, fore="grey40", back="black", inches = 0.2, xaxLab=NULL, yaxLab=NULL, ...) {
	# create matrx of cross-tabulating orthologs per chromosome in target and reference
	syn <- tapply(genes$chr.tar, list(genes$chr.tar, genes$chr.ref), length)
	ord <- apply(syn, 1, max.ind )          # gives index(i.e. ref chrom) of each target chrom with most orthologs
	syn.ord <- syn[names(sort(ord)),]  # reorders matrix so target chroms are 'on diagonal' with reference chrom. 


	#pre-allocate dataframe for plotting
	nChrom <- nrow(syn.ord)
	n <- nChrom^2
	bub.dat <- data.frame( 	"ref.chrom"=rep(NA,n),
					   		"y.val"=rep(1:nChrom, nChrom),
					   		"orth.count"=rep(NA,n),
					   		"targ.chr"= rep(names(sort(ord)), nChrom)
					   )
	for (i in 0:(nChrom-1)) {
		index<-1:nChrom+i* nChrom 
		bub.dat$ref.chrom[index] <- rep(i+1, nChrom)
		bub.dat$orth.count[index] <- syn.ord[,i+1]
	}
	
	orth.not0 <- bub.dat$orth.count > 0


	layo <- layout(matrix(c(1,2),1,2),  widths=c(9,1) )
	
	plot(x = bub.dat$ref.chrom[orth.not0], y = bub.dat$y.val[orth.not0], type = "n", axes=FALSE, ...)
	rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr")[4], col = "grey90")
	abline(v=1:nChrom, h=1:nChrom,  col="white", lty=1, lwd=0.5)
	symbols(x = bub.dat$ref.chrom[orth.not0], y = bub.dat$y.val[orth.not0], circles = sqrt(bub.dat$orth.count[orth.not0]),
			inches = inches, fg=fore, bg=back, add=TRUE,
			xlim=c(1,nChrom), ylim=c(1,nChrom), bty="o", yaxt = 'n', xaxt = 'n', 
	 )
	 
	if( is.null(xaxLab) ) { xaxLab <- 1:nChrom }
	if( is.null(yaxLab) ) { yaxLab <- 1:nChrom }
		 
	axis(side=1, at=1:nChrom, labels=xaxLab, cex.axis=0.8) # pos=0, 
	axis(side=2, at=1:nChrom, labels=yaxLab, cex.axis=.8, las=2)
	
	par(mar=rep(.1,4)) #oma=rep(.1,4)
	plot(x=rep(1, 5), y=1:5, type = "n", axes=F, bty="n")
	
	gene.count <- c(1,10,100, 500)
	ystart <- 2.5
	ypos <- seq(ystart, ystart+(length(gene.count)-1)*.3, .3)
	labelpos <- ypos-seq(.1, .175, .025)
	xpos <- 0.3
	
	symbols( x=rep(xpos, length(gene.count)), y=ypos, circles = sqrt(gene.count)  , inches=inches, fg=fore, bg=back, add=TRUE, xpd=NA)
#	text(x=rep(xpos, length(gene.count)), y=labelpos, labels = c( "1", "10", "100", "500"), xpd=T, cex = 0.8, , xpd=NA)
	text(x=rep(xpos, length(gene.count)), y=ypos, pos = 4, offset = 1, labels = c( "1", "10", "100", "500"), xpd=T, cex = 0.8, , xpd=NA)
	
	text(x=xpos+.2, y= tail(ypos, 1)+.3, labels = "Number\nof genes", cex =.9, xpd=NA)
	
	return(bub.dat)

}


