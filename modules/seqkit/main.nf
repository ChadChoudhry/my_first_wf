nextflow.enable.dsl=2

process seqkit {
    tag "$sample_id"

    container 'staphb/seqkit:latest'
    publishDir "results/seqkit", mode: 'copy'

    input:
    tuple val(sample_id), file(r1), file(r2)

    output:
    tuple val(sample_id), file("${sample_id}_seqkit_stats.txt")

    script:
    """
    seqkit stats ${r1} ${r2} > ${sample_id}_seqkit_stats.txt
    """
}