Pipeline analysis/software for herbal medicine profiling (*alpha version*):
main steps:
adapter removal, quality trimming, dan base correction, fastp (https://doi.org/10.1093/bioinformatics/bty560)
denoising (quality control) sequences and OTU creation, dada2 (http://dx.doi.org/10.1038/nmeth.3869)
taxonomic assignment utilizes a naive Bayes classifier (https://doi.org/10.1186/s40168-018-0470-z)
curated ITS reference sequences, PLANiTS (https://doi.org/10.1093/database/baz155)
using QIIME2 for the environment/workflow (https://doi.org/10.1038/s41587-019-0209-9)
krona chart for making beautiful visualization (https://doi.org/10.1186/1471-2105-12-385)
custom bash and R scripts for processing, manipulating, reporting, etc.

results of the alpha-testing using sample data from this https://doi.org/10.1038/s41598-020-75305-0 can be seen and explored further on https://drive.google.com/drive/folders/18opeF6hhzkbvrFdr3tEag1l2Jpv640H-?usp=sharing. Please raise issues, questions, or enhancements if you have.
