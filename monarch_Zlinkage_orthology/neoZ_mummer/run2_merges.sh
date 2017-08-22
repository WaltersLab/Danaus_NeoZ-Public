#perl merge_multi_fasta_v2.pl -infasta Hmel2_Chr21.fas -outfasta Hmel2_Chr21_merged.fas -id Hmel2_Chr21
#perl merge_multi_fasta_v2.pl -infasta Hmel2_Chr02.fas -outfasta Hmel2_Chr02_merged.fas -id Hmel2_Chr02

perl merge_multi_fasta_v2.pl -infasta Hmel2_Chr21.fas -outfasta Hmel2_Chr21_merged.fas -id Hmel2_Chr21 -order Hmel_mummer/Hmel2_chr21_FiltAlnID.txt       
perl merge_multi_fasta_v2.pl -infasta Hmel2_Chr02.fas -outfasta Hmel2_Chr02_merged.fas -id Hmel2_Chr02 -order Hmel_mummer/Hmel2_chr02_FiltAlnID.txt

cat Hmel2_Chr02_merged.fas Hmel2_Chr21_merged.fas > Hmel2_Chr02_Ch21.fas


#perl merge_multi_fasta_v2.pl -infasta Mcinx_chr01.fas -outfasta Mcinx_chr01_merged.fas -id Mcinx_Chr01 -order Mcinx_order_chr01.txt
#perl merge_multi_fasta_v2.pl -infasta Mcinx_chr21.fas -outfasta Mcinx_chr21_merged.fas -id Mcinx_Chr21 -order Mcinx_order_chr21.txt   
perl merge_multi_fasta_v2.pl -infasta Mcinx_chr01.fas -outfasta Mcinx_chr01_merged.fas -id Mcinx_Chr01 -order Mcinx_mummer/Mcinx_chr01_FiltAlnID.txt
perl merge_multi_fasta_v2.pl -infasta Mcinx_chr21.fas -outfasta Mcinx_chr21_merged.fas -id Mcinx_Chr21 -order Mcinx_mummer/Mcinx_chr21_FiltAlnID.txt

cat Mcinx_chr21_merged.fas Mcinx_chr01_merged.fas > Mcinx_Chr21_Chr01.fas

