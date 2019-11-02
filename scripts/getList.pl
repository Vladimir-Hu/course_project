#!/usr/bin/perl -w
use Text::CSV_XS qw();
$infile = $ARGV[0];
$outfile = $ARGV[1];
my @name;
my @acc_id;
my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
open my $ifh, "<:encoding(utf8)", "$infile" or die "$infile: $!";
while (my $row = $csv->getline ($ifh)) {
        my $info;
        if($row->[0] =~ m/.*?\((\w+\s\w+\s?\w*)\)$/i){
            $biname = $1;
        }
        elsif($row->[0] =~ m/^(\w+\s\w+\s?\w*)$/i){
            $biname = $1;
        }
        else{
            print"Species name match failed!\n";
        }
        $biname =~ s/\s/_/g;
        print $biname ."\t";
        push @name, $biname;
        if($row->[2] =~ m/.*?\((\w+\d+).*?/i){
            print $1."\n";
            push @acc_id , $1;
        }
        else{
            print "Acc_id not found!\n";
        }
        
    }
open $ofh, ">:encoding(utf8)", "$outfile" or die "${outfile}: $!";
for(my $i=0;$i<=$#name;$i++){
    $csv->say ($ofh, [$name[$i],$acc_id[$i]]);
}
close $ofh or die "${outfile}: $!";
close $ifh;