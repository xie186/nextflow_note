nextflow.enable.dsl=2

/*
  Standardize input reads from a samplesheet using nf-schema helper.

  Emits: samples_ch → tuple(id, meta_map, reads_list)
          - id:     sample identifier (string)
          - meta:   map including `single_end: true|false` plus original fields
          - reads:  [read1] for SE, [read1, read2] for PE
*/

params.sample_table = file('test_data/sample_meta_simple.csv')

// Helper that turns a samplesheet into a list of [meta, read1, read2?]
include { samplesheetToList } from 'plugin/nf-schema'

workflow {

  main:
    Channel
      .fromList( samplesheetToList(params.sample_table, "${projectDir}/assets/schema_input.json") )
      .map { meta, read1, read2 ->
        def isSE = !read2
        tuple(
          meta.id as String,
          meta + [ single_end: isSE ],
          isSE ? [ read1 ] : [ read1, read2 ]
        )
      }
      .set { samples_ch }

    // Optional: inspect the standardized tuples during development
    samples_ch.view { it }

    // Also log the channel object (structure, not contents)
    log.info "Sample channel created: ${samples_ch}"
    println "The Groovy object type of 'samples_ch' is: ${samples_ch.getClass()}\n"

    samples_ch.subscribe { item ->
      println "Type: ${item.getClass()} | Value: ${item}"
    }

}
