#!/bin/sh 

echo "sample-id,absolute-fileath,direction" > Simonin_M_2016_manifest.csv

for sample in ./to_qiime/*R1*; 
	do 
	echo $(echo $sample | cut -d'_' -f6 | cut -d'.' -f1),$PWD/to_qiime/$(echo $sample | cut -d'/' -f3),forward >> Simonin_M_2016_manifest.csv;
	done 

for sample in ./to_qiime/*R2*; 
	do 
	echo $(echo $sample | cut -d'_' -f6 | cut -d'.' -f1),$PWD/to_qiime/$(echo $sample | cut -d'/' -f3),reverse >> Simonin_M_2016_manifest.csv;
	done 
