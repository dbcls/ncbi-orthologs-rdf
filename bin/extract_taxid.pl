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

my %HASH;
while (<>) {
    chomp;
    if (/^#/) {
        next;
    }

    my @f = split(/\t/, $_, -1);
    if (@f != 5) {
        die;
    }

    if ($f[0] !~ /^\d+$/) {
        die;
    }
    my $taxid1 = $f[0];
    $HASH{$taxid1} = 1;

    if ($f[2] ne "Ortholog") {
        die;
    }
    my $taxid2 = $f[3];
    $HASH{$taxid2} = 1;
}

for my $taxid (sort {$a <=> $b} keys %HASH) {
    print "$taxid\n";
}
