
process bam_index {
    tag "$pair"
    input:
        val ref
        val pair
        val cmd
    output:
        val pair
    script:
    """
        if [ ! -e "${params.out_dir}/${pair}/bai" ]; then
            cd "${params.out_dir}/${pair}"
            $cmd index bam.sorted bai
        fi
    """
}

