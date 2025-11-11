
RUN="20251023_LH00584_0352_A22FHJMLT1"
PROJECT="JonSnow_CS000110_10WGBS_080722"
SAMPLES=(JS01 JS02 JS03 JS04 JS05 JS06)

mkdir -p "$RUN/$PROJECT" #"$RUN/Reports/html" "$RUN/Stats"

for i in "${!SAMPLES[@]}"; do
  sid="${SAMPLES[$i]}"
  sidx=$((i+1))
  sdir="$RUN/$PROJECT/Sample_${sid}"
  mkdir -p "$sdir"
  touch "$sdir/${sid}_S${sidx}_R1_001.fastq.gz"
  touch "$sdir/${sid}_S${sidx}_R2_001.fastq.gz"
done

touch "$RUN/Undetermined_S0_R1_001.fastq.gz" "$RUN/Undetermined_S0_R2_001.fastq.gz"


