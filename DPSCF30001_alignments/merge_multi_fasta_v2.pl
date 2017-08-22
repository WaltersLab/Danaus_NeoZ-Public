#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Bio::SeqIO;


my ($infile, $outfile, $ordfile, $seqID);




my $options = GetOptions(
    'infasta=s'    =>  \$infile,  # Path to input multifasta file
    'outfasta=s'   =>  \$outfile, # Path/name to output fasta
    'order=s'      =>  \$ordfile,   # {OPTIONAL} file listing ordering of input fasta entries in concatenated output. Defaults to input ordering
    'id=s'    	   =>  \$seqID,   # Sequence identifier to be used for output fasta
    );




my $usage = "

-infasta     # Path to input multifasta file
-outfasta    # Path/name to output fasta
-order       # {OPTIONAL} file listing ordering of input fasta entries in concatenated output. One seqID per line
               Defaults to input ordering
-id=s        # Sequence identifier to be used for output fasta

";

sub usage_exit {
    print $usage;
    exit;
}

foreach ($infile, $outfile, $seqID)  {&usage_exit unless ($_);  } 


print "\n\nNow merging fasta from $infile\n";

my $seq_in = Bio::SeqIO->new(	-file => "$infile", 
								-format => 'fasta',
								-alphabet => "dna");
								
my $seq_out = Bio::SeqIO->new(	-file => ">$outfile", 
								-format => 'fasta',
								-alphabet => "dna");

my @order; # initialize ordering array

# read in ordering from file
if ($ordfile) {
	open(ORD, "<$ordfile");
	while(<ORD>) {
		chomp($_);
		push @order , $_;
	}
	print "Read " . @order . " IDs from $ordfile\n".
	close(ORD);
} else {
	undef(@order) ; # undefine
}


# read in fasta input into hash, recording order for default output
my %fastas;
my @fasta_order;
while (my $seq = $seq_in -> next_seq) {
	my $IDnow = $seq -> display_id();
	print "\t$IDnow\n";
	push @fasta_order, $IDnow;
	$fastas{ $IDnow } = $seq;
}


if ( @order ) { 
	print "Using specified order in $ordfile \n";
} else {
	@order = @fasta_order;  # use default ordering if order isn't specified
	print "Using default ordering from $infile \n";
}

my $mergedSeq = 'N';
foreach my $id (@order) {
	print "\t Now writing: $id\n";
	$mergedSeq = $mergedSeq . $fastas{$id}->seq() . "NNNNNNNNN";
	#print "$mergedSeq\n";
}


my $outseq = Bio::Seq->new( -display_id => $seqID,
                            -seq => $mergedSeq);
                            
$seq_out->write_seq($outseq);



 
