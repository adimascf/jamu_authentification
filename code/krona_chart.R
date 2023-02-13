library(ggplot2)
library(phyloseq)
library(tidyverse)
library(psadd)
library(microbiomeMarker)

# setwd("\\\\wsl.localhost/Ubuntu-22.04/home/adimascf/pandu/herbal/")

physeq_do <- import_qiime2(
  otu_qza = "data/processed/qiime2-files/ITS/DADA2_denoising_output/table.qza",
  taxa_qza = "data/processed/qiime2-files/ITS/ITS2_taxonomy.qza",
  sam_tab = "ITS-metadata.tsv",
  refseq_qza = "data/processed/qiime2-files/ITS/DADA2_denoising_output/representative-sequences.qza",
)


plot_krona(physeq_do, "reports/ITS2_herbal_krona", "sample_id", trim = F)