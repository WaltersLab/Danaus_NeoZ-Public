# source necessary functions

source("liftover_bubble_functions.R")
source("../output/NormCov_DataFrame.R")

# read in relevant Dplex data

genescaff.Dp  <- read.delim(file = "../input_files/dplex_gene-scaff.txt", stringsAsFactors = F, header=F, col.names = c("scaff.tar","gene.tar"))

#scaffolds identifed as Z scaffs from sequence coverage:
Zscaffs <- normcov[normcov$log2mf > 0.5, "Scaffold"]
# Zscaff_nums <- c(300001,300003,300005,300012,300028,300066,300068,300075,300083,300134,300145,300146,300498)
# Zscaffs <- paste("DPSCF", Zscaff_nums, sep = "")  








######################
# Melitaea
######################

# read in and format M. cinxia data... need orthos & genechr.ref DFs 

# orthology for Mc
orthos.pre.Mc <- read.delim(file= "../input_files/dplex_v_mcinx.proteinortho.noPa.txt", stringsAsFactors = F)
names(orthos.pre.Mc) <- c("nspecies", "ngenes", "alg.conn", "gene.tar", "gene.ref")  #rename columns to R-friendly text
orthos.Mc <- orthos.pre.Mc[orthos.pre.Mc$ngenes == 2, 4:5]  # restrict analysis to 1-to-1 orthologs

# reference chromosomal linkage for Mc
mc.scaffChr <- read.delim(file="../input_files/Melitaea_cinxia_scaffolds2chr_v1.txt",stringsAsFactors = F, col.names = c("scaffold.mc", "chr", "bin", "cM"))
mc.scaffChr$chr <- as.factor(mc.scaffChr$chr )
mc.gene_scaff <- read.delim(file="../input_files/mcinx_gene-scaff.txt", header =F, stringsAsFactors = F, col.names = c("scaffold.mc","gene.mc"))
mc <- merge(x=mc.gene_scaff, y=mc.scaffChr[, 1:2]) # make a single DF with gene, scaffold, and chromosome for Mcinx
genechr.ref.Mc <- data.frame("gene.ref"=mc$gene.mc, "chr.ref"=mc$chr, stringsAsFactors = F)



mc.lo  <- do.liftover(orthos=orthos.Mc, genechr.ref = genechr.ref.Mc, genescaff.tar = genescaff.Dp, filebase="../output/Mcinx/Mcinx-Dplex")

pdf(file = "../output/Mcinx/Mcinx-Dplex_bubble.pdf", w=8, h=8, pointsize=12)
mc.bub <- make.bubplot.grey(genes = mc.lo[[2]], main=expression(paste("Ortholog Chromosomal Co-localization: ", italic("M. cinxia vs. D. plexippus"))), 
xlab="M. cinxia chromosome", ylab="putative D. plexippus chromosome", inches = .1, cex.lab=.8 )
dev.off()


scaff.chrZ.mc <- mc.lo$scaff.chr.table[ rownames(mc.lo$scaff.chr.table) %in% Zscaffs , ]
write.table(scaff.chrZ.mc , file="../output/Mcinx/Mcinx-Dplex_Zscaff_OrthoChromCount.txt", quote = F, sep="\t", row.names=FALSE)



######################
# Heliconius
######################


# read in proteinortho results:
dp.hm.ortho <- read.delim(file= "../input_files/dplex_v_hmel.proteinortho_noPA.txt", stringsAsFactors = F)
names(dp.hm.ortho) <- c("nspecies", "ngenes", "alg.conn", "gene.hm", "gene.dp")  #rename columns to R-friendly text
dp.hm.ortho <- dp.hm.ortho[dp.hm.ortho$ngenes == 2, 4:5]  # restrinct analysis to 1-to-1 orthologs
names(dp.hm.ortho) <- c("gene.ref", "gene.tar")



