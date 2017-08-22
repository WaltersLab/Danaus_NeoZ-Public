ColNames <- c("scaff", "source", "type", "start", "end", "score", "strand", "frame", "tags")
gff <- read.delim(file = "../input_files/DpScaff_28_44_01.gff", header=FALSE, col.names = ColNames, stringsAsFactors = FALSE)
gff$za <- rep(NA, length(nrow(gff)))
source("../output/ZA_chimera_breaks.R")

genes44 <- gff[gff$scaff == "DPSCF300044" & gff$type == "gene", ]
genes28 <- gff[gff$scaff == "DPSCF300028" & gff$type == "gene", ]
genes01 <- gff[gff$scaff == "DPSCF300001" & gff$type == "gene", ]

# Extract geneIDs from the last column of GFF. 
matches44 <- regexpr(pattern = "DPOGS\\d{6}", text=genes44$tag)
genes44$genes <- regmatches(genes44$tag, matches44)
matches28 <- regexpr(pattern = "DPOGS\\d{6}", text=genes28$tag)
genes28$genes <- regmatches(genes28$tag, matches28)
matches01 <- regexpr(pattern = "DPOGS\\d{6}", text=genes01$tag)
genes01$genes <- regmatches(genes01$tag, matches01)



# There are 11 genes on DPSCF300001 which are orthologous to McChr23.  These 11 genes should be positioned 3' of the predicted breakpoint at 5.84 Mbp.

putative.McChr23.genes <- mc.lo[[2]][ mc.lo[[2]]$scaff.tar == "DPSCF300001" & mc.lo[[2]]$chr.ref == 23 , "gene.tar"]

all(genes01$start[genes01$genes %in% putative.McChr23.genes]  > break.points["split01"] )
# so all the homologous genes here are on McChr23. I can reasonably assign them.

#function to detect whether any genes overlap with breakpoints.
breaks.in.genes <- function(gff, brpt) {
	overlap <- gff$start < brpt & gff$end > brpt
	return(sum(overlap))
}

breaks.in.genes(gff = genes44, brpt = break.points["split44"])
breaks.in.genes(gff = genes28, brpt = break.points["split28.1"])
breaks.in.genes(gff = genes28, brpt = break.points["split28.2"])
breaks.in.genes(gff = genes01, brpt = break.points["split01"])

# Print out any genes overlapping break points
genes44[ genes44$start < break.points["split44"]   & genes44$end > break.points["split44"] , ]
genes28[ genes28$start < break.points["split28.1"] & genes28$end > break.points["split28.1"] ,  ]
genes28[ genes28$start < break.points["split28.2"] & genes28$end > break.points["split28.2"] ,  ]
genes01[ genes01$start < break.points["split01"]   & genes01$end > break.points["split01"] , ]


# split28.2 does overlap, but for the timebeing I'm going to assign this to the Z for simplicity.
# Now we can partition the scaffolds by Z or A
new44 <- genes44[, c("scaff", "genes", "za")]

new44$chr <- ifelse(genes44$start < break.points["split44"],  1, NA) # genes less than breakpoint are Z, but uncertain about other parts
new44$scaff <- ifelse(genes44$start < break.points["split44"],  "DPSCF300044-1", "DPSCF300044-2")
new44$za <- ifelse(genes44$start < break.points["split44"],  "Z_anc", "A") # Z-linked genes in this segment are ancestral, autosomal otherwise 

new28 <- genes28[, c("scaff", "genes", "za")]
new28$chr <- numeric(length = nrow(genes28))
for(i in seq_along(new28$chr)) {
	if ( genes28$start[i] < break.points["split28.1"] ) {
		new28$chr[i] <- 9
		new28$scaff[i] <- "DPSCF300028-1"
		new28$za[i] <- "A"
	} else if ( genes28$start[i] > break.points["split28.1"]  &  genes28$start[i] < break.points["split28.2"] ) {
		new28$chr[i] <- 1
		new28$scaff[i] <- "DPSCF300028-2"
		new28$za[i] <- "Z_anc"
	} else {
		new28$chr[i] <- NA
		new28$scaff[i] <- "DPSCF300028-3"
		new28$za[i] <- "A"
	}
}


