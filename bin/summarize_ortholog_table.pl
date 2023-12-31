#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: $PROGRAM TAXID_SUMMARY
-b: binary pattern
-c: count organisms with orthologs
";

my %OPT;
getopts('bc', \%OPT);

if (!@ARGV) {
    print STDERR $USAGE;
    exit 1;
}
my ($TAXID_SUMMARY) = @ARGV;

my @TAXID = `cat $TAXID_SUMMARY | cut -f1`;
chomp @TAXID;
if ($OPT{c}) {
    print join("\t", "HUMAN_GENE", "COUNT_ORGANISMS"), "\n";
} else {
    print join("\t", "HUMAN_GENE", @TAXID), "\n";
}

my %HASH;
while (<STDIN>) {
    chomp;
    my @f = split(/\t/, $_, -1);
    if (@f != 3) {
        die;
    }
    my ($human_gene, $other_gene, $taxid) = @f;
    # if ($human_gene =~ /^ncbigene:/) {
    #     $human_gene =~ s/^ncbigene://;
    # } else {
    #     die;
    # }
    if ($other_gene =~ /^ncbigene:/) {
        $other_gene =~ s/^ncbigene://;
    } else {
        die;
    }
    $HASH{$human_gene}{$taxid}{$other_gene} = 1;
}

my @HUMAN_GENE = sort keys %HASH;
my %ORTHOLOG_COUNT;
my %ORTHOLOG_PATTERN;
for my $human_gene (@HUMAN_GENE) {
    my @ortholog;
    my $count = 0;
    for my $taxid (@TAXID) {
        if ($HASH{$human_gene}{$taxid}) {
            my @gene = sort keys %{$HASH{$human_gene}{$taxid}};
            if ($OPT{b}) {
                push @ortholog, "1";
            } else {
                push @ortholog, join(",", @gene);
            }
            $count++;
        } else {
            if ($OPT{b}) {
                push @ortholog, "0";
            } else {
                push @ortholog, "NULL";
            }
        }
    }
    $ORTHOLOG_COUNT{$human_gene} = $count;
    $ORTHOLOG_PATTERN{$human_gene} = join("\t", @ortholog);
}

for my $human_gene (sort {$ORTHOLOG_COUNT{$b} <=> $ORTHOLOG_COUNT{$a}} @HUMAN_GENE) {
    if ($OPT{c}) {
        print "$human_gene\t$ORTHOLOG_COUNT{$human_gene}\n";
    } else {
        print "$human_gene\t$ORTHOLOG_PATTERN{$human_gene}\n";
    }
}
