args <- commandArgs(trailingOnly=TRUE)

infile <- args[1]
outfile <- args[2]
za <- args[3] # should be either "Z" or "A", indicate which of the two segments of the Z is being aligned

# infile <- "Mcinx_promer_NotMerged_qr_FullTabs_coords.txt"
# outfile <- "testout.txt" 

hdr <- c("startRef", "endRef", "startQry", "endQry", "alnRef", "alnQry",  "lenRef", "lenQry", "covRef", "covQry", "refID", "qryID")

coords <- read.delim(file = infile, skip = 5, header = F, stringsAsFactors = F, col.names = hdr)

bpaln <- tapply( coords$alnRef, INDEX = coords$qryID, FUN = sum) # get the total number of aligned bases per scaffold

min.aln <- 1000 # minimum total aligned bases in reference to include qry scaffold
keep.scaffs <- names(bpaln[ bpaln > min.aln])  # get names of scaffolds passing filter

coords.filt <- coords[ coords$qryID %in% keep.scaffs, ]  # subset coords to get only scaffolds that have sufficiently long alignments.

if (za == "A") {
	scaff.min <- tapply( coords.filt$startRef, INDEX = coords.filt$qryID, FUN = min)  # get the 5' most alignment position for each scaffold
} 
if (za == "Z") {
	scaff.min <- tapply( coords.filt$startRef[coords.filt$startRef > 3.5e6 ], INDEX = coords.filt$qryID[coords.filt$startRef > 3.5e6 ], FUN = min)  # get the 5' most alignment position for each scaffold, but only count sites beyond 3.5 Mbp on DPSCF30001
}

scaff.ord <- names(sort(scaff.min))


write(x=scaff.ord, file = outfile, ncolumns = 1 )
