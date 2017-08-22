echo "Running Hmel scaffold alignments"
cd Hmel_mummer/
bash run_Hmel_separateScaffs.sh 

echo "Running Mcinx scaffold alignments"
cd ../Mcinx_mummer/
bash run_Mcinx_separateScaffs.sh
cd ..
