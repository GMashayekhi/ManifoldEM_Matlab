#!/usr/bin/perl

use strict;
use warnings;


my $inc = $ARGV[2] or die "usage: max_number start_number increment\n";
my $start = $ARGV[1];
my $num = $ARGV[0];

for(my $i= $start;$i <= $num;$i=$i+$inc) {

  print "$i\n";
  my $u = sprintf("%02d",$i);
  my $dir = 'imgsSPIDER_'.$i.'_of_50';
  my $input = $dir .'.dat';
  my $output = 'norm_psi_Class50_'.$u;
  system("relion_preprocess --operate_on $input --norm true --bg_radius 148 --invert_contrast true --operate_out $output");
  system("mkdir -p $dir");
}

