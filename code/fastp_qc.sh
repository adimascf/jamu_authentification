#!/usr/bin/bash

eval "$(conda shell.bash hook)"
conda activate quality_control


ls $1 | grep "_R1_001.fastq.gz" | sed 's/_R1_001.fastq.gz//' > file

mkdir -p $2/fastqs/

cat file | parallel --bar -j 2 \
        fastp -i $1/{}_R1_001.fastq.gz -I $1/{}_R2_001.fastq.gz \
                -o $2/fastqs/{}_R1_001.fastq.gz -O $2/fastqs/{}_R2_001.fastq.gz \
                --correction --json $2/{}.fastp.json

# ls data/raw_data/rbcl_fqs/ | grep "_R1_001.fastq.gz" | sed 's/_R1_001.fastq.gz//' > file_rbcl

# cat file_rbcl | parallel --bar -j 2 \
#         fastp -i data/raw_data/rbcl_fqs/{}_R1_001.fastq.gz -I data/raw_data/rbcl_fqs/{}_R2_001.fastq.gz \
#                 -o data/processed/fastped-fastqs/rbcl/{}_R1_001.fastq.gz -O data/processed/fastped-fastqs/rbcl/{}_R2_001.fastq.gz \
#                 --correction --json data/processed/fastped-fastqs/rbcl/{}.fastp.json

rm file
rm fastp.html
# rm file_rbcl

# multiqc -n data/processed/fastped-fastqs/rbcl/rbcl_multiqc_report.html --title "rbcl gene" data/processed/fastped-fastqs/rbcl/
multiqc -n $2/$3 --title $4 $2/