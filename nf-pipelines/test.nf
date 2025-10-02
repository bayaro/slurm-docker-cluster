#!/usr/bin/env nextflow

include { gunzip_fastq as unzip_fastq_1 } from './modules/gunzip_fastq.nf'
include { gunzip_fastq as unzip_fastq_2 } from './modules/gunzip_fastq.nf'
include { fa_index as fa_index } from './modules/fa_index.nf'

include { do_sai as sai_1 } from './modules/do_sai.nf'
include { do_sai as sai_2 } from './modules/do_sai.nf'

include { do_sam as do_sam } from './modules/do_sam.nf'
include { do_bam as do_bam } from './modules/do_bam.nf'
include { sort_bam as sort_bam } from './modules/sort_bam.nf'
include { bam_index as bam_index } from './modules/bam_index.nf'
include { do_report as do_report } from './modules/do_report.nf'

workflow {

    println String.format("Input dir: %s", (params.in_dir))
    println String.format("Output dir: %s", (params.out_dir))

    def bwa = "/pipelines/bin/dummy.sh"
    def samtools = "/pipelines/bin/dummy.sh"
    bwa = "bwa"
    samtools = "samtools"

    def refs = Channel.fromPath("${params.in_dir}/fasta/*.fa")
    refs = fa_index(refs, bwa)

    def fastq_1 = Channel.fromPath("${params.in_dir}/fastq/*_1*")
    def fastq_2 = Channel.fromPath("${params.in_dir}/fastq/*_2*")
    
    fastq_1 = unzip_fastq_1(fastq_1)
    fastq_2 = unzip_fastq_2(fastq_2)

    def samples = fastq_1.combine(fastq_2, by: 0)

    // align indexed refs channel size with samples count
    refs = refs.combine(samples).map{ it[0] }

    def sai1_res = sai_1(refs, samples, "1", bwa)
    def sai2_res = sai_2(refs, samples, "2", bwa)

    def pair = sai1_res.combine(sai2_res, by: 0)
    def sam_res = do_sam(refs, pair, bwa)
    def bam_res = do_bam(refs, sam_res, samtools)
    def sorted_res = sort_bam(refs, bam_res, samtools)
    def bai_res = bam_index(refs, sorted_res, samtools)

    do_report(bai_res.collect(), "report.csv").view()
}