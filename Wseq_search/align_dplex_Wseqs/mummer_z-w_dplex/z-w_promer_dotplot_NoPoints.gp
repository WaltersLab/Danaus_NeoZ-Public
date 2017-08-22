set title "z-w_promer" 
set terminal postscript color solid "Courier" 8
set output "z-w_promer_dotplot.ps"
set xtics rotate ( \
 "*DPSCF300003" 1, \
 "*DPSCF300075" 1815366, \
 "DPSCF300001" 2472962, \
 "DPSCF300044" 8716179, \
 "DPSCF300012" 9843140, \
 "*DPSCF300005" 11207500, \
 "*DPSCF300083" 12717247, \
 "DPSCF300028" 13334686, \
 "*DPSCF300403" 15199499, \
 "DPSCF300145" 15369388, \
 "*DPSCF300146" 15799557, \
 "*DPSCF300066" 16229377, \
 "DPSCF300134" 16940704, \
 "DPSCF300068" 17393873, \
 "" 18098118 \
)
set ytics ( \
 "DPSCF300753" 1, \
 "*DPSCF300619" 9117, \
 "DPSCF300694" 25840, \
 "DPSCF300466" 37412, \
 "*DPSCF300571" 107323, \
 "*DPSCF300533" 133559, \
 "DPSCF300409" 172862, \
 "*DPSCF300683" 352982, \
 "" 365121 \
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
set xrange [1:18098118]
set yrange [1:365121]
set style line 1  lt 1 lw 2 pt 7 ps 0.2
set style line 2  lt 3 lw 2 pt 7 ps 0.2
set style line 3  lt 2 lw 2 pt 7 ps 0.2
plot \
 "z-w_promer_dotplot.fplot" title "FWD" w lp ls 1, \
 "z-w_promer_dotplot.rplot" title "REV" w lp ls 2
