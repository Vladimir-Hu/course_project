#!/usr/bin/perl
use Bio::SeqIO;

my $filename = $ARGV[0];                #OrthoXML file
my $seq_in = $ARGV[1];                  #Sequence file from EnsEMBL
my $seq_out = $ARGV[2];                 #Sequence file with species name
our %namelist;
$raw_seq = Bio::SeqIO->new( -format => 'Fasta' , -file => "$seq_in");
$anno_seq = Bio::SeqIO->new( -format => 'Fasta', -file => ">$seq_out");
$eol = $/;
$/ = "</species>\n";

open XML,$filename;
foreach(<XML>){
    if($_ =~ m/.*?name="(.*?)">.*?protId="(.*?)".*/sg){
        $sci_name = ucfirst($1);
        $prot_id = $2;
        $namelist{$prot_id}=$sci_name;
    }
}
$/ = $eol;
close XML;

while((my $raw = $raw_seq->next_seq())){
    $temp_seq = Bio::Seq->new(-seq=>$raw->seq,
                         -display_id => $namelist{$raw->display_id},
                         -desc => "",
                         -alphabet => "dna" );
    $anno_seq->write_seq($temp_seq);
    #print $prot_id."\t".$namelist{$prot_id}."\n";
}