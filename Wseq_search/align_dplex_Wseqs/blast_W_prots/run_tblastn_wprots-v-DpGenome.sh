
tblastn -query  ../potential_W_prots.fas \
-db /work/jwalters/jwalters/references/Dplex_v3/Dp_genome_v3 \
-out potential_W_prots-tblastn-Dplex.tbl \
-evalue .00001 \
-outfmt 6 

