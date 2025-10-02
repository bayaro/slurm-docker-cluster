
process fa_index {
    tag "$ref"
    input:
        val ref
        val cmd
    output:
        val ref
    script:
    """
        cd ${params.in_dir}/fasta
        if [ ! -e "${ref}.sa" ]; then
            ${cmd} index "${ref}"
        fi
    """
}
