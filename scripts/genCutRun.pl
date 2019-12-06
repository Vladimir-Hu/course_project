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
        print("cutadapt -q 20 --pair-filter=any -j 2 -o ./cutadapt/${key}.1.fastq -p ./cutadapt/${key}.2.fastq ${key}_1.fastq ${key}_2.fastq\n");
    }
    else{
    print "";
    }
}
