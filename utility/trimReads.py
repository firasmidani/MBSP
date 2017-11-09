#!/usr/bin/env python

# autor Firas Said Midani
# email firas.midani@duke.edu

# based on code in https://www.biostars.org/p/188878/

# purpose: trimReads.py allows you to remove remove leading or trialing bases from each read in a FASTQ or FASTA file

import sys

fastq = sys.argv[1] # file name with full or relative path
head_trim = int(sys.argv[2]) # how many bases to remove at the 5' end
tail_trim = int(sys.argv[3]) # how many bases to remove at the 3' end 

if tail_trim in [0,-1]:
	tail_trim = -1;
else: 
	tail_trim = (1+tail_trim)*-1;

if head_trim in [0,-1]:
	head_trim = 0
else:
	head_trim = head_trim;

with open(fastq,'r') as f:
	toggle = False
	for line in f:
		if toggle: print line[head_trim:tail_trim]
		else:	print line[0:-1]
		toggle = not toggle

f.close()
