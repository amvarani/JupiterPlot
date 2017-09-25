#!/usr/bin/env perl

#Written by Justin Chu 2017
#generate generic karyotype from fasta file
#Adds bands on chromosomes based on content of Ns (gaps) in the file
#colours the chromosomes
#Other features, like centromeres or other cytogentic bands must be added manually (i.e. by altering file and running again)

use strict;
use warnings;
use Getopt::Long qw(GetOptions);
use IO::File;

my $hueNum     = 0;
my $increment  = 0;
my $maxHue     = 360;
my $count      = 0;
my $minChrSize = 100000;
my $result     = GetOptions(
	'i=i' => \$increment,
	'm=i' => \$minChrSize
);

my $line = <>;

while ($line) {
	my $header = $line;
	$line = <>;
	my $currentStr = "";
	while ( $line && $line !~ /^>/ ) {
		chomp $line;
		$currentStr .= $line;
		$line = <>;
	}
	if ( length($currentStr) > $minChrSize ) {
		my ($chrName) = $header =~ /^>([^\s]+)\s/;

		#TODO assign colours in meaningful way
		print "chr - "
		  . $chrName . " "
		  . $chrName . " 0 "
		  . length($currentStr) . " hue";
		if ( $increment == 0 ) {
			printf '%03s', int( rand( $maxHue + 1 ) );
		}
		else {
 #flip the colour wheel around for odds a evens to contrast adjacent chromosomes
#			printf '%03s',
#			  int(
#				  $count % 2 == 0
#				? $hueNum / 2 % $maxHue
#				: ( $hueNum + $maxHue / 2 ) % $maxHue
#			  );

			printf '%03s',
			  int($hueNum % $maxHue);
			$hueNum += $increment;
		}
		print "\n";
		while ( $currentStr =~ /([^ATCGatcg]+)/g ) {
			print "band $chrName N N $-[0] $+[0] black\n";
		}
		$count++;
	}
}
