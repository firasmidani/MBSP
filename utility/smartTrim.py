#!/usr/env/python 

# author Firas Midani
# e-mail firas.midani@duke.edu
# date 2017-11-10

# arguments
#	filename with full or relative path
#       kmer to match; use IUPAC notations
#       how many mismatches do you allow
#       how many bases do you keep beginning with your match

# dependencies
#	needs Biopython

# insight from https://www.biostars.org/p/163928/

import sys
from Bio import SeqIO

#create dictionary with IUPAC codes
IUPAC = {}
IUPAC['A'] = "A"
IUPAC['C'] = "C"
IUPAC['G'] = "G"
IUPAC['T'] = "T"
IUPAC['M'] = "AC"
IUPAC['R'] = "AG"
IUPAC['W'] = "AT"
IUPAC['S'] = "CG"
IUPAC['Y'] = "CT"
IUPAC['K'] = "GT"
IUPAC['V'] = "ACG"
IUPAC['H'] = "ACT"
IUPAC['D'] = "AGT"
IUPAC['B'] = "CGT"
IUPAC['X'] = "GATC"
IUPAC['N'] = "GATC"

# primer in INUPAC
primer = sys.argv[2]

# number of allowed mismatches
ndiff = int(sys.argv[3])+1

# number of bases to keep
nlength = int(sys.argv[4])

def MatchLetter(a, b):
	global IUPAC
	try:
		sa = IUPAC[a.upper()]
	except:
		return False
	try:
		sb = IUPAC[b.upper()]
	except:
		return False
	for ca in sa:
		if ca in sb:
			return True
		#endif
	#endfor
	return False
#enddef

def MatchPrefix(nmer,Primer):
	L = len(nmer)
	n = len(Primer)
	Diffs = 0
	for i in range(0,n):
		#print i,nmer[i],Primer[i],
		if not MatchLetter(nmer[i],Primer[i]):
			Diffs +=1
		#print Diffs
	return Diffs

def FindMatch(Seq,Primer):
	L = len(Seq)
	n = len(Primer)
	for i in range(0,L-n):
		nmer = Seq[i:i+n];
		#print nmer,'vs',Primer
		Diffs = MatchPrefix(nmer,Primer);
		#print Diffs,' mismatches'
		if Diffs < ndiff:
			return int(i) # this is location in sequence where primer begins
		#endif
	#endfor
	return -1
#enddef

def CutSeq(Seq,i,n):
	return Seq[i:i+n]							
#enddef

handle = open(sys.argv[1],'rU');
SeqRecords = SeqIO.parse(handle,'fastq');
for rec in SeqRecords:
	Seq = str(rec.seq)
	PrimerIndex = FindMatch(Seq,primer)
	#print Seq
	#print PrimerIndex
	if PrimerIndex != -1:
		TrimmedSeq = CutSeq(Seq,PrimerIndex,nlength);	
		SeqIO.write(rec[PrimerIndex:PrimerIndex+nlength],sys.stdout,'fastq')
#endfor
