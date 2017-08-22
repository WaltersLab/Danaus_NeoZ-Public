perl ../run_promer_pairwise.pl -prefix Mcinx_chr01  -ref ../DPSCF300001.fas -qry ../Mcinx_chr01.fas &> Mcinx_promer_chr01.log
perl ../run_promer_pairwise.pl -prefix Mcinx_chr21  -ref ../DPSCF300001.fas -qry ../Mcinx_chr21.fas &> Mcinx_promer_chr21.log

Rscript --vanilla ../filter_alignments.R Mcinx_chr01_qr_FullTabs_coords.txt Mcinx_chr01_FiltAlnID.txt Z
Rscript	--vanilla ../filter_alignments.R Mcinx_chr21_qr_FullTabs_coords.txt Mcinx_chr21_FiltAlnID.txt A
