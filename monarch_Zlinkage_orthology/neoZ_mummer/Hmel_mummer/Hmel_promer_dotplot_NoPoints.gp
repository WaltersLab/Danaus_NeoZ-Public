set title "Hmel_promer" 
set terminal postscript color solid "Courier" 8
set output "Hmel_promer_dotplot.ps"
set ytics ( \
 "Hmel2_Chr02" 1, \
 "Hmel2_Chr21" 8647045, \
 "" 15203181 \
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
set yrange [1:15203181]
set style line 1  lt 1 lw 2 pt 7 ps 0.2
set style line 2  lt 3 lw 2 pt 7 ps 0.2
set style line 3  lt 2 lw 2 pt 7 ps 0.2
plot \
 "Hmel_promer_dotplot.fplot" title "FWD" w lp ls 1, \
 "Hmel_promer_dotplot.rplot" title "REV" w lp ls 2
