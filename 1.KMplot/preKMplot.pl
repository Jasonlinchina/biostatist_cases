#!/usr/bin/perl -w
use strict;
use File::Basename;

my @sur = `ls ./*.survival.tsv`;
foreach (@sur) {
    chomp (my $s = $_);
    my $cancer = "BLCA";
    open IN,"< $cancer.FGD4.htseq_fpkm.txt";
    my %hash = ();
    while (<IN>) {
        chomp;
        my @a = split /\t/;
        $hash{$a[0]} = $_;
    }
    close IN;

    open IN,"< $s";
    open OUT,"> $cancer.FGD4.survival.txt";
    print OUT"Sample\tFPKM_FGD4\tE_OS\tT_OS\n";
    my %mark = ();
    <IN>;
    while (<IN>) {
        chomp;
        my @b = split /\t/;
        next if (!exists $hash{$b[2]});
        next if (exists $mark{$b[2]});
        print OUT"$hash{$b[2]}\t$b[4]\t$b[5]\n";
        $mark{$b[2]} = 1;
    }
    close IN;
    close OUT;
}    
