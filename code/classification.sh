#!/usr/bin/bash

eval "$(conda shell.bash hook)"
conda activate qiime2-2022.11

# awk -v FS="\t" -v OFS="\t" '{print $1,"Viridiplantae;"$2}' data/raw_data/plantis_db/ITS2_taxonomy > data/raw_data/plantis_db/ITS2_taxonomy_7levels

# qiime tools import --type 'FeatureData[Taxonomy]' \
#     --input-path data/raw_data/plantis_db/ITS2_taxonomy_7levels \
#     --input-format HeaderlessTSVTaxonomyFormat \
#     --output-path data/processed/qiime2-files/ITS/plantis_qiime2/ITS2_taxonomy_7levels.qza

# qiime tools import --type 'FeatureData[Sequence]' \
#     --input-path data/raw_data/plantis_db/ITS2.fasta \
#     --output-path data/processed/qiime2-files/ITS/plantis_qiime2/ITS2.qza


# qiime feature-classifier fit-classifier-naive-bayes \
#     --i-reference-reads data/processed/qiime2-files/ITS/plantis_qiime2/ITS2.qza \
#     --i-reference-taxonomy data/processed/qiime2-files/ITS/plantis_qiime2/ITS2_taxonomy.qza \
#     --o-classifier data/processed/qiime2-files/ITS/plantis_qiime2/ITS2_classifier.qza


qiime feature-classifier classify-sklearn \
  --i-classifier data/processed/qiime2-files/ITS/plantis_qiime2/ITS2_classifier.qza \
  --i-reads data/processed/qiime2-files/ITS/DADA2_denoising_output/representative-sequences.qza \
  --o-classification data/processed/qiime2-files/ITS/ITS2_taxonomy.qza


# qiime metadata tabulate \
#     --m-input-file data/processed/qiime2-files/ITS/ITS2_taxonomy.qza \
#     --o-visualization data/processed/qiime2-files/ITS/ITS2_taxonomy.qzv


# qiime taxa barplot \
#   --i-table data/processed/qiime2-files/ITS/DADA2_denoising_output/table.qza \
#   --i-taxonomy data/processed/qiime2-files/ITS/ITS2_taxonomy_classification.qza \
#   --m-metadata-file data/raw_data/ITS-metadata.tsv \
#   --o-visualization data/processed/qiime2-files/ITS/taxa-bar-plots.qzv


# qiime phylogeny align-to-tree-mafft-fasttree \
#   --i-sequences data/processed/qiime2-files/ITS/DADA2_denoising_output/representative-sequences.qza \
#   --o-alignment data/processed/qiime2-files/aligned-rep-seqs.qza \
#   --o-masked-alignment data/processed/qiime2-files/masked-aligned-rep-seqs.qza \
#   --o-tree data/processed/qiime2-files/unrooted-tree.qza \
#   --o-rooted-tree data/processed/qiime2-files/rooted-tree.qza


qiime krona collapse-and-plot \
--i-table data/processed/qiime2-files/ITS/DADA2_denoising_output/table.qza \
--i-taxonomy data/processed/qiime2-files/ITS/ITS2_taxonomy_classification.qza \
--p-level 7 \
--o-krona-plot data/processed/qiime2-files/ITS/ITS2_krona.qzv
