#!/bin/bash

# The GNU parallel one liner counts the oligo sequences given in the "oligo_seq.csv" file (First row contain the column header)
# Outputs a count table with file name, oligo sequence, and the count separated by ","

touch count_data.txt
parallel --null grep -c {1} {2} '|' xargs -I% echo {2/.},{1},% >> count_data.txt ::: $(awk 'NR>1' oligo_seq.csv) ::: *fastq
