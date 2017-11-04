#!/bin/sh

# author Firas Said Midani
# e-mail firas.midani@duke.edu
# date 2017-11-04

## purpose 
#  de-multiplex 16S rRNA data sequencing data set for Marie Simonin (2016)
#  barcodes are at the 5' prime end of either the forward and reverse reads but does not seem to both
#  see steps below for more details

## dependenceis
#  need QIIME1 (http://qiime.org/index.html)
#  need fastq-multx which is part of the ea-utils toolkit (https://expressionanalysis.github.io/ea-utils/)

# de-multiplex the forward reads with barcodes as a master list
fastq-multx -L ./mapping/Simonin_M_2016_Barcodes.txt ./input_fastq/Simonin_M_2016_BacV3V4_R1_001.fastq -o ./demux_R1/Simonin_R1_%.fastq -d 1

# de-multiplex the reverse reads with barcodes as a master list
fastq-multx -L ./mapping/Simonin_M_2016_Barcodes.txt ./input_fastq/Simonin_M_2016_BacV3V4_R2_001.fastq -o ./demux_R2/Simonin_R2_%.fastq -d 1

# write the sequence ids of the mapped forward reads to a single text file for each sample
for i in ./demux_R1/*; 
	do cat $i | sed -n '1~4p' | sed 's/@M/M/' | cut -d' ' -f1 > $i.seqs;  
done

# write the sequence ids of the mapped reverse reads to a single text file for each sample
for i in ./demux_R2/*; 
	do cat $i | sed -n '1~4p' | sed 's/@M/M/' | cut -d' ' -f1 > $i.seqs;  
done

# for each sample, merge IDs for sequences identified by barcodes on the forward and reverse reads
for i in $(cat ./mapping/Simonin_M_2016_Barcodes.txt | awk '{print $1}'); 
	do sort demux_R1/Simonin_R1_$i.fastq.seqs demux_R2/Simonin_R2_$i.fastq.seqs | uniq > ./demux_SeqIDs/Simonin_SeqIDs_$i.fastq; 
done

# for each sample, filter sequences for both forward and reverse reads
module load qiime

for sample in $(cat ./mapping/Simonin_M_2016_Barcodes.txt | awk '{print $1}');
	do filter_fasta.py -f ./input_fastq/Simonin_M_2016_BacV3V4_R1_001.fastq -o ./output_fastq/Simonin_M_2016_R1_$sample.fastq -s ./demux_SeqIDs/Simonin_SeqIDs_$sample.fastq;
done

for sample in $(cat ./mapping/Simonin_M_2016_Barcodes.txt | awk '{print $1}');
        do filter_fasta.py -f ./input_fastq/Simonin_M_2016_BacV3V4_R2_001.fastq -o ./output_fastq/Simonin_M_2016_R2_$sample.fastq -s ./demux_SeqIDs/Simonin_SeqIDs_$sample.fastq;
done

# remove flanking barcodes
for sample in ./output_fastq/*; 
	do python ./code/removeBarcodes.py $sample 8 > ./to_qiime/$sample;
done
