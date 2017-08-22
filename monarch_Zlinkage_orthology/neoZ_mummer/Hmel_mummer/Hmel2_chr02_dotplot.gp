set terminal postscript color solid "Courier" 8
set output "Hmel2_chr02_dotplot.ps"
set ytics ( \
 "Hmel202006" 1, \
 "*Hmel202002" 6616448, \
 "Hmel202004" 6762614, \
 "Hmel202001" 8793191, \
 "Hmel202005" 8945442, \
 "Hmel202003" 9002020, \
 "" 9044816 \
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
set yrange [1:9044816]
set style line 1  lt 1 lw 2 pt 6 ps 0.5
set style line 2  lt 3 lw 2 pt 6 ps 0.5
set style line 3  lt 2 lw 2 pt 6 ps 0.5
plot \
 "Hmel2_chr02_dotplot.fplot" title "FWD" w lp ls 1, \
 "Hmel2_chr02_dotplot.rplot" title "REV" w lp ls 2
