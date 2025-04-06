nextflow.enable.dsl=2

process spades {
    tag "$sample_id"

    container 'staphb/spades:latest'
    publishDir "results/spades", mode: 'copy'

    input:
    tuple val(sample_id), file(r1), file(r2)

    output:
    tuple val(sample_id), file("${sample_id}_spades_assembly.fasta")

    script:
    """
    spades.py --pe1-1 ${r1} --pe1-2 ${r2} -o spades_output --threads 2
    cp spades_output/contigs.fasta ${sample_id}_spades_assembly.fasta
    """
}