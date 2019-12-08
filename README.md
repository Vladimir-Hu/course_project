# course_project
The code and result of the project in the molecular evolution class.
## Select orthologs and download sequence
### Find orthologs
* Find the COX1 gene in Human (*Homo sapiens*) genome in RefSeq.
* In GRCh38,it is `NC_012920.1 (5904..7445) `
* Use this accession id to find orthologs in the EnsEMBL database, save the result sheet, we got numbers of orthologs.
```{bash}
#103 orthologs in total
cat Ortholog_ENSG00000198804.csv | wc -l
104
```
* Note: Q0065 and Q0070 are products of COX1 produced by endonuclease, thus only Q0045 is preserved.
* Total:101 orthologs.
### Prepare sequence info
* Find out what to download.
```{bash}
cd ~/molecular_evolution
perl ./scripts/getList.pl ./result/Ortholog_ENSG00000198804.csv ./result/species_list.csv
```
### Download sequence
* It is turned out that the orthologs can be downloads directly on the website.
    * [Sequnece Provided Here](http://asia.ensembl.org/Homo_sapiens/Gene/Compara_Ortholog?db=core;g=ENSG00000198804;r=MT:5904-7445;t=ENST00000361624)
    * Download the OrthoXML format at the same time for annoation.
* Command-line style of downloading sequence will be further investigated.

### Find a way to name these sequence
* Use binomial nomenclature to name the sequence in FASTA format.
```{bash}
perl ./scripts/nameSeq.pl \
    ./data/COX1/Human_MT_CO1_orthologues.xml \
    ./data/COX1/Human_MT_CO1_orthologues.fa \
    ./data/COX1/COX1_anno.fa
```
* Manually correct some name.

### Outgroup selection
* Using the sequence of budding yeast.

## Sequence alignment
* Align sequence with MAFFT
```{bash}
cd ~/course_project
mafft --localpair --maxiterate 1000 ./data/COX1/COX1_anno.fa \
> ./result/COX1_aligned.fas
```

* Align sequence with clustalw (MEGA built-in)
    * Generate Option file in MEGA-GUI
    * Run Following command:
```{bash}
# Use default setting (align codons)
megacc -a clustal_align_coding.mao \
-d COX1_anno.fa -o ~/course_project/result/COX1_aligned -f Fasta
# Also prepare nexus format for mrbayes use
megacc -a clustal_align_coding.mao \
-d COX1_anno.fa -o ~/course_project/result/COX1_aligned -f MEGA
# Use MEGA GUI to convert

```
## Constuction of phylogenetic tree
### Neibour Join Tree
* Use MEGA to construct NJ-Tree
    * JC69 model
    ```{bash}
    cd ~/course_project/result/COX1
    megacc -a ~/course_project/data/COX1/infer_NJ_nucleotide_JC69.mao -d ./COX1_aligned.fasta  -o ./
    ```
    * TN93 model
    ```{bash}
    cd ~/course_project/result/COX1
    megacc -a ~/course_project/data/COX1/infer_NJ_nucleotide_TN93.mao -d ./COX1_aligned.fasta  -o ./
    ```

## NGS part of the project
* Determine the target organism, in this study, it's mice. (*Mus musculus*)
### Mapping mitochondria genomes
#### Note:
In this part, there are lots of ocommands need to run in a batch mode, we used several Perl scripts to generate shell scripts. The outline of this procedure is as follows:
* Generate a list of file which downloaded successfully
```
# After downloaded sra file and convert them into fastq format
cd /path/to/fastq/file
ls | grep .fastq > list.txt
```
* Run perl scripts to generate commands
```{perl}
#!/usr/bin/perl
foreach(<>){
    if(~~/(SRR\d+)_\d\.fastq/){
    $file{$1}++;                            # Determine wheather this run name belongs to a pair-end file or not
    }
}

foreach $key (keys(%file)){
    if($file{$key}==1){                     # Single end
        print("COMMAND se with parameter ${key}\n");
    }
    elsif($file{$key}==2){                  # Pair end
        print("COMMAND pe with parameter ${key}\n");
    }
    else{
    print "";
    }
}
```
#### Pre-processing of the NGS data
* Download single reads
```
# SRRs used in this project
SRR5852569
SRR5852570
SRR5852571
SRR5852572
SRR5852573
SRR5852576
SRR5852578
SRR5852579
SRR5852580
SRR5852581
SRR5852582
SRR5852583
SRR5852584
SRR5852585
SRR5852586
SRR5852588
SRR5852589
SRR5852590
SRR5852591
SRR5852592
SRR5852595
SRR5852596
SRR5852594
SRR5852597
SRR5852598
SRR5852599
SRR5852600
SRR5852601
SRR5852602
SRR5852603
SRR5852604
SRR5852605
SRR5852607
SRR5852608
SRR5852609
```
* Convert to fastq format for further useage
```{bash}
cd ~/course_project/data/WGS/mice
# Function to convert files
sra2fq(){
fastq-dump -I --split-files --outdir ./fastq $1
}
export -f sra2fq
# Conversion step
ls | grep .sra | parallel -I% --max-args 1 -k -j 4 sra2fq %
mkdir ./fastq
mv *.fastq ./fastq
```
* Use sickle to remove sequences with low score
```{bash}
# Manually check QC score type (see fqlist.txt)
# guess-encoding.py script used in shell script is adopted from 
#   https://github.com/brentp/bio-playground/blob/master/reads-utils/guess-encoding.py
cd ~/course_project/
cp ./scripts/chkFmt.sh ./data/WGS/mice/fastq
cp ./scripts/guess-encoding.py ./data/WGS/mice/fastq
cd ./data/WGS/mice/fastq/
bash chkFmt.sh

# Use perl script to generate runlist
cd ~/course_project/
cp ./scripts/genSickleRun.sh ./data/WGS/mice/fastq
ls | grep .fastq > list.txt
perl genSickleRun.pl list.txt > run.sh

# Trim read files
bash run.sh
```

* Mapping reads to the reference genome **NC_005089.1**
    * Use `bwa mem` to map reads longer than 70bp
```{bash}
cd ~/course_project/scripts
perl genBWA.pl list.txt > bwa.sh
cp ./bwa.sh ~/course_project/data/WGS/mice/fastq/
cd ~/course_project/data/WGS/mice/fastq
bash bwa.sh
```
* Sort bwa files

* Mark Duplicate (PCR Bias)

* Generate index files

* VCF file for BQSR
```{bash}
tabix -h ftp://ftp-mouse.sanger.ac.uk/REL-1505-SNPs_Indels/mgp.v5.merged.snps_all.dbSNP142.vcf.gz MT > MT_REL_1505.vcf
# Note: Need to replace MT in this vcf file with NC_005089.1
    # And save as REL.vcf
```

* Base Quality Score Recalibration
```{bash}
cd ~/course_project/data/WGS/mice/
picard CreateSequenceDictionary R=NC_005089.1.fasta O=NC_005089.1.dict
```