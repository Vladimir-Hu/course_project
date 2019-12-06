#!/usr/bin/perl
foreach(<>){
    if(~~/(SRR\d+)_\d\.fastq/){
    $file{$1}++;
    }
}

foreach $key (keys(%file)){
    if($file{$key}==1){
        print("bwa mem -t 8 -R '\''\@RG\\tID:$key\\tPL:illumina\\tLB:NC_005089.1\\tSM:$key'\'' ~/course_project/data/WGS/mice/NC_005089.1.fasta $key.sickle.fq | samtools view -S -b - > $key.bam\n");
    }
    elsif($file{$key}==2){
        print("bwa mem -t 8 -R '\''\@RG\\tID:$key\\tPL:illumina\\tLB:NC_005089.1\\tSM:$key'\'' ~/course_project/data/WGS/mice/NC_005089.1.fasta $key.1.fastq $key.2.fastq | samtools view -S -b - > $key.bam\n\n");
    }
    else{
    #print
    }
}
