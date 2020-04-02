#!/bin/bash

##########
#name:          06a_plot_ATAC_enhancer.sh
#description:   plots ATAC signal for clusters enhancers
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 30, 2020
##########


source ../set_variables_mm10.sh


#choose cluster number for enhancers clusters
NUM_CLUSTER_ENH=15

NUM_MARKS=1
NUM_TIME_POINTS=4

SIGNAL_GENERATOR_DIR_ENH=$OPEN_REGIONS_DIR/Signal_Generator_enhancers

TIMELESS_DIR_ENH=$OPEN_REGIONS_DIR/timeless_enhancers_K27ac
MODEL_DIR_ENH=$TIMELESS_DIR_ENH/2_20
NUM_CLUSTER_DIR_ENH=$TIMELESS_DIR_ENH/2_20/$NUM_CLUSTER_ENH
cd $NUM_CLUSTER_DIR_ENH

#col16 stores cluster assignments
cut -f1,2,3,4,5,6,8,10,16 allCountsNorm_${NUM_CLUSTER_ENH}classes.txt > \
    regions_${NUM_CLUSTER_ENH}classes.bed 


ATAC_DIR=$OUTPUT_DIR/ATAC/

#plot ATAC clusters
#for each time point: mean of number of cut sites in region

TIMES=( XX_10.5 XX_13.5 XY_10.5 XY_13.5 )
for TIME in "${TIMES[@]}"
do
    echo $TIME

    #scaled bedgraphs of 1bp ATAC
    BEDGRAPH_FILES=($ATAC_DIR/${TIME}/bedgraphs/*.bedGraph)
    echo "${BEDGRAPH_FILES[@]}"


    #note: more memory needed: 30G
    #all regions with cluster assignments
    #stores sum of all overlaps of time points, later divide by number of 
    #replicates (here 2) to get mean
    bedtools intersect -c \
        -a $NUM_CLUSTER_DIR_ENH/regions_${NUM_CLUSTER_ENH}classes.bed \
        -b ${BEDGRAPH_FILES[@]} > \
        regions_${NUM_CLUSTER_ENH}_${TIME}_cutsites_unnormalized.bed

done


#col 10 is overlaps
#divide by region length
#col 11 is normalized overlaps
for t in "${TIMES[@]}"; do echo $t; \
    awk -v t="$t" -v numcluster="${NUM_CLUSTER_ENH}" 'OFS="\t" {len=$3-$2; 
        print $0,$10/len > "regions_"numcluster"_"t"_cutsites.bed"}' \
        regions_${NUM_CLUSTER_ENH}_${t}_cutsites_unnormalized.bed; done


NUM_REPLICATES=2
NUM_TIME_POINTS=4 #XX_10.5 XX_13.5 XY_10.5 XY_13.5
#we count number of ATAC-seq cut sites in region
#col 11- are cutsites
#col 9 is cluster assignment
paste regions_${NUM_CLUSTER_ENH}_XX_10.5_cutsites.bed \
    <( cut -f 11 regions_${NUM_CLUSTER_ENH}_XX_13.5_cutsites.bed ) \
    <( cut -f 11  regions_${NUM_CLUSTER_ENH}_XY_10.5_cutsites.bed ) \
    <( cut -f 11  regions_${NUM_CLUSTER_ENH}_XY_13.5_cutsites.bed ) | \
    cut -f 9,11- > regions_${NUM_CLUSTER_ENH}_cutsites_all.bed


Rscript $SCRIPT_DIR/open_regions/plot_ATAC_clusters.r \
    regions_${NUM_CLUSTER_ENH}_cutsites_all.bed ${NUM_TIME_POINTS} \
    ${NUM_REPLICATES} $NUM_CLUSTER_ENH 


exit

