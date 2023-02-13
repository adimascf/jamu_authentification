#!/usr/bin/bash

ls data/raw_data/ITS_fqs/ | grep "_R1_001.fastq.gz" | sed 's/_R1_001.fastq.gz//' > file_ITS

cat file_ITS | parallel --bar -j 2 \
        fastp -i data/raw_data/ITS_fqs/{}_R1_001.fastq.gz -I data/raw_data/ITS_fqs/{}_R2_001.fastq.gz \
                -o data/processed/fastped-fastqs/ITS/{}_R1_001.fastq.gz -O data/processed/fastped-fastqs/ITS/{}_R2_001.fastq.gz \
                --correction --json data/processed/fastped-fastqs/ITS/{}.fastp.json

ls data/raw_data/rbcl_fqs/ | grep "_R1_001.fastq.gz" | sed 's/_R1_001.fastq.gz//' > file_rbcl

cat file_rbcl | parallel --bar -j 2 \
        fastp -i data/raw_data/rbcl_fqs/{}_R1_001.fastq.gz -I data/raw_data/rbcl_fqs/{}_R2_001.fastq.gz \
                -o data/processed/fastped-fastqs/rbcl/{}_R1_001.fastq.gz -O data/processed/fastped-fastqs/rbcl/{}_R2_001.fastq.gz \
                --correction --json data/processed/fastped-fastqs/rbcl/{}.fastp.json

rm file_ITS
rm file_rbcl

multiqc -n data/processed/fastped-fastqs/rbcl/rbcl_multiqc_report.html --title "rbcl gene" data/processed/fastped-fastqs/rbcl/
multiqc -n data/processed/fastped-fastqs/ITS/ITS2_multiqc_report.html --title "ITS2" data/processed/fastped-fastqs/ITS/