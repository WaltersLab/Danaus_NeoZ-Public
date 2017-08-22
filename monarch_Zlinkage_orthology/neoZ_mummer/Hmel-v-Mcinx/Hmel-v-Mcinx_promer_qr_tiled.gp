set terminal postscript color solid "Courier" 8
set output "Hmel-v-Mcinx_promer_qr_tiled.ps"
set xtics rotate ( \
 "Hmel2_Chr21" 1, \
 "*Hmel2_Chr02" 13819764, \
 "" 22864635 \
)
set size 1,0.5
set grid
unset key
set border 5
set tics scale 0
set xlabel "REF"
set ylabel "%SIM"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
set mouse clipboardformat "[%.0f, %.0f]"
set xrange [1:22864635]
set yrange [1:110]
set style line 1  lt 1 lw 4
set style line 2  lt 3 lw 4
set style line 3  lt 2 lw 4 pt 6 ps 0.5
plot \
 "Hmel-v-Mcinx_promer_qr_tiled.fplot" title "FWD" w l ls 1, \
 "Hmel-v-Mcinx_promer_qr_tiled.rplot" title "REV" w l ls 2
