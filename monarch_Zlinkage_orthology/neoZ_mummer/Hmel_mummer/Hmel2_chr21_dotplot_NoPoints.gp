set title "Hmel2_chr21" 
set terminal postscript color solid "Courier" 8
set output "Hmel2_chr21_dotplot.ps"
set ytics ( \
 "Hmel221005" 1, \
 "*Hmel221036" 662847, \
 "Hmel221001" 1391397, \
 "*Hmel221023" 4031585, \
 "*Hmel221010" 4076770, \
 "*Hmel221012" 4204847, \
 "Hmel221017" 7619865, \
 "Hmel221019" 8056045, \
 "*Hmel221045" 8210839, \
 "Hmel221009" 8520051, \
 "Hmel221046" 9210789, \
 "*Hmel221047" 9461473, \
 "Hmel221044" 9546254, \
 "Hmel221015" 10181737, \
 "*Hmel221016" 11083203, \
 "Hmel221018" 11132060, \
 "Hmel221020" 11315463, \
 "*Hmel221021" 11393510, \
 "Hmel221024" 11506236, \
 "Hmel221022" 11515987, \
 "Hmel221025" 11604441, \
 "*Hmel221026" 11769791, \
 "*Hmel221027" 11816971, \
 "Hmel221028" 11856524, \
 "Hmel221030" 12103759, \
 "Hmel221004" 12420642, \
 "Hmel221043" 12424850, \
 "Hmel221008" 12496876, \
 "Hmel221039" 12503394, \
 "Hmel221002" 12579676, \
 "Hmel221011" 12590005, \
 "Hmel221037" 12634718, \
 "Hmel221031" 12693532, \
 "Hmel221029" 12765423, \
 "Hmel221035" 12794546, \
 "Hmel221033" 12821373, \
 "Hmel221048" 12856082, \
 "Hmel221013" 12876959, \
 "Hmel221040" 13068558, \
 "Hmel221003" 13081242, \
 "Hmel221032" 13085519, \
 "Hmel221042" 13135762, \
 "Hmel221038" 13216955, \
 "Hmel221041" 13480600, \
 "Hmel221014" 13547853, \
 "Hmel221034" 13618865, \
 "Hmel221006" 13782046, \
 "Hmel221007" 13802377, \
 "" 13819331 \
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
set yrange [1:13819331]
set style line 1  lt 1 lw 2 pt 7 ps 0.2
set style line 2  lt 3 lw 2 pt 7 ps 0.2
set style line 3  lt 2 lw 2 pt 7 ps 0.2
plot \
 "Hmel2_chr21_dotplot.fplot" title "FWD" w lp ls 1, \
 "Hmel2_chr21_dotplot.rplot" title "REV" w lp ls 2
