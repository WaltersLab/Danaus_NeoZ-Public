# Overview of Danaus NeoZ files

## /monarch_Zlinkage_orthology 
Contains scripts and results from running proteinortho on Dplex versus the other three species. It further contains, in the 'neoZ_mummer' directory, scripts and results for creating the 'pseudo-assemblies' of the scaffolds homologous to DPSCF300001 and aligning them with mummer. This work was primarily done the "ACF" cluster and was simply tar-balled and downloaded for packaging the git repo.


## /analysis_scripts 
Contains R scripts that perfrom lift-over analysis, coverage analysis, and visualization of the results.  


## /input_files 
Data files required by scripts in 'analysis_scripts' dir. these come from a variety of upstream analyses, including alignments & coverage calculations, as well as orthology predctions.


## /output 
The primary location where output is written from scripts in 'analysis_scripts' dir.


## /DPSCF30001_alignments 
This served as a "local" folder to contain selected result files downloaded from the effort of aligning DPSCF300001 to 'pseudo-assemblies' from other species. this is an artifact of not using git to centralize this analysis effort.  These files should primarily be a subset of those in the 'neoZ_mummer' folder from the ACF cluster. 


## /From_Andrew 
Scripts provided by Andrew for generating & processing of alignment files.
'./Andrew_Rscripts' reflect early contributions towards generating normalized median values of coverage.
'./Andrew_ClusterScripts' are scripts run on the ACF cluster used to do alignments, process bam files, and get coverage values.

## /Wseq_search
Code and intermediate files for the effort to identify W-linked scaffolds from alignment of male and female resequencing.