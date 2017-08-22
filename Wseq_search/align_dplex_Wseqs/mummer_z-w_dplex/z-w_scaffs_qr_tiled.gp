set terminal postscript color solid "Courier" 8
set output "z-w_scaffs_qr_tiled.ps"
set xtics rotate ( \
 "*DPSCF300003" 1, \
 "DPSCF300075" 1815366, \
 "DPSCF300005" 2472962, \
 "DPSCF300083" 3982709, \
 "*DPSCF300028" 4600148, \
 "DPSCF300044" 6464961, \
 "DPSCF300012" 7591922, \
 "DPSCF300068" 8956282, \
 "DPSCF300145" 9660514, \
 "DPSCF300001" 10090683, \
 "*DPSCF300403" 16333900, \
 "DPSCF300066" 16503789, \
 "DPSCF300134" 17215116, \
 "DPSCF300146" 17668285, \
 "" 18098118 \
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
set xrange [1:18098118]
set yrange [1:110]
set style line 1  lt 1 lw 4
set style line 2  lt 3 lw 4
set style line 3  lt 2 lw 4 pt 6 ps 0.5
plot \
 "z-w_scaffs_qr_tiled.fplot" title "FWD" w l ls 1, \
 "z-w_scaffs_qr_tiled.rplot" title "REV" w l ls 2
