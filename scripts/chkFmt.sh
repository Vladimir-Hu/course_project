#!/bin/bash

for file in `ls | grep .fastq`
do
	echo -n $file >> fqlist.txt
	echo -ne "\t"  >> fqlist.txt
	cat $file | awk 'NR % 4 ==0' | head -n 1000000 | python3 ./guess-encoding.py >> fqlist.txt
done

