# setwd("\\\\wsl.localhost/Ubuntu-22.04/home/adimascf/pandu/herbal/")

library(ggplot2)
library(phyloseq)
library(tidyverse)
library(psadd)
library(qiime2R)
library(xlsx)

args <- commandArgs(trailingOnly = TRUE)

taxonomy_qiime2 <- args[1]
feature_table_qiime2 <- args[2]


taxonomy <- read_qza(taxonomy_qiime2)$data %>%
    tibble() %>%
    rename_all(tolower) %>% 
    select(feature.id, taxon) %>%
    separate(taxon,
             into=c("subkingdom", "phylum", "class", "order", "family", "genus", "species"),
             sep=";") %>%
    mutate(family = if_else(condition = is.na(family) | family == "NA",
                            true = paste0(order, " Unclassified", sep=" "),
                            false = family),
           genus = if_else(condition = is.na(genus) | genus == "NA", 
                           true = paste0(family, " Unclassified", sep=" "), 
                           false = genus),
           species = if_else(condition = is.na(species) | species == "NA", 
                             true = paste0(genus, " Unclassified", sep=" "), 
                             false = species),
           class = if_else(class == "NA",
                           true = "Others Streptophyta",
                           false = class),
           class = if_else(condition = is.na(class),
                          true = paste0(phylum, " Unclassified", sep=" "),
                          false = class))

table <- read_qza(feature_table_qiime2)

table <- table$data %>%
    as.data.frame()

table$feature.id <- row.names(table)

feature_rel_abund <- table %>%
    as_tibble(.) %>%
    inner_join(taxonomy, ., by="feature.id") %>%
    pivot_longer(c("SRR12374556", "SRR12374557", "SRR12374560", "SRR12374565",
                   "SRR12374576", "SRR12374587", "SRR12374598", "SRR12374609"),
                 names_to = "sample_id", values_to = "count") %>%
    group_by(sample_id) %>%
    mutate(rel_abund = count / sum(count)) %>%
    ungroup() %>%
    pivot_longer(c("subkingdom", "phylum", "class", "order", "family", "genus", "species", "feature.id"),
                 names_to="level",
                 values_to="taxon")


# feature_rel_abund %>%
#     filter(level == "order") %>%
#     group_by(sample_id, taxon) %>%
#     summarize(rel_abund = sum(rel_abund),
#               .groups = "drop") %>%
#     pivot_wider(names_from = sample_id, values_from = rel_abund)



level_rel_abund <- function(tax_level, f_rel_abund) {
    f_rel_abund %>%
        filter(level == tax_level) %>%
        group_by(sample_id, taxon) %>%
        summarize(rel_abund = sum(rel_abund),
                  .groups = "drop") %>%
        pivot_wider(names_from = sample_id, values_from = rel_abund)
}

species_rel_abund <- level_rel_abund("species", feature_rel_abund)
genus_rel_abund <- level_rel_abund("genus", feature_rel_abund)
family_rel_abund <- level_rel_abund("family", feature_rel_abund)
order_rel_abund <- level_rel_abund("order", feature_rel_abund)
class_rel_abund <- level_rel_abund("class", feature_rel_abund)
phylum_rel_abund <- level_rel_abund("phylum", feature_rel_abund)
subkingdom_rel_abund <- level_rel_abund("subkingdom", feature_rel_abund)

file_name <- "reports/ITS2_herbal_relative_abundance.xlsx"

if (file.exists(file_name)) {
    #Delete file if it exists
    file.remove(file_name)
}

write.xlsx(as.data.frame(species_rel_abund), file=file_name, sheetName="species", row.names=FALSE)
write.xlsx(as.data.frame(genus_rel_abund), file=file_name, sheetName="genus", append=TRUE, row.names=FALSE)
write.xlsx(as.data.frame(family_rel_abund), file=file_name, sheetName="family", append=TRUE, row.names=FALSE)
write.xlsx(as.data.frame(order_rel_abund), file=file_name, sheetName="order", append=TRUE, row.names=FALSE)
write.xlsx(as.data.frame(class_rel_abund), file=file_name, sheetName="class", append=TRUE, row.names=FALSE)
write.xlsx(as.data.frame(phylum_rel_abund), file=file_name, sheetName="phylum", append=TRUE, row.names=FALSE)
write.xlsx(as.data.frame(subkingdom_rel_abund), file=file_name, sheetName="subkingdom", append=TRUE, row.names=FALSE)








