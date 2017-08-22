# run_mummer_pipeline_promer.pl -prefix Hmel_promer -ref ../DPSCF300001.fas -qry ../Hmel2_Chr02_Ch21.fas Nplots 1

perl ../run_promer_pairwise.pl -prefix Hmel_promer -ref ../DPSCF300001.fas -qry ../Hmel2_Chr02_Ch21.fas &> promer_merged.log

#perl ../run_promer_pairwise.pl -prefix Hmel_promer_NotMerged  -ref ../DPSCF300001.fas -qry ../Hmel2_Chr02_Ch21_NotMerged.fas &> promer_NotMerged.log


