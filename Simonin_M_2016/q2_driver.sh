#!/bin/sh

# author Firas Said Midani
# e-mail firas.midani@duke.edu
# date 2017-11-04

# make manifest file. use make_manifest.sh as a template. you may have to modify filepath
 
# import de-multiplexed data into QIIME2 artifact using manifest file approach
qiime tools import \
	--type 'SampleData[PairedEndSequencesWithQuality]' \
	--input-path Simonin_M_2016_Manifest \
	--output-path paired-end-demux.qza \
	--source-format PairedEndFastqManifestPhred33

# summarize and visualize imported data
qiime demux summarize \
	--i-data paired-end-demux.qza \
	--o-visualization paired-end-demux.qzv	

# pull down results to your local machine, then run the below after properly loading QIIME2 environment
qiime tools view paired-end-demux.qzv

# denoise with DADA2
qiime dada2 denoise-paired \
	--i-demultiplexed-seqs paired-end-demux.qza \
	--p-trim-left-f 0 --p-trim-left-r 0 --p-trunc-len-f 250 --p-trunc-len-r 250 \
	--o-representative-sequences rep-seqs-dada2.qza --o-table table-dada2.qza \
	--verbose --p-n-threads 0
