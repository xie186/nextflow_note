
nextflow.enable.dsl = 2

params {
    sample_table       = "test_data/sample_meta_simple.csv"
}

include { samplesheetToList         } from 'plugin/nf-schema'

workflow {

    Channel
        .fromList(samplesheetToList(params.sample_table, "${projectDir}/assets/schema_input.json"))
        .map {
            meta, read1, read2, genome ->
                if (!read2) {
                    return [ meta.id, meta + [ single_end:true ], [ read1 ] ]
                } else {
                    return [ meta.id, meta + [ single_end:false ], [ read1, read2 ] ]
                }
        }
        .set { samples_ch }

    // Channel.fromPath(params.metatab)
    //     .splitCsv(header:true, sep:',')
    //     .map { row -> 
    //         def read1_list = row.read1.split(';').collect { it.trim() }
    //         def read2_list = row.read2.split(';').collect { it.trim() }
    //         return [row.sample_id, read1_list, read2_list]
    //     }
    //     .set { samples_ch }

    samples_ch.view()
}   
