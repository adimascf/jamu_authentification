#!/usr/bin/bash



# Get input
SRA=$(tail -n +2 SraRunTable.txt | cut -d ',' -f 1)


# A loop for downloading the data
for i in ${SRA}
    do
	if [ -f ${i}.fastq.gz ]
	    then
		echo "${i} already finished"
	else
		prefetch ${i}
		echo "(o) Convert SRA entry: ${i}"
		# Downloads uniprot entry
		fastq-dump --gzip --defline-qual '+' --split-3 ${i}/${i}.sra
		echo "(o) Done convert ${i}"
		# Delete the directory
		rm -r ${i}
	fi
    done
