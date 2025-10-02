
process do_sam {
    tag "$pair"
    input:
        val ref
        val pair
        val cmd
    output:
        val pair
    script:
    """
        if [ ! -e "${params.out_dir}/${pair}/sam" ]; then
            mkdir -p "${params.out_dir}/${pair}"
            cd "${params.in_dir}"
            $cmd sampe "${ref}" "${params.out_dir}/${pair}/sai_1" "${params.out_dir}/${pair}/sai_2" \
                "fastq/${pair}_1.fastq" "fastq/${pair}_2.fastq" > "${params.out_dir}/${pair}/sam"
        fi
    """
}

