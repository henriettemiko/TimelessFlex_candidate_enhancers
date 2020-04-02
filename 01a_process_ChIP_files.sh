#!/bin/bash

##########
#name:          01a_process_ChIP_files.sh
#description:   call processing for each ChIP fastq file
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 4, 2019
##########


source ../set_variables_mm10.sh


for f in $INPUT_DIR/ChIP/H3*/*
#for f in $DATA_DIR/H3*/*

do
    echo $f

    NAME=$(basename $f .fastq.gz)
    echo $NAME

    MARK=$(echo $f | rev | cut -d "/" -f 2 | rev)
    #MARK=$(echo $f | rev | cut -d "/" -f 2 | rev | sed 's/(//g' | sed 's/)//g')
    #TIME=$(echo $f | rev| cut -d "/" -f 2 | rev)

    echo $MARK

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

    CHIP_DIR=$OUTPUT_DIR/ChIP/$MARK/$TIME
    mkdir -p $CHIP_DIR


    qsub -N process_ChIP_fastq_${NAME} -V -j y \
        -o $CHIP_DIR/process_ChIP_fastq_${NAME}.txt -cwd -pe smp 1 \
        -l mem_free=100G,h_vmem=100G $SCRIPT_DIR/ChIP/process_ChIP_fastq_SE.sh \
        $f $NAME $CHIP_DIR $BOWTIE2_INDEX


done


exit

