grep -f w-scaffs.txt /work/jwalters/jwalters/references/Dplex_v3/Dp_geneset_OGS2.gff3 | grep -P "\tgene\t" | cut -f 1,9 | perl -pe 's/(\w+\t)ID=\w+;Name=(DPOGS\d+);/$1$2/' > potential_W_genes.txt

fastagrep.pl  -f <(cut -f2 potential_W_genes.txt) /work/jwalters/jwalters/references/Dplex_v3/Dp_geneset_OGS2_pep.fasta > potential_W_prots.fas
