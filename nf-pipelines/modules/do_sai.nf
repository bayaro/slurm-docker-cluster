
process do_sai {
    tag "$sample"
    input:
        val ref
        val sample
        val idx
        val cmd
    output:
        val sample
    script:
    """
        if [ ! -e "${params.out_dir}/${sample}/sai_${idx}" ]; then
            cd "${params.in_dir}"
            mkdir -p "${params.out_dir}/${sample}"
            $cmd aln "${ref}" "fastq/${sample}_${idx}.fastq" > "${params.out_dir}/${sample}/sai_${idx}"
        fi
    """
}

