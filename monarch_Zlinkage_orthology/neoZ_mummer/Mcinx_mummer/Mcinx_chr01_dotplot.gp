set terminal postscript color solid "Courier" 8
set output "Mcinx_chr01_dotplot.ps"
set ytics ( \
 "*chr1_superscaffold34" 1, \
 "chr1_superscaffold74" 583736, \
 "*chr1_superscaffold4" 715161, \
 "chr1_superscaffold28" 1091029, \
 "*chr1_superscaffold32" 1496969, \
 "chr1_superscaffold19" 1770252, \
 "*chr1_superscaffold20" 2058076, \
 "*chr1_superscaffold9" 2558025, \
 "*chr1_superscaffold16" 2747823, \
 "chr1_superscaffold2" 3419935, \
 "chr1_superscaffold55" 3664578, \
 "chr1_superscaffold73" 3879926, \
 "*chr1_superscaffold33" 3973928, \
 "chr1_superscaffold44" 4359305, \
 "chr1_superscaffold12" 4363519, \
 "chr1_superscaffold31" 5109830, \
 "chr1_superscaffold21" 5442640, \
 "chr1_superscaffold18" 5784751, \
 "*chr1_superscaffold56" 5904706, \
 "*chr1_superscaffold11" 5974247, \
 "*chr1_superscaffold41" 6271462, \
 "*chr1_superscaffold14" 6610218, \
 "chr1_superscaffold63" 7034218, \
 "chr1_superscaffold8" 7166442, \
 "chr1_superscaffold17" 7393676, \
 "*chr1_superscaffold26" 7709711, \
 "chr1_superscaffold37" 8081361, \
 "*chr1_superscaffold53" 8231976, \
 "*chr1_superscaffold22" 8294867, \
 "chr1_superscaffold10" 8760493, \
 "*chr1_superscaffold60" 8918611, \
 "*chr1_superscaffold49" 9044268, \
 "*chr1_superscaffold72" 9131047, \
 "*chr1_superscaffold70" 9364704, \
 "*chr1_superscaffold47" 9494610, \
 "chr1_superscaffold24" 9517193, \
 "chr1_superscaffold13" 10121769, \
 "*chr1_superscaffold48" 10275686, \
 "*chr1_superscaffold5" 10381830, \
 "chr1_superscaffold50" 10709609, \
 "chr1_superscaffold39" 10797088, \
 "chr1_superscaffold46" 10857123, \
 "chr1_superscaffold71" 10898026, \
 "chr1_superscaffold38" 10974016, \
 "chr1_superscaffold42" 11014550, \
 "chr1_superscaffold7" 11020236, \
 "chr1_superscaffold40" 11313166, \
 "chr1_superscaffold69" 11421806, \
 "chr1_superscaffold29" 11435237, \
 "chr1_superscaffold66" 11437131, \
 "chr1_superscaffold54" 11439701, \
 "chr1_superscaffold43" 11523388, \
 "chr1_superscaffold25" 11546515, \
 "chr1_superscaffold62" 11737632, \
 "chr1_superscaffold6" 11772107, \
 "chr1_superscaffold67" 11923665, \
 "chr1_superscaffold61" 11989107, \
 "chr1_superscaffold58" 11998618, \
 "chr1_superscaffold59" 12051435, \
 "chr1_superscaffold68" 12086644, \
 "chr1_superscaffold57" 12096301, \
 "chr1_superscaffold1" 12149761, \
 "chr1_superscaffold35" 12613442, \
 "chr1_superscaffold23" 13049862, \
 "chr1_superscaffold36" 13080235, \
 "chr1_superscaffold27" 13149962, \
 "chr1_superscaffold51" 13365313, \
 "chr1_superscaffold64" 13383471, \
 "chr1_superscaffold15" 13488658, \
 "chr1_superscaffold52" 13767771, \
 "chr1_superscaffold3" 13786579, \
 "chr1_superscaffold30" 14045759, \
 "chr1_superscaffold45" 14070663, \
 "chr1_superscaffold65" 14117681, \
 "" 14178551 \
)
set size 1,1
set grid
unset key
set border 10
set tics scale 0
set xlabel "DPSCF300001"
set ylabel "QRY"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
set mouse clipboardformat "[%.0f, %.0f]"
set xrange [1:6243218]
set yrange [1:14178551]
set style line 1  lt 1 lw 2 pt 6 ps 0.5
set style line 2  lt 3 lw 2 pt 6 ps 0.5
set style line 3  lt 2 lw 2 pt 6 ps 0.5
plot \
 "Mcinx_chr01_dotplot.fplot" title "FWD" w lp ls 1, \
 "Mcinx_chr01_dotplot.rplot" title "REV" w lp ls 2
