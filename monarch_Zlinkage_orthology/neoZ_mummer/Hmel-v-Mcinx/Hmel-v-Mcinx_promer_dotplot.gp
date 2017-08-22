set terminal postscript color solid "Courier" 8
set output "Hmel-v-Mcinx_promer_dotplot.ps"
set xtics rotate ( \
 "Hmel2_Chr21" 1, \
 "*Hmel2_Chr02" 13819764, \
 "" 22864635 \
)
set ytics ( \
 "*Mcinx_Chr01" 1, \
 "*Mcinx_Chr21" 14179218, \
 "" 22629462 \
)
set size 1,1
set grid
unset key
set border 0
set tics scale 0
set xlabel "REF"
set ylabel "QRY"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
set mouse clipboardformat "[%.0f, %.0f]"
set xrange [1:22864635]
set yrange [1:22629462]
set style line 1  lt 1 lw 2 pt 6 ps 0.5
set style line 2  lt 3 lw 2 pt 6 ps 0.5
set style line 3  lt 2 lw 2 pt 6 ps 0.5
plot \
 "Hmel-v-Mcinx_promer_dotplot.fplot" title "FWD" w lp ls 1, \
 "Hmel-v-Mcinx_promer_dotplot.rplot" title "REV" w lp ls 2
