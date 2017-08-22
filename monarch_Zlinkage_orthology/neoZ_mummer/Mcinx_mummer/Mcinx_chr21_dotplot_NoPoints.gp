set title "Mcinx_chr21" 
set terminal postscript color solid "Courier" 8
set output "Mcinx_chr21_dotplot.ps"
set ytics ( \
 "chr21_superscaffold34" 1, \
 "chr21_superscaffold25" 30091, \
 "chr21_superscaffold20" 88833, \
 "chr21_superscaffold9" 476174, \
 "*chr21_superscaffold10" 791275, \
 "chr21_superscaffold12" 1164663, \
 "*chr21_superscaffold17" 1365326, \
 "chr21_superscaffold22" 1786951, \
 "chr21_superscaffold14" 2156579, \
 "chr21_superscaffold19" 2402300, \
 "*chr21_superscaffold7" 2710422, \
 "chr21_superscaffold29" 2801080, \
 "*chr21_superscaffold32" 2809623, \
 "chr21_superscaffold13" 2833236, \
 "chr21_superscaffold1" 3436704, \
 "chr21_superscaffold39" 4093916, \
 "*chr21_superscaffold3" 4183027, \
 "chr21_superscaffold38" 4345131, \
 "*chr21_superscaffold36" 4439988, \
 "*chr21_superscaffold23" 4573229, \
 "chr21_superscaffold16" 4629955, \
 "*chr21_superscaffold30" 4695894, \
 "*chr21_superscaffold44" 4749846, \
 "*chr21_superscaffold40" 4860144, \
 "chr21_superscaffold15" 4886954, \
 "chr21_superscaffold37" 5268173, \
 "chr21_superscaffold42" 5307191, \
 "*chr21_superscaffold43" 5438186, \
 "*chr21_superscaffold31" 5518627, \
 "chr21_superscaffold21" 5696244, \
 "chr21_superscaffold11" 5884498, \
 "chr21_superscaffold2" 6025742, \
 "chr21_superscaffold28" 6164726, \
 "chr21_superscaffold8" 6176717, \
 "*chr21_superscaffold4" 6372232, \
 "*chr21_superscaffold5" 6735096, \
 "*chr21_superscaffold18" 6848758, \
 "chr21_superscaffold24" 7675478, \
 "chr21_superscaffold35" 7701465, \
 "chr21_superscaffold6" 7731034, \
 "chr21_superscaffold33" 7944284, \
 "chr21_superscaffold41" 8263181, \
 "chr21_superscaffold26" 8389961, \
 "chr21_superscaffold27" 8394041, \
 "" 8449847 \
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
set yrange [1:8449847]
set style line 1  lt 1 lw 2 pt 7 ps 0.2
set style line 2  lt 3 lw 2 pt 7 ps 0.2
set style line 3  lt 2 lw 2 pt 7 ps 0.2
plot \
 "Mcinx_chr21_dotplot.fplot" title "FWD" w lp ls 1, \
 "Mcinx_chr21_dotplot.rplot" title "REV" w lp ls 2
