#!/usr/bin/perl -w


use Getopt::Std;
getopts "g:p:f:";


if ((!defined $opt_g)|| (!defined $opt_p)  || (!defined $opt_f)) {
    die "************************************************************************
    Usage: perl a.cluster_genes.pl -g genomic.seq -p protein -f ann.gff3 
      -h : help and usage.
      -g : genomic.seq
      -p : predicted proteins
      -f : gff3 file
************************************************************************\n";
}else{
  print "************************************************************************\n";
  print "Version 1.1\n";
  print "Copyright to Tanger\n";
  print "RUNNING...\n";
  print "************************************************************************\n";
        
     }

my $num_of_contig = 0;
my $contig;
my %contigdb;
open(IN, $opt_g) or die"";
while(<IN>){
	chomp;
	if(/>/){
		$contig = $_;
		$contig =~ s/>//g;
	}else{
		$contigdb{$contig} .= $_
		}
	}
close IN;

$num_of_contig = keys %contigdb;

my %proteindb;
my $gene;
open(IN, $opt_p) or die"";
while(<IN>){
	chomp;
	if(/>/){
		$gene = $_;
		$gene =~ s/>//g;
	}else{
		$proteindb{$gene} .= $_
		}
	}
close IN;

open(OUT, ">gene.tmp.fasta") or die"";
open(BED, "> xyz.bed") or die"";
open(IN, $opt_f) or die""; ###read gff file
<IN>;
while(<IN>){
	chomp;
	my @data = split(/\s+/,$_);
	next if($data[2] ne "gene");
	my $contig = $data[0];
	next if(!exists($contigdb{$contig}));
	my $gene;
	if(/ID=(.*);Name/){
		$gene = $1;
		}
	print OUT ">$gene\n$proteindb{$gene}\n";
	print BED "$contig	$data[3]	$data[4]	$data[6]	$gene\n";
	}
close IN;
close OUT;
close BED;

print "\n\nRunning simple_blast ...\n";
$cmd = "simple_blast -i gene.tmp.fasta -d gene.tmp.fasta -p blastp -e 1e-8 -o blast.tmp.out";
system($cmd);
system("cut -f 1,2,11 blast.tmp.out > xyz.tmp.blast");
print "\nRunning MCL ...\n";
system("more xyz.tmp.blast | mcl - --abc --abc-neg-log -abc-tf 'mul(0.4343), ceil(200)' -o xyz.mcl");
#system("mcscan xyz");

my $num_of_group = `wc -l xyz.mcl`;
$num_of_group =~ s/\s+.*//g;
my %colordb;
my @color;

if($num_of_group <= 6){
  @color = qw/red blue black green yellow limegreen turquoise lawngreen chocolate firebrick olivedrab/;
}else{
	while(<DATA>){
		chomp;
		push @color, $_;
	  }
	close DATA;
	}


open(IN, "xyz.mcl") or die"";
while(<IN>){
	chomp;
	my @data  = split(/\s+/,$_);
	my $i     = int rand (@color) - 1;
	my $color = $color[$i] if(@data != 1);
	$color    = "darkgrey" if(@data == 1);
	grep {$colordb{$_}=$color} @data;
	}
close IN;

open(OUT, "> draw.dat") or die"";
open(IN, "xyz.bed") or die"";
while(<IN>){
	chomp;
	my @data = split(/\s+/,$_);
	my $gene = $data[-1];
	print OUT "$data[0]	$gene	arrow	$data[1]	$data[2]	$data[3]	$colordb{$gene}\n";
	
	}
close IN;
close OUT;

my $svg_cmd = "perl run_svg.pl > out.svg";
system($svg_cmd);

system("rm *tmp*");
system("rm dbname*");
system("rm xyz.bed");


__DATA__
darkred
black
darkblue
darkgreen
yellow
darkmagenta
darkgoldenrod
deeppink
navy
mediumblue
blue
green
teal
darkcyan
deepskyblue
darkturquoise
mediumspringgreen
lime
springgreen
aqua
midnightblue
dodgerblue
lightseagreen
forestgreen
seagreen
darkslategray
limegreen
mediumseagreen
turquoise
royalblue
steelblue
darkslateblue
mediumturquoise
indigo
darkolivegreen
cadetblue
cornflowerblue
mediumaquamarine
dimgray
slateblue
olivedrab
slategray
lightslategray
mediumslateblue
lawngreen
chartreuse
aquamarine
maroon
purple
olive
gray
skyblue
lightskyblue
blueviolet
saddlebrown
darkseagreen
lightgreen
mediumpurple
darkviolet
palegreen
darkorchid
sienna
brown
darkgray
lightblue
greenyellow
paleturquoise
lightsteelblue
firebrick
mediumorchid
rosybrown
darkkhaki
silver
mediumvioletred
indianred
peru
chocolate
tan
lightgray
thistle
orchid
goldenrod
palevioletred
crimson
gainsboro
plum
burlywood
lightcyan
lavender
darksalmon
violet
palegoldenrod
lightcoral
khaki
aliceblue
honeydew
azure
sandybrown
wheat
beige
whitesmoke
mintcream
ghostwhite
salmon
antiquewhite
linen
lightgoldenrodyellow
oldlace
red
fuchsia
orangered
tomato
hotpink
coral
darkorange
lightsalmon
orange
lightpink
pink
gold
peachpuff
navajowhite
moccasin
bisque
mistyrose
blanchedalmond
papayawhip
lavenderblush
seashell
cornsilk
lemonchiffon
floralwhite
lightyellow
ivory
