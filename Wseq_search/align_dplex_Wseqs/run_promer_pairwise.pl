#!/usr/bin/perl -w

use strict;
use Getopt::Long;

my ($prefix,
    $ref,
    $qry,
    $Nplots,
    );

$Nplots = 0;



my $options = GetOptions(
    'prefix=s'    =>  \$prefix,  # basename used for output file names
    'ref=s'       =>  \$ref, # path to reference fasta
    'qry=s'       =>  \$qry, # path to query fasta
    'Nplots=i'    =>  \$Nplots,  # number of mapview files to generate. Default is '0', which disables mapview plotting 
    );

my $usage = "

    'prefix=s'    =>  \$prefix,  # basename used for output file names
    'ref=s'       =>  \$ref, # path to reference fasta
    'qry=s'       =>  \$qry, # path to query fasta
    'Nplots=i'    =>  \$Nplots,  # number of mapview files to generate. Default is '0', which disables mapview plotting 

";

sub usage_exit {
    print $usage;
    exit;
}


 foreach (
     $prefix,
     $qry,
     $ref
    )  {&usage_exit unless ($_);  } 





#code
system "promer -mum -p $prefix $ref $qry"; 
system "delta-filter -qr $prefix".".delta > $prefix"."_qr.delta"; 


#system "show-coords -lr $prefix"."_qr.delta > $prefix"."_qr.coords";
system "show-coords -b -l -r -c -d  -T $prefix"."_qr.delta  > $prefix"."_qr_FullTabs_coords.txt";
 
# system "mummerplot --postscript -p $prefix"."_qr_tiled -l -c $prefix"."_qr.delta"; 
system "mummerplot --postscript -p $prefix"."_dotplot --layout --filter $prefix".".delta";   # generate dotplot
#system "ps2pdf $prefix"."_qr_tiled.ps $prefix"."_qr_tiled.pdf";


if ( $Nplots > 0 ) {
	system "mapview -f pdf -d 50000 -p $prefix"."_qr -n $Nplots $prefix"."_qr.coords";
}

open IN, "<$prefix"."_dotplot.gp"  or die "can't open gnuplot script for editing\n\n";
open OUT, ">$prefix"."_dotplot_NoPoints.gp";

print OUT "set title \"$prefix\" \n";
while (<IN>) {
	s/pt 6 ps 0.5/pt 7 ps 0.2/;	
	print OUT;
}
close IN;
close OUT;

system "gnuplot $prefix"."_dotplot_NoPoints.gp";
system "ps2pdf $prefix"."_dotplot.ps $prefix"."_dotplot_NoPoints.pdf";

system "ps2pdf $prefix"."_dotplot.ps $prefix"."_dotplot_NoPoints.pdf";