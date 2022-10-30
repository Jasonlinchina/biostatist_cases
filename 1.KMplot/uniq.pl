#!/usr/bin/perl -w
use strict;
use File::Basename;

my @fpkm = `ls /Users/lkq/Documents/project/YLQ/UCSC_Xena_TCGA/BLCA/TCGA-BLCA.htseq_fpkm.tsv`;
foreach (@fpkm) {
    my $cancer = basename(dirname($_));
    open IN,"< $_";
    open OUT,"> $cancer.FGD4.htseq_fpkm.txt";
    chomp (my $head = <IN>);
    my @h = split /\t/,$head;
    my %hash = ();
    my %count = ();
    while (<IN>) {
        chomp;
        my @v = split /\t/;
        next if ($v[0] ne 'ENSG00000139132.13');
        foreach my $i (1..$#v) {
            my @sam = split /-/,$h[$i];
            next if ($sam[3] eq '11A' || $sam[3] eq '11B' || $sam[3] eq '11C');
            my $sample = join("-", $sam[0], $sam[1], $sam[2]);
            if (exists $hash{$sample}) {
                $hash{$sample} += $v[$i];
                $count{$sample} += 1;
            }
            else {
                $hash{$sample} = $v[$i];
                $count{$sample} = 1;
            }
        }
        foreach (keys %hash) {
            my $value = $hash{$_}/$count{$_};
            print OUT"$_\t$value\n";
        }
    }
    close IN;
    close OUT;
}