zaFuse <- 3883000  # this is a somehwat arbitrary coordinate on DPSCF300001 that is within fusion "window" and between genes
new01 <- genes01[, c("scaff", "genes", "za")]
new01$chr <- numeric(length = nrow(genes01))
for (i in seq_along(new01$chr)) {
	if ( genes01$start[i] < zaFuse ) {
		new01$chr[i] <- 21 # temporarily set this to 21. update to 1 later, below
		new01$scaff[i] <- "DPSCF300001-1"
		new01$za[i] <- "Z_neo"
	} else if ( genes01$start[i] > zaFuse & genes01$start[i] < break.points["split01"]) {
		new01$chr[i] <- 1
		new01$scaff[i] <- "DPSCF300001-1"
		new01$za[i] <- "Z_anc"
	} else {
		new01$chr[i] <- 23
		new01$scaff[i] <- "DPSCF300001-2"
		new01$za[i] <- "A"
	}
}

#new01$chr <- ifelse(genes01$start < break.points["split01"],  1, 23) # Here less than breakpoint are on Chr1/Z, but remainder are on Chr23
#new01$scaff <- ifelse(genes01$start < break.points["split01"],  "DPSCF300001-1", "DPSCF300001-2")



# read in liftover assignments from M. cinxia.
mc.genes <- read.delim(file = "../output/Mcinx/Mcinx-Dplex_genes-chrom.txt", stringsAsFactors =FALSE)
mc.genes$za <- rep("A", nrow(mc.genes))
mc.genes <- mc.genes[, c(1,2,4,3)] # rearrange so columns are in consistent order with 'new##' dataframes
#names(mc.genes) <- names(new01)
#mc.scaffs <- read.delim(file = "../output/Mcinx/Mcinx-Dplex_scaff-chrom.txt", stringsAsFactors =FALSE) 

# rename "new" data.frames in order to allow cbind() with original data.
names(new44) <- names(mc.genes)
names(new28) <- names(mc.genes)
names(new01) <- names(mc.genes)
mc.genes.tmp <- mc.genes[ !mc.genes$scaff.tar %in% c("DPSCF300044", "DPSCF300028", "DPSCF300001" ), ] # remove genes on scaffs 44 and 28 and 01
mc.genes.new <- rbind(mc.genes.tmp, new44, new28, new01)
mc.genes.new$za[mc.genes.new$chr.tar == 1]  <- "Z_anc"
mc.genes.new$za[mc.genes.new$chr.tar == 21] <- "Z_neo"  # assign neo Z to any gene assigned to McChr21
mc.genes.new$chr.tar[mc.genes.new$chr.tar == 21] <- 1  # assign chr1 to any gene assigned to McChr21



new.gene.counts <- table(mc.genes.new$chr.tar, useNA="always")
za.counts <-  table(mc.genes.new$za, useNA="always")

write.table(mc.genes.new, file = "../output/Dplex_chr-gene-scaff_updated.txt", sep = "\t", row.names = F, quote = F, col.names = c("scaffold", "geneID", "ZorA", "chromosome"))
write.table(new.gene.counts, file = "../output/Dplex_GenePerChr_updated.txt", sep = "\t", row.names = F, quote = F, col.names = c("Chromosome", "GeneCount"))
cat("\n\n\n#Tabulation of Autosomal, neo-Z, or ancestral-Z\n", file = "../output/Dplex_GenePerChr_updated.txt", append = T)
write.table(za.counts, file = "../output/Dplex_GenePerChr_updated.txt", sep = "\t", row.names = F, quote = F, col.names = c("ZorA", "GeneCount"), append = T)

