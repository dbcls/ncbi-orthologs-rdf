#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: $PROGRAM
";

my %OPT;
getopts('', \%OPT);

my %COUNT_SPECIES;
while (<>) {
    chomp;
    my @f = split(/\t/, $_, -1);
    if (@f != 3) {
        die;
    }
    my $taxid = $f[2];
    $COUNT_SPECIES{$taxid}++;
}

my @taxids = keys %COUNT_SPECIES;
foreach my $taxid (sort { $COUNT_SPECIES{$b} <=> $COUNT_SPECIES{$a} } @taxids) {
    print "$taxid\t$COUNT_SPECIES{$taxid}\n";
}
