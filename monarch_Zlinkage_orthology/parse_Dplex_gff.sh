grep gene /data/jwalters/references/Monarch/Dp_geneset_OGS2.gff3 | cut -f1,9 | perl -pe 's/ID=(DPOGS\d+)\;Name=DPOGS2\d+\;/$1/' > dplex_gene-scaff.txt

