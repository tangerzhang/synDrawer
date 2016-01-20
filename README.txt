A simple perl script to draw syntenic genes:

0. Prerequisites
   a. synDrawer performs mcl algorithm to cluster homologous genes
      install mcl before running this script
   b. install simple_blast, https://github.com/tangerzhang/my_script/blob/master/simple_blast.pl
      mv simple_blast.pl ~/bin/simple_blast
      chmod 777 ~/bin/simple_blast
   c. install GD and SVG module

1. prepare file
   a. genomic sequences (contain the scaffolds) 
   b. protein sequences (contain amino acid sequences for genes that you would like to draw)
   c. gff3 file

2. run program
   perl synDrawer.pl -g genomic.fasta -p SuBAC.protein.fasta -f SuBAC.gff3

3. results
   out.svg is the image for syntenic gene
   xyz.mcl contains clustered genes
   draw.dat is the input file for run_svg.pl script, you can change color in this file
4. adust the picture in AI or PS
