set title "M. cinxia Chr21 & Chr01(Z) vs DPSCF300001" 
set terminal postscript color solid "Courier" 12
set output "Mcinx_promer_dotplot_custom.ps"
set ytics ( \
 "Chr21" 1, \
 "Chr01(Z)" 5711611, \
 "" 8981003 \
)
set size 1,1
set grid
unset key
set border 10
set tics scale 0
set xlabel "DPSCF300001 position (bp)"
set ylabel "M. cinxia chromosome"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
set mouse clipboardformat "[%.0f, %.0f]"
set xrange [1:6243218]
set yrange [1:8981003]
set style line 1  lt 1 lw 2 pt 7 ps 0.2
set style line 2  lt 3 lw 2 pt 7 ps 0.2
set style line 3  lt 2 lw 2 pt 7 ps 0.2
plot \
 "Mcinx_promer_dotplot.fplot" title "FWD" w lp ls 1, \
 "Mcinx_promer_dotplot.rplot" title "REV" w lp ls 2
