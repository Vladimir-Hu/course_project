#!/usr/bin/perl
foreach(<>){
    if(~~/(SRR\d+)_\d\.fastq/){
    $file{$1}++;
    }
}

foreach $key (keys(%file)){
    if($file{$key}==1){
        print("sickle se -f ./${key}_1.fastq -t sanger -o ${key}.sickle.fq\n");
    }
    elsif($file{$key}==2){
        print("sickle pe -f ./${key}_1.fastq -r ./${key}_2.fastq -t sanger -o ${key}.sickle1.fq -p ${key}.sickle2.fq -s $key.pesickle.fq\n");
    }
    else{
    print "kicle $file{$key};"
    }
}
