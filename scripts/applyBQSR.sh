#/usr/bin/bash

bqsr(){
gatk BaseRecalibrator \
-R ~/course_project/data/WGS/mice/NC_005089.1.fasta \
-I ${1}.sorted.markdup.bam \
--known-sites ~/course_project/data/WGS/mice/REL.vcf \
-O ${1}.table
gatk ApplyBQSR \
-R ~/course_project/data/WGS/mice/NC_005089.1.fasta \
-I ${1}.sorted.markdup.bam \
-bqsr ${1}.table \
-O ${1}.sorted.markdup.bqsr.bam
}
export -f bqsr

cat SRR_Acc_List.txt | parallel -I% --max-args 1 -j 8 -k bqsr %
