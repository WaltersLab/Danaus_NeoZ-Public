# run_mummer_pipeline_promer.pl -prefix Mcinx_promer -ref ../DPSCF300001.fas -qry ../Mcinx_Chr21_Chr02.fas Nplots 1

perl ../run_promer_pairwise.pl -prefix  Mcinx_promer -ref ../DPSCF300001.fas -qry ../Mcinx_Chr21_Chr01.fas &> promer_merged.log

#perl ../run_promer_pairwise.pl -prefix  Mcinx_promer_NotMerged -ref ../DPSCF300001.fas -qry ../Mcinx_Chr21_Chr01_NotMerged.fas &> promer_merged.log

