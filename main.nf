#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Include your module processes
include { fastp }  from './modules/fastp/main.nf'
include { spades } from './modules/spades/main.nf'
include { seqkit } from './modules/seqkit/main.nf'

workflow {

    reads_ch = null

    // Use local test data if test mode is on
    if (params.test) {
        log.info "Test mode enabled — loading local test files from 'data/'"
        reads_ch = Channel.fromFilePairs("Data/*_{1,2}.fastq.gz", flat: true)
    } else {
        // In production mode, use the same (or a different) pattern
        reads_ch = Channel.fromFilePairs("Data/*_{1,2}.fastq.gz", flat: true)
    }

    // Run fastp for quality trimming
    trimmed_ch = fastp(reads_ch)

    // Run SPAdes and Seqkit on trimmed reads
    spades_ch  = spades(trimmed_ch)
    seqkit_ch  = seqkit(trimmed_ch)

    // Print the result summaries
    spades_ch.view { "SPAdes assembly result: ${it}" }
    seqkit_ch.view { "Seqkit stats result: ${it}" }
}
