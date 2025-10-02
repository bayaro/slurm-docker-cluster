
process do_bam {
    tag "$pair"
    input:
        val ref
        val pair
        val cmd
    output:
        val pair
    script:
    """
        if [ ! -e "${params.out_dir}/${pair}/bam" ]; then
            cd "${params.out_dir}/${pair}"
            $cmd view -b sam > bam
        fi
    """
}

