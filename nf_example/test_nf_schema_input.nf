
nextflow.enable.dsl = 2

params {
    metatab       = "test_data/sample_meta_semicolon.csv"
    bismark_index = "/path/to/bismark/index"
    outdir        = "WGBS_analysis"
}

workflow {

    Channel.fromPath(params.metatab)
        .splitCsv(header:true, sep:',')
        .map { row -> 
            def read1_list = row.read1.split(';').collect { it.trim() }
            def read2_list = row.read2.split(';').collect { it.trim() }
            return [row.sample_id, read1_list, read2_list]
        }
        .set { samples_ch }

    samples_ch.view()
}   
