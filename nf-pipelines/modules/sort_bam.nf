
process sort_bam {
    tag "$pair"
    input:
        val ref
        val pair
        val cmd
    output:
        val pair
    script:
    """
        if [ ! -e "${params.out_dir}/${pair}/bam.sorted" ]; then
            cd "${params.out_dir}/${pair}"
            $cmd sort bam > bam.sorted
        fi
    """
}

