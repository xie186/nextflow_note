nextflow.enable.dsl=2

params {
    run_dir: Path 
}

workflow {

  /*
   * fromFilePairs pairs R1/R2 using the part before `_R{1,2}_001.fastq.gz` as the key.
   * For files like JS10_S10_R1_001.fastq.gz, the key becomes `JS10_S10`.
   */
  Channel
    .fromFilePairs("${params.run_dir}/Sample_*/*_R{1,2}_001.fastq.gz", flat: true)
    .map { pairKey, read1, read2 ->
      def m = (pairKey =~ /^([^_]+)_S(\d+)$/)
      assert m.find() : "Unexpected key: ${pairKey}"
      def sid  = m.group(1)               // e.g., JS05
      def snum = m.group(2) as int        // e.g., 5
      def meta = [ id: sid, sample_num: snum, single_end: (read2 == null) ]
      tuple(sid, meta, [read1, read2].findAll { it })   // normalize reads list
    }
    .set { samples_ch }

  // (optional) peek
  samples_ch.view()
}