# read in Heliconius gene-chromosome assignment
hmel_chr_table <- read.delim(file ="../input_files/Hmel1-1_chrom-gene_Zcorrected_20120730.txt", stringsAsFactors = F)
# remove Hmel genes that are not reliably mapped to chromosome.
hmel_chr_table <- hmel_chr_table[hmel_chr_table$chrom != "split" & !is.na(hmel_chr_table$chrom),]
hmel_chr_table$chrom <- factor(hmel_chr_table$chrom, levels = c("Z",1:20), ordered=is.ordered(c("Z",1:20))) # order chromosomes as factors
genechr.ref.Hm <- hmel_chr_table[ , c("gene", "chrom")]
names(genechr.ref.Hm) <- c("gene.ref", "chr.ref")


hm.lo  <- do.liftover(orthos=dp.hm.ortho, genechr.ref = genechr.ref.Hm, genescaff.tar = genescaff.Dp, filebase="../output/Hmelp/Hmelp-Dplex")

pdf(file = "../output/Hmelp/Hmelp-Dplex_bubble.pdf", w=8, h=8)
hm.bub <- make.bubplot.grey(genes = hm.lo[[2]], fore = "grey40", main="Macrosynteny: H. melpomene vs D. plexippus", 
xlab="H. melpomene chromosome", ylab="putative D. plexippus chromosome" )

dev.off()



scaff.chrZ.hm <- hm.lo$scaff.chr.table[ rownames(hm.lo$scaff.chr.table) %in% Zscaffs , ]
write.table(scaff.chrZ.hm , file="../output/Hmelp/Hmelp-Dplex_Zscaff_OrthoChromCount.txt", quote = F, sep="\t", row.names=FALSE)


######################
# Bombyx
######################

# read in bombyx orthology data
dp.bm.ortho <- read.delim(file= "../input_files/dplex_v_bmori.proteinortho_cleaned.txt", stringsAsFactors = F)
names(dp.bm.ortho) <- c("nspecies", "ngenes", "alg.conn", "gene.bm", "gene.dp")  #rename columns to R-friendly text
dp.bm.ortho <- dp.bm.ortho[dp.bm.ortho$ngenes == 2, 4:5]  # restrict analysis to 1-to-1 orthologs
names(dp.bm.ortho) <- c("gene.ref", "gene.tar")



# read bombyx gene, scaffold, and chromosomal info
bm.prot.scaff <- read.delim(file="../input_files/bombyx_refseq_prot-scaff_cleaned.txt", stringsAsFactors =F, header = F, col.names = c("scaff.bm", "gene.bm"))
ncbi.scaffs <- read.delim(file="../input_files/bombyx_ncbi_scaffold_names_cleaned.txt", stringsAsFactors = F, skip = 1) #read in table of scaffolds mapped to chromosomes
bm_chr_table <- read.table(file = "../input_files/correspondence_table_Bmscaf_nscaf.txt", stringsAsFactors=F, header=T ) #read in scaffold & chromosome


#link up Bmori genes to scaffolds
bm.scaff.chr <- merge(ncbi.scaffs[,2:3], bm_chr_table[,c(1,3)], by.x="Genome_Acc", by.y="accession")
bm.gene.chr <- merge(bm.prot.scaff, bm.scaff.chr, by.y="RefSeq_Acc", by.x="scaff.bm")
genechr.ref.Bm <- bm.gene.chr[, c(2,4)]
names(genechr.ref.Bm) <- c("gene.ref", "chr.ref")
genechr.ref.Bm$chr.ref <- as.factor(genechr.ref.Bm$chr.ref)


bm.lo  <- do.liftover(orthos=dp.bm.ortho, genechr.ref = genechr.ref.Bm, genescaff.tar = genescaff.Dp, filebase="../output/Bmori/Bmori-Dplex")



pdf(file = "../output/Bmori/Bmori-Dplex_bubble.pdf", w=8, h=8)
bm.bub <- make.bubplot.grey(genes = bm.lo[[2]], fore = "grey40", main="Macrosynteny: B. mori vs D. plexippus", 
xlab="B. mori chromosome", ylab="putative D. plexippus chromosome" )
dev.off()


