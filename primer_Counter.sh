#!/bin/bash

# Count raw read numbers
for i in `ls *.fastq`; do
c=`cat $i | wc -l`
c=$((c/4))
echo $i $c
done > raw_readCounts.txt

# To count the number of reads with forward primer sequence (i.e., TGGAAAGGACGAAACACC)
for i in `ls *.fastq`; do
echo ${i} $(grep -c "TGGAAAGGACGAAACACC" $i)
done > primer_Counts.txt

