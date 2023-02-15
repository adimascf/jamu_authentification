rule download_ITSdb:
    input:
        script = "code/download_db.sh"
    output:
        "data/raw_data/plantis_db/"
    shell:
        """
        {input.script}
        """


rule fastp_preprocessing:
    input:
        script = "code/fastp_qc.sh"
    params:
        input_path = "data/raw_data/ITS_fqs",
        output_path = "data/processed/fastped-fastqs/ITS",
        output_file = "ITS2_multiqc_report.html",
        title = "ITS2"
    output:
        "data/processed/fastped-fastqs/ITS/ITS2_multiqc_report.html",
    shell:
        """
        {input.script} {params.input_path} {params.output_path} {params.output_file} {params.title}
        """

rule running_preprocessing:
    input:
        script = "code/preprocessing.sh"
    params:
        input_path = "data/processed/fastped-fastqs/ITS/fastqs"
    output:
        "data/processed/qiime2-files/ITS/ITS.qza",
        "data/processed/qiime2-files/ITS/DADA2_denoising_output/table.qza",
        "data/processed/qiime2-files/ITS/DADA2_denoising_output/representative-sequences.qza",
    shell:
        """
        {input.script} {params.input_path}
        """

rule run_classification:
    input:
        script = "code/classification.sh",
        input_classifier = "data/processed/qiime2-files/ITS/plantis_qiime2/ITS2_classifier.qza",
        input_repseqs = "data/processed/qiime2-files/ITS/DADA2_denoising_output/representative-sequences.qza",
    output:
        "data/processed/qiime2-files/ITS/ITS2_taxonomy.qza",
        "data/processed/qiime2-files/ITS/ITS2_krona.qzv"
    shell:
        """
        {input.script}
        """

rule create_krona:
    input:
        script = "code/krona_chart.R",
        table = "data/processed/qiime2-files/ITS/DADA2_denoising_output/table.qza",
        taxonomy = "data/processed/qiime2-files/ITS/ITS2_taxonomy.qza",
        metadata = "data/raw_data/ITS-metadata.tsv",
        repseqs = "data/processed/qiime2-files/ITS/DADA2_denoising_output/representative-sequences.qza"
    output:
        "reports/ITS2_herbal_krona.html"
    shell:
        """
        eval "$(conda shell.bash hook)" && conda activate krona_env && \
        Rscript {input.script} {input.table} {input.taxonomy} {input.metadata} {input.repseqs}
        """

rule relative_abundance:
    input:
        script = "code/rel_abundance.R",
        taxonomy = "data/processed/qiime2-files/ITS/ITS2_taxonomy.qza",
        table = "data/processed/qiime2-files/ITS/DADA2_denoising_output/table.qza"
    output:
        "reports/ITS2_herbal_relative_abundance.xlsx"
    shell:
        """
        Rscript {input.script} {input.taxonomy} {input.table}
        """

print("Is this real python?")
