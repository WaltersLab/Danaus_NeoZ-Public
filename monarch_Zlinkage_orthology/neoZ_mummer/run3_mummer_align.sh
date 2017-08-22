echo "Running Hmel alignments"
cd Hmel_mummer/
bash run_Hmel_promer_v1.sh 

echo "Running Mcinx alignments"
cd ../Mcinx_mummer/
bash run_mcinx_promer.sh
cd ..
