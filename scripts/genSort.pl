#!/usr/bin/perl
foreach(<>){
    if(~~/(SRR\d+)_\d\.fastq/){
    $file{$1}++;
    }
}

foreach $key (keys(%file)){
    if($file{$key}==1){
        print("");
    }
    elsif($file{$key}==2){
        print("samtools sort -@ 16 -m 3G -O bam -o ${key}.sorted.bam ${key}.bam\n");
    }
    else{
    print "";
    }
}
