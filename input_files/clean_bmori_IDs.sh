perl -pe 's/(_\d+)\.\d/$1/g' bombyx_refseq_prot-scaff.txt > bombyx_refseq_prot-scaff_cleaned.txt
perl -pe 's/-P\w//g' dplex_v_bmori.proteinortho | perl -pe 's/(_\d+)\.\d/$1/g' > dplex_v_bmori.proteinortho_cleaned.txt
