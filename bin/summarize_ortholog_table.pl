#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: $PROGRAM TAXID_SUMMARY
";

my %OPT;
getopts('', \%OPT);

if (!@ARGV) {
    print STDERR $USAGE;
    exit 1;
}
my ($TAXID_SUMMARY) = @ARGV;

my @TAXID = `cat $TAXID_SUMMARY | cut -f1`;
chomp @TAXID;
print join("\t", "HUMAN_GENE", @TAXID), "\n";

my %HASH;
while (<STDIN>) {
    chomp;
    my @f = split(/\t/, $_, -1);
    if (@f != 3) {
        die;
    }
    my ($human_gene, $other_gene, $taxid) = @f;
    $HASH{$human_gene}{$taxid}{$other_gene} = 1;
}

my @HUMAN_GENE = sort keys %HASH;
for my $human_gene (@HUMAN_GENE) {
    my @ortholog;
    for my $taxid (@TAXID) {
        if ($HASH{$human_gene}{$taxid}) {
            my @gene = sort keys %{$HASH{$human_gene}{$taxid}};
            push @ortholog, join(",", @gene)
        } else {
            push @ortholog, "NULL";
        }
    }
    print "$human_gene\t", join("\t", @ortholog), "\n";
}
