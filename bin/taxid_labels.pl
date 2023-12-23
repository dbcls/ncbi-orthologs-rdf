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

if (!@ARGV) {
    print STDERR $USAGE;
    exit 1;
}
my ($TAXID) = @ARGV;

my @TAXON = `spang spang taxid $TAXID | cut -f2`;
chomp(@TAXON);

my @OUT = ();
for (my $i=0; $i<@TAXON; $i++) {
    my $taxon = $TAXON[$i];
    $taxon =~ s/^"//;
    $taxon =~ s/"$//;

    if ($i == 0) {
        if ($taxon ne "root") {
            die $taxon;
        }
        next;
    }

    if ($i == 1) {
        if ($taxon ne "cellular organisms") {
            die $taxon;
        }
        next;
    }

    if ($taxon =~ /;/) {
        die;
    }
    push @OUT, $taxon;
}

print $TAXID, "\t", join(";", @OUT)."\n";
