#!/usr/bin/perl -w 

use strict;
use SVG;
use GD;

my (%name, %shape, %start, %end, %strand, %color);
my $w_rate = 0.6;
my $heigth = 100;


my $i;
open(IN, "draw.dat") or die"";
while(<IN>){
	chomp;
	my @data         = split(/\s+/,$_);
	my $contig       = $data[0];
	if(!exists($name{$contig})){
		$i = 1;
		$name{$contig}->{$i}   = $data[1];
		$shape{$contig}->{$i}  = $data[2];
		$start{$contig}->{$i}  = $data[3];
		$end{$contig}->{$i}    = $data[4];
		$strand{$contig}->{$i} = $data[5];
		$color{$contig}->{$i}  = $data[6];
		$i++;
	}else{
		$name{$contig}->{$i}   = $data[1];
		$shape{$contig}->{$i}  = $data[2];
		$start{$contig}->{$i}  = $data[3];
		$end{$contig}->{$i}    = $data[4];
		$strand{$contig}->{$i} = $data[5];
		$color{$contig}->{$i}  = $data[6];
		$i++;		
		}
	
	}
close IN;

my $image = SVG->new(width=>10000,height=>10000); 
my $bin = 100;
my $x = $bin;
my $y = 0.5 * $bin;

foreach my $contig(sort keys %name){
  my $c_x = $x;
	my $c_y = $y;
	my $text_x = $c_x;
	my $text_y = $c_y + $heigth/2;
  $image->text(
       style => {
       'font' =>"Times New Roman",
       'font-size' => 12
       },
       transform => "rotate(-30,$text_x,$text_y)",
       x=>$text_x,
       y=>$text_y,
       -cdata=>$contig);
      
#	$image->text('x',$c_x,'y',$c_y+$heigth/2,'font-family',"Times New Roman",'font-size',12,'-cdata',$contig);
	$y += 0.5 * $bin;
	foreach my $i(sort {$a<=>$b} keys %{$name{$contig}}){
	  my $c_name   = $name{$contig}->{$i};
	  my $c_start	 = $c_x + $bin;
	  my $c_end    = $c_start + 100;
	  my $c_color  = $color{$contig}->{$i};
	  my $c_strand = $strand{$contig}->{$i};
	  &arrow(-name=>$c_name,-x1=>$c_start,-x2=>$c_end,-strand=>$c_strand,-y=>$c_y+$heigth/2,-filled_c=>$c_color);
	  $c_x += 2 * $bin;
		}
	}
	


sub arrow{
    my %params = @_;
    my $width = 10;
    if($params{-width}){    	
        $width = $params{-width};
    }
    my $x1 = $params{-x1};
    my $y = $params{-y};
    my $x2 = $params{-x2};
    my $strand = $params{-strand};
    my $name= $params{-name};
    my $filled_c = $params{-filled_c};
    my $poly_c = $params{-poly_c};
    my $xv;
    my $yv;
    if($strand eq '-'){
        $xv = [$x1,$x1+10,$x1+10,$x2,$x2,$x1+10,$x1+10];
        $yv = [$y,$y-($width*6/6),$y-($width*$w_rate),$y-($width*$w_rate),$y+($width*$w_rate),$y+($width*$w_rate),$y+($width*6/6)];

    }
    else{
        $xv = [$x1,$x2-10,$x2-10,$x2,$x2-10,$x2-10,$x1];
        $yv = [$y-($width*$w_rate),$y-($width*$w_rate),$y-($width*6/6),$y,$y+($width*6/6),$y+($width*$w_rate),$y+($width*$w_rate)];
    }

    my $points = $image->get_path(
            x=>$xv, y=>$yv,
            -type=>'polygon',
            -closed=>'true'
            );
    my $c = $image->polygon(
            %$points,
            style=>{
            'stroke'=>'black',
            'fill'=>$filled_c,
            'stroke-width'=>'0',
            'stroke-opacity'=>'0',
            'fill-opacity'=>'1'
            }
            );
#    my $xx = sprintf("%.2f",$x1+(($x2-$x1)/3));
#    my $yy = sprintf("%.2f",$y-3*$width/2);
    my $xx = sprintf("%.2f",$x1);
    my $yy = sprintf("%.2f",$y-3*$width/2);
    $image->text(
            style => {
            'font' =>"Arial",
            'font-size' => 12
            },
            #transform => "rotate(-60,$xx,$yy)",
            transform => "rotate(0,$xx,$yy)",
            x=>$xx,
            y=>$yy,
            -cdata=>$name);

}

print $image->xmlify;


