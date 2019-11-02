#!/usr/bin/perl -w

#####################################################
##WARNING: This script cannot be excuted correctly.##
#####################################################

use Bio::EnsEMBL::Registry
use Text::CSV_XS

my $registry = 'Bio::EnsEMBL::Registry';
$registry->load_registry_from_db(
    -host => 'asiadb.ensembl.org',
    -user => 'anonymous'
);
my $gene_adaptor  = $registry->get_adaptor('Gene');
$infile = $ARGV[0];
my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
open my $ifh, "<:encoding(utf8)", "$infile" or die "$infile: $!";
while (my $row = $csv->getline ($ifh)) {       
}
