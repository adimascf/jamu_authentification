library(ggplot2)
library(phyloseq)
library(tidyverse)
library(psadd)
library(microbiomeMarker)

# setwd("\\\\wsl.localhost/Ubuntu-22.04/home/adimascf/pandu/herbal/")

args <- commandArgs(trailingOnly = TRUE)

table <- args[1]
taxonomy <- args[2]
metadata <- args[3]
repseqs <- args[4]

physeq_do <- import_qiime2(
  otu_qza = table,
  taxa_qza = taxonomy,
  sam_tab = metadata,
  refseq_qza = repseqs,
)

# head( sample_data( physeq_do ) )

plot_krona(physeq_do, "reports/ITS2_herbal_krona", "sample.id", trim = F)