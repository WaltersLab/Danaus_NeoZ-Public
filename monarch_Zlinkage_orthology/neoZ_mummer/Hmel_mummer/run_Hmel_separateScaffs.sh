perl ../run_promer_pairwise.pl -prefix Hmel2_chr02  -ref ../DPSCF300001.fas -qry ../Hmel2_Chr02.fas &> Hmel2_promer_chr02.log
perl ../run_promer_pairwise.pl -prefix Hmel2_chr21  -ref ../DPSCF300001.fas -qry ../Hmel2_Chr21.fas &> Hmel2_promer_chr21.log

Rscript --vanilla ../filter_alignments.R Hmel2_chr02_qr_FullTabs_coords.txt Hmel2_chr02_FiltAlnID.txt A
Rscript	--vanilla ../filter_alignments.R Hmel2_chr21_qr_FullTabs_coords.txt Hmel2_chr21_FiltAlnID.txt Z
