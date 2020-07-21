#!/usr/bin/perl

use strict;
use warnings;

my $start = $ARGV[1] or die "usage: max_number start_number\n"; 
my $num = $ARGV[0]; 
my $suff1 = '.mrcs';
my $suff2 = '.star'; 
my $suff3 = '.dat';
my $pref = 'norm_psi_Class50_';

for(my $i= $start;$i <=$num;$i++) {

   # input data
   my $u = sprintf("%02d", $i); 
   my $align_file = "align_". $u.$suff3;
   open(my $align_param, '<', $align_file) or die "Could not open '$align_file' $!\n";
   my $dummy = <$align_param>;
   
   # output data
   my $outfile = $pref.$u.$suff2;
   open (FILE, ">$outfile") || die "problem opening $outfile\n";
   my $stack = $pref.$i.$suff1;    
   print FILE "\ndata_images\n\n";
   print FILE "loop_\n";
   print FILE "_rlnImageName #1\n";
   print FILE "_rlnAngleRot #2\n";
   print FILE "_rlnAngleTilt #3\n";
   print FILE "_rlnAnglePsi #4\n";

   while (my $line = <$align_param>) {
      chomp $line;
      my @fields = split " " , $line;
      eval {
        #print "$fields[1]\n";
        my $num = sprintf("%06d", $fields[0]);
        my $image = $num."@".$stack;
        print FILE "$image $fields[4] $fields[3] $fields[2]\n";
#        print  "$image $fields[4] $fields[3] $fields[2]\n";
        
      };
   warn $@ if $@;
   }
}  
   
