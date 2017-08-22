perl -pe 's/(gi\|\d+\|ref\|(\w\w_\d{9}\.\d)\|)/$2 $1/' bombyx_refseq_proteins.fa > bombyx_refseq_proteins_accession.fa
grep '>' bombyx_refseq_proteins_accession.fa | cut -f1 -d' ' | tr -d '>' > bombyx_refseq_proteins_accessionID.txt
grep -f bombyx_refseq_proteins_accessionID.txt /data/jwalters/references/bombyx_refseq/ref_ASM15162v1_scaffolds_cleaned1.gff3 |  cut -f1,9 | cut -f1-2 -d';' | perl -pe 's/(\w\w_\d{9}\.\d)\s+ID=cds\d+\;Name=(\w\w_\d{9}\.\d)/$1\t$2/ ' | sort -u > bombyx_refseq_prot-scaff.txt
cut -f2 bombyx_refseq_prot-scaff.txt | sort | uniq -c | grep -v  ' 1 ' | cut -c9-30 > bombyx_redundantGFF_proteins.txt
