#!/usr/bin/perl

use strict;
use warnings;


my $num = $ARGV[0] or die;

my $pref = '/home/ghoncheh/Covid19/Dat/norm_psi_Class50_'; 

  
 my $u = sprintf("%02d",$num);
 my $input = $pref.$u.'.star';
 my $output = $pref.$u.'.spi';
 system("relion_reconstruct --i $input --o $output");


