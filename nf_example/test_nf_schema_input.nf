
nextflow.enable.dsl = 2

/*
  Standardize input reads from a samplesheet using nf-schema helper.

  Emits: samples_ch → tuple(id, meta_map, reads_list)
          - id:     sample identifier (string)
          - meta:   map including `single_end: true|false` plus original fields
          - reads:  [read1] for SE, [read1, read2] for PE
*/

params {
    sample_table: Path = "test_data/sample_meta_simple.csv"
}

include { samplesheetToList } from 'plugin/nf-schema'

workflow {

    Channel
        .fromList(samplesheetToList(params.sample_table, "${projectDir}/assets/schema_input.json"))
        .map {
            meta, read1, read2 ->
                if (!read2) {
                    return [ meta.id, meta + [ single_end:true ], [ read1 ] ]
                } else {
                    return [ meta.id, meta + [ single_end:false ], [ read1, read2 ] ]
                }
        }
        .set { samples_ch }

    samples_ch.view()
    // Also log the channel object (structure, not contents)
    log.info "Sample channel created: ${samples_ch}"
}   
