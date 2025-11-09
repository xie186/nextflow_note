
nextflow.enable.dsl = 2

params {
    metatab       = "sample_meta_semicolon.csv"
    bismark_index = "/path/to/bismark/index"
    outdir        = "WGBS_analysis"
}

workflow {

    Channel.fromPath(params.metatab)
        .splitCsv(header:true, sep:',')
        .map { row -> 
            def fastq1_list = row.fastq_1.split(';').collect { it.trim() }
            def fastq2_list = row.fastq_2.split(';').collect { it.trim() }
            return [row.sample_id, fastq1_list, fastq2_list]
        }
        .set { samples_ch }

    samples_ch.view()
}   