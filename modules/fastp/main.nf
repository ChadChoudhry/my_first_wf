nextflow.enable.dsl=2
process fastp {
    tag "$sample_id"

    // Use the Docker image for fastp (adjust image tag as needed)
    container 'staphb/fastp:latest'
    publishDir "results/fastp", mode: 'copy'

    input:
    tuple val(sample_id), file(r1), file(r2)

    output:
    // The module outputs a tuple containing the sample ID and the trimmed read files.
    tuple val(sample_id), file("trimmed_${sample_id}_R1.fastq.gz"), file("trimmed_${sample_id}_R2.fastq.gz")

    script:
    """
    fastp -i ${r1} -I ${r2} \
          -o trimmed_${sample_id}_R1.fastq.gz \
          -O trimmed_${sample_id}_R2.fastq.gz \
          --thread 2
    """
}