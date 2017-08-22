grep -P "\tgene" /data/jwalters/references/Melitaea/Melitaea_cinxia.MelCinx1.0.28.gff3 | cut -f1,9 | cut -f1 -d';'| perl -pe ';s/ID=gene://' > mcinx_gene-scaff.txt

