#!/usr/bin/env python

# https://www.biostars.org/p/188878/

import sys

fastq = sys.argv[1]
length = int(sys.argv[2])

with open(fastq,'r') as f:
	toggle = False
	for line in f:
		if toggle: print line[length:]
		else:	print line[0:-1]
		toggle = not toggle
