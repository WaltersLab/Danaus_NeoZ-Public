#!/usr/bin/perl -w

use strict;
use Bio::SeqIO;

unless (@ARGV == 2) {
	print  "\n\n\n\tIncorrect Usage!  Please provide file names for:\n\n";
	print  "\t\t1)\tInput fasta file\n";
	print  "\t\t2)\tOutput fasta file\n\n\n\n";
	die;
}





my $infile = shift @ARGV;
my $outfile = shift @ARGV;

my %genes;  #hash to hold data.  Each element is an array of 3-element arrays.  Each 3-element array is [0] transcript Id [1]transcript seq length [2] transcript seq object


my $seqin = Bio::SeqIO->new(	-file => "$infile", 
				-format => 'fasta');
								
my $seqout = Bio::SeqIO->new(	-file => ">$outfile", 
				-format => 'fasta');


while (my $seq = $seqin -> next_seq) {
	my @transcript = ($seq -> display_id(), $seq->length(), $seq ) ;  # create the transcript-data array
	#print $transcript[0],$transcript[1],"\n";
	$seq -> display_id() =~ m/(DPOGS\d{6})/;		#store GENEid in hash to cover each set of transcripts
	push(  @{$genes{$1} },  \@transcript );		#push an array reference of transcript-data into array that is hash-value for the current gene. 
	
}


foreach my $locus ( sort keys %genes) {
#	if ( @{ $genes{$locus}} > 2 ) {
#	print "$locus\n";
#		foreach my $trans (@{ $genes{$locus}} ) {
#			print "\t", "@{$trans}[0]","\n";
#			print "\t", "@{$trans}[1]","\n";
#		#print @{ $genes{$locus}}[0]->[1]  , "\n";
#		}
#	}
	
	
	if ( @{ $genes{$locus}} == 1  ) {
		#next;
		$seqout->write_seq(${ $genes{$locus}}[0] ->[2]);
	} else {
		my @trans_sorted = sort { $b->[1] <=> $a->[1] }  @{ $genes{$locus}};
		$seqout->write_seq($trans_sorted[0]->[2]);
	}

}