scaff.chrZ.bm <- bm.lo$scaff.chr.table[ rownames(bm.lo$scaff.chr.table) %in% Zscaffs , ]
write.table(scaff.chrZ.bm , file="../output/Bmori/Bmori-Dplex_Zscaff_OrthoChromCount.txt", quote = F, sep="\t", row.names=FALSE)



# for M.cinx, Chr21 is fused to Z.



plot.cov <- function( dpZ = Zscaffs, lo=mc.lo[[1]],  ...) { # this plot only colors Zcov scaffolds by assigned chr. Omits non-Zcov scaffolds on those chr.
	#check to see if all Zscaffs from coverage have putative chr assigned.
	if ( ! all(dpZ %in% lo$scaff.tar) ) {
		warning("Not all Dp Z-coverage scaffolds have been assigned to scaffolds\n")
	}
	
	dpZ.chr <- lo[ lo$scaff.tar %in% dpZ ,  ]  # extract scaffold-chr pairings for Z-cov scaffolds
	dpZ.chr.cov <- merge(x=normcov, y=dpZ.chr, by.x="Scaffold", by.y="scaff.tar")
	dpZ.chr.cov$chr.tar <- droplevels(dpZ.chr.cov$chr.tar)	
	normcov.A <- normcov[ ! normcov$Scaffold %in% dpZ.chr.cov$Scaffold, ]  # drop levels to faciliate plotting with colors
	
	chr.col <- c("blue","green3") # colors for plotting

	plot(log10(normcov.A$Length), normcov.A$log2mf, pch = 19, ylim=c(-0.5, 1.4) , xlim = c(5.2,7) ,
	 ylab="Log2[ Male:Female coverage ]", xlab = "Log10[ Scaffold Length (bp) ]", ...)  

	points( log10(dpZ.chr.cov$Length), dpZ.chr.cov$log2mf, col=chr.col[dpZ.chr.cov$chr.tar], pch = 19,  ... )
	
	legend("topright", title="Reference Chromosome", pch=19, bty="o", cex=0.9, horiz=T,
	legend=c( levels(dpZ.chr.cov$chr.tar)[sort(unique(dpZ.chr.cov$chr.tar))], "Other"), col=c(chr.col, "black")[sort(c(unique(dpZ.chr.cov$chr.tar), 3))]   )
	
	abline(h=1, col="red", lty=2)
	abline(h=0, col="black", lty=2)
	
#	return(dpZ.chr.cov)

}


plot.cov.recip <- function( dpZ = Zscaffs, lo=mc.lo[[1]], legend.title="Reference Chromosome", ...) { # this function colors all scaffolds assigned to a chromosome that has any Zcov-scaffolds.
	#check to see if all Zscaffs from coverage have putative chr assigned.
	if ( ! all(dpZ %in% lo$scaff.tar) ) {
		warning("Not all Dp Z-coverage scaffolds have been assigned to scaffolds\n")
	}
	
	dpZ.chr <- unique(lo$chr.tar[ lo$scaff.tar %in% dpZ ])  # extract unique set of chr assignments for any Z-cov scaffolds
	dpZ.chr.scaffs <- lo[lo$chr.tar %in% dpZ.chr , ]  # pull out all scaffolds assigned to chrs with any Z-cov scaffolds
	
	dpZ.chr.cov <- merge(x=normcov, y=dpZ.chr.scaffs, by.x="Scaffold", by.y="scaff.tar")
	dpZ.chr.cov$chr.tar <- droplevels(dpZ.chr.cov$chr.tar)	
	normcov.A <- normcov[ ! normcov$Scaffold %in% dpZ.chr.cov$Scaffold, ]  # drop levels to faciliate plotting with colors
	
	chr.col <- c("blue","green3") # colors for plotting

	plot(log10(normcov.A$Length), normcov.A$log2mf, pch = 19, ylim=c(-0.5, 1.4) , xlim = c(5.2,7) ,
	 ylab="Log2[ Male:Female coverage ]", xlab = "Log10[ Scaffold Length (bp) ]", ...)  

	points( log10(dpZ.chr.cov$Length), dpZ.chr.cov$log2mf, col=chr.col[dpZ.chr.cov$chr.tar], pch = 19,  ... )
	
	legend("topright", title=legend.title, pch=19, bty="o", cex=0.9, horiz=T,
	legend=c( levels(dpZ.chr.cov$chr.tar)[sort(unique(dpZ.chr.cov$chr.tar))], "Other"), col=c(chr.col, "black")[sort(c(unique(dpZ.chr.cov$chr.tar), 3))]   )
	
	abline(h=1, col="red", lty=2)
	abline(h=0, col="black", lty=2)
	
	return(dpZ.chr.cov)
}

pdf(file = "../output/Mcinx/M-FCovRatio_ByZchrom_Mcinx.pdf", w=6, h=5, pointsize=10)
par(mar=c(5,5,1,1))
Mctmp <- plot.cov.recip(lo = mc.lo[[1]],  legend.title=expression(paste(italic("M. cinxia"), " reference chromosome", sep= " ")) , cex = .9)
dev.off()



pdf(file = "../output/Hmelp/M-FCovRatio_ByZchrom_Hmelp.pdf", w=6, h=5, pointsize=10)
par(mar=c(5,5,1,1))
Hmtmp <- plot.cov.recip(lo = hm.lo[[1]],  legend.title=expression(paste(italic("H. melpomene"), " reference chromosome", sep= " ")) , cex = .9)
dev.off()


pdf(file = "../output/Bmori/M-FCovRatio_ByZchrom_Bmori.pdf", w=6, h=5, pointsize=10)
par(mar=c(5,5,1,1))
Bmtmp <- plot.cov.recip(lo = bm.lo[[1]],  legend.title=expression(paste(italic("B. mori"), " reference chromosome", sep= " ")) , cex = .9)
dev.off()


# Investigating DPSCF300001
mc.lo[[5]][rownames(mc.lo[[5]]) == "DPSCF300001", ]
bm.lo[[5]][rownames(bm.lo[[5]]) == "DPSCF300001", ]
hm.lo[[5]][rownames(hm.lo[[5]]) == "DPSCF300001", ]
normcov[normcov$Scaffold == "DPSCF300001",]


# Investigating DPSCF300044
mc.lo[[5]][rownames(mc.lo[[5]]) == "DPSCF300044", ]
bm.lo[[5]][rownames(bm.lo[[5]]) == "DPSCF300044", ]
hm.lo[[5]][rownames(hm.lo[[5]]) == "DPSCF300044", ]
normcov[normcov$Scaffold == "DPSCF300044",]


# Investigating DPSCF300403
mc.lo[[5]][rownames(mc.lo[[5]]) == "DPSCF300403", ]
bm.lo[[5]][rownames(bm.lo[[5]]) == "DPSCF300403", ]
hm.lo[[5]][rownames(hm.lo[[5]]) == "DPSCF300403", ]
normcov[normcov$Scaffold == "DPSCF300403",]


mc.lo[[5]][rownames(mc.lo[[5]]) == "DPSCF300028", ]


# In order to make sequence alignments between DPSCF300001 and relevant reference chromosomes, I first need to fish out the genes in question from the references.

mc.fusion.genes <- mc.lo$gene.assigned.orthos$gene.ref[mc.lo$gene.assigned.orthos$scaff.tar ==  "DPSCF300001"]
hm.fusion.genes <- hm.lo$gene.assigned.orthos$gene.ref[hm.lo$gene.assigned.orthos$scaff.tar ==  "DPSCF300001"]
bm.fusion.genes <- bm.lo$gene.assigned.orthos$gene.ref[bm.lo$gene.assigned.orthos$scaff.tar ==  "DPSCF300001"]

write(mc.fusion.genes, file = "../output/align_scaf30001/mc_fusion_orthlogs.txt", ncolumns=1)
write(hm.fusion.genes, file = "../output/align_scaf30001/hm_fusion_orthlogs.txt", ncolumns=1)
write(bm.fusion.genes, file = "../output/align_scaf30001/bm_fusion_orthlogs.txt", ncolumns=1)