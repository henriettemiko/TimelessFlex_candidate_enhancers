#!/bin/bash

##########
#name:          01a_process_ATAC_files.sh
#description:   call processing of SE ATAC fastq files
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 27, 2020
##########


source ../set_variables_mm10.sh


for f in $INPUT_DIR/ATAC/*.fastq.gz
do


    echo $f

    NAME=$(basename $f .fastq.gz)
    echo $NAME


    if [[ "$f" =~ "sertoli"  ]]
    then
        TIME="XY_13.5"
    elif  [[ "$f" =~ "granulosa" ]]
    then
        TIME="XX_13.5"
    elif  [[ "$f" =~ "XX" && "$f" =~ "10.5" ]]
    then
        TIME="XX_10.5"
    elif  [[ "$f" =~ "XY"  && "$f" =~ "10.5" ]]
    then
        TIME="XY_10.5"
    else
        echo "file name does not match"
        exit
    fi

    echo $TIME


    ATAC_DIR=$OUTPUT_DIR/ATAC/$TIME/
    mkdir -p $ATAC_DIR

    qsub -N process_ATAC_SE_fastq_${NAME} \
        -V -j y -o $ATAC_DIR/process_ATAC_SE_fastq_${NAME}.txt -cwd \
        -pe smp 1 -l h_rt=24:00:00 -l mem_free=50G,h_vmem=50G \
        $SCRIPT_DIR/ATAC/process_ATAC_SE_fastq.sh $f $NAME \
        $TIME $OUTPUT_DIR $BOWTIE2_INDEX $CHR_SIZES $SCRIPT_DIR $ATAC_DIR


done


exit

