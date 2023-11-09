#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: $PROGRAM
-H: only human orthologs
";

my %OPT;
getopts('H', \%OPT);

print "\@prefix oo: <http://purl.org/net/orth#> .\n";
print "\@prefix taxid: <http://identifiers.org/taxonomy/> .\n";
print "\@prefix ncbigene: <http://identifiers.org/ncbigene/> .\n";
print "\n";

while (<>) {
    chomp;
    /^#/ and next;
    my @f = split(/\t/, $_, -1);
    if (@f != 5) {
        die;
    }
    my $tax1 = $f[0];
    my $gene1 = $f[1];
    my $relation = $f[2];
    my $tax2 = $f[3];
    my $gene2 = $f[4];
    if ($relation ne "Ortholog") {
        die;
    }
    
    if ($OPT{H}) {
        print_only_human_orthologs($tax1, $tax2, $gene1, $gene2);        
    } else {
        print_ortholog($tax1, $tax2, $gene1, $gene2);        
    }
}

################################################################################
### Function ###################################################################
################################################################################

sub print_only_human_orthologs {
    my ($tax1, $tax2, $gene1, $gene2) = @_;
    
    if ($tax1 eq "9606") {
        print_human_ortholog($gene1, $gene2, $tax2);
    } elsif ($tax2 eq "9606") {
        print_human_ortholog($gene2, $gene1, $tax1);
    }
}

sub print_human_ortholog {
    my ($gene1, $gene2, $taxid) = @_;
    
    print "ncbigene:$gene1 oo:hasOrtholog ncbigene:$gene2 .\n";
    print "ncbigene:$gene2 oo:taxon taxid:$taxid . \n";
    print "\n";
}

sub print_ortholog {
    my ($taxid1, $taxid2, $gene1, $gene2) = @_;
    
    print "ncbigene:$gene1 oo:hasOrtholog ncbigene:$gene2 .\n";
    print "ncbigene:$gene2 oo:hasOrtholog ncbigene:$gene1 .\n";
    print "ncbigene:$gene1 oo:taxon taxid:$taxid1 . \n";
    print "ncbigene:$gene2 oo:taxon taxid:$taxid2 . \n";
    print "\n";
}
