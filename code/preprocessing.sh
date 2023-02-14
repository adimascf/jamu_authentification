#!/usr/bin/bash

set -e
set -u
set -o pipefail

eval "$(conda shell.bash hook)"
conda activate qiime2-2022.11

mkdir -p data/processed/qiime2-files/
mkdir -p data/processed/qiime2-files/ITS/
mkdir -p data/processed/qiime2-files/ITS/DADA2_denoising_output

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $1/ \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path data/processed/qiime2-files/ITS/ITS.qza

qiime demux summarize --i-data data/processed/qiime2-files/ITS/ITS.qza \
  --o-visualization data/processed/qiime2-files/ITS/ITS.qzv

qiime dada2 denoise-paired \
--p-n-threads 2 \
--i-demultiplexed-seqs data/processed/qiime2-files/ITS/ITS.qza \
--p-trim-left-f 0 \
--p-trim-left-r 0 \
--p-trunc-len-f 230 \
--p-trunc-len-r 200 \
--o-table data/processed/qiime2-files/ITS/DADA2_denoising_output/table.qza \
--o-representative-sequences data/processed/qiime2-files/ITS/DADA2_denoising_output/representative-sequences.qza \
--o-denoising-stats data/processed/qiime2-files/ITS/DADA2_denoising_output/denoising-stats.qza \
--verbose \
&> DADA2_denoising.log

qiime metadata tabulate  \
  --m-input-file data/processed/qiime2-files/ITS/DADA2_denoising_output/denoising-stats.qza \
  --o-visualization data/processed/qiime2-files/ITS/DADA2_denoising_output/denoising-stats.qzv


qiime feature-table summarize \
--i-table data/processed/qiime2-files/ITS/DADA2_denoising_output/table.qza \
--o-visualization data/processed/qiime2-files/ITS/DADA2_denoising_output/table.qzv \
--m-sample-metadata-file data/raw_data/ITS-metadata.tsv


qiime feature-table tabulate-seqs \
--i-data data/processed/qiime2-files/ITS/DADA2_denoising_output/representative-sequences.qza \
--o-visualization data/processed/qiime2-files/ITS/DADA2_denoising_output/representative-sequences.qzv
