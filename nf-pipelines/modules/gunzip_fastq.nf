
process gunzip_fastq {
    tag "$ref"
    input:
        path ref
    output:
        stdout
    script:
    """
        if echo $ref | grep -q 'gz\$'; then
            cd "${params.in_dir}/fastq"
            gunzip $ref >&2
            printf $ref | sed 's/_[12].fastq.gz\$//g'
        else
            printf $ref | sed 's/_[12].fastq\$//g'
        fi
    """
}
