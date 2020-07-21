#!/usr/bin/perl

use strict;
use warnings;


my $inc = $ARGV[2] or die "usage: max_number start_number increment\n"; 
my $start = $ARGV[1]; 
my $num = $ARGV[0];

my $pref = 'norm_psi_Class50_'; 
  
for(my $i= $start;$i <= $num;$i=$i+$inc) {
  print "$i\n";
  my $u = sprintf("%02d",$i);
  my $input = $pref.$u.'.star';
  my $output = $pref.$u.'.spi';
  system("relion_reconstruct --i $input --o $output");
}

