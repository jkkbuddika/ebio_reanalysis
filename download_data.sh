#!/bin/bash

# Download data files from GEO using SRA-Toolkit
fastq-dump --gzip $(<Accession_list.txt)

# Unzip files
for i in `ls *.gz`; do
echo ${i} $(gunzip $i)
done

