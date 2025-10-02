
process do_report {
    input:
        val samples
        val report_file
    output:
        stdout
    script:
    """
        /pipelines/bin/report.py -i "${params.in_dir}" -o "${params.out_dir}" -c "${params.out_dir}/${report_file}"
        wc "${params.out_dir}/${report_file}"
    """
}

