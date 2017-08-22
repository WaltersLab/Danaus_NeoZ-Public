set title "Hmel_HE671360-w_promer" 
set terminal postscript color solid "Courier" 8
set output "Hmel_HE671360-w_promer_dotplot.ps"
set ytics ( \
 "*DPSCF300409" 1, \
 "DPSCF300533" 180121, \
 "DPSCF300466" 219424, \
 "" 289337 \
)
set size 1,1
set grid
unset key
set border 10
set tics scale 0
set xlabel "HE671360"
set ylabel "QRY"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
set mouse clipboardformat "[%.0f, %.0f]"
set xrange [1:523174]
set yrange [1:289337]
set style line 1  lt 1 lw 2 pt 7 ps 0.2
set style line 2  lt 3 lw 2 pt 7 ps 0.2
set style line 3  lt 2 lw 2 pt 7 ps 0.2
plot \
 "Hmel_HE671360-w_promer_dotplot.fplot" title "FWD" w lp ls 1, \
 "Hmel_HE671360-w_promer_dotplot.rplot" title "REV" w lp ls 2
