grep -f mc_fusion_orthlogs.txt /data/jwalters/references/Melitaea/Melitaea_cinxia.MelCinx1.0.28.gff3 | cut -f1 | sort -u > mc_fusion_scaffolds.txt

grep -f hm_fusion_orthlogs.txt /data/jwalters/references/Hmel1-1_Release_20120601/GFFs/heliconius_melpomene_v1.1_primaryScaffs_wGeneSymDesc.gff3 | cut -f1 | sort -u > hm_fusion_scaffolds.txt
