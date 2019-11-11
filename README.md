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

## Sequence alignment

## Constuction of phylogentic tree