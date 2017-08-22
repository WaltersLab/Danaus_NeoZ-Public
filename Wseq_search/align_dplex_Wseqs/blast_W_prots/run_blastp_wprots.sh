#blastp -query potential_W_prots.fas -db nr -out potential_W_prots-blastp.out -evalue 0.001 -outfmt 0  -num_descriptions 10 -num_alignments 10 -remote


blastp -query ../potential_W_prots.fas -db nr -out potential_W_prots-blastp.tbl -evalue 0.0001 -outfmt "6 qaccver saccver sseqid stitle pident evalue length mismatch gapopen qstart qend sstart send  bitscore ssciname scomname sskingdom"  -max_hsps 1 -max_target_seqs 30 -remote
