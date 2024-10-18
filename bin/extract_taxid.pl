#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: $PROGRAM
-n: print gene count besides taxid
";

my %OPT;
getopts('n', \%OPT);

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
    my $geneid1 = $f[1];
    my $taxid2 = $f[3];
    my $geneid2 = $f[4];
    if ($f[2] ne "Ortholog") {
        die;
    }
    $HASH{$taxid1}{$geneid1} = 1;
    $HASH{$taxid2}{$geneid2} = 1;
}

my %COUNT;
for my $taxid (keys %HASH) {
    my @gene = keys %{$HASH{$taxid}};
    $COUNT{$taxid} = @gene;
}

for my $taxid (sort {$COUNT{$b} <=> $COUNT{$a}} keys %HASH) {
    my @gene = keys %{$HASH{$taxid}};
    my $n_gene = @gene;
    if ($OPT{n}) {
        print "$taxid\t$n_gene\n";
    } else {
        print "$taxid\n";
    }
}
