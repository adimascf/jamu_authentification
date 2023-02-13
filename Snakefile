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
        "data/processed/qiime2-files/ITS/ITS.qzv",
        "data/processed/qiime2-files/ITS/DADA2_denoising_output/representative-sequences.qza",
        "data/processed/qiime2-files/ITS/DADA2_denoising_output/representative-sequences.qzv"
    shell:
        """
        {input.script} {params.input_path}
        """