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
## Constuction of phylogentic tree
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
* Download single reads
```
# SRRs used in this project

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
```
* Use sickle to remove sequences with low score
```{bash}
# Manually check file type (see fqlist.txt)
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

* BWA MEM
```{bash}
bwa mem -t 8 -R '@RG\tID:foo_lane\tPL:illumina\tLB:library\tSM:sample_name' \
~/course_project/data/WGS/mice/NC_005089.1.fasta\
read_1.fq.gz read_2.fq.gz | samtools view -S -b - > sample_name.bam
```