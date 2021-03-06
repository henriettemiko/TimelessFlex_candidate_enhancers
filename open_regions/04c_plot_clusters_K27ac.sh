#!/bin/bash

##########
#name:          04c_plot_clusters_K27ac.sh
#description:   calls plotting of promoter or enhancer clusters
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 30, 2020
##########


source ../set_variables_mm10.sh

##promoters
#
#
##choose cluster number for promoters here
#NUM_CLUSTER_PROM=14
#
#
#NUM_MARKS=3
#NUM_TIME_POINTS=4
#
#SIGNAL_GENERATOR_DIR_PROM=$OPEN_REGIONS_DIR/Signal_Generator_promoters
#TIMELESS_DIR_PROM=$OPEN_REGIONS_DIR/timeless_promoters
#
#
#MODEL_DIR_PROM=$TIMELESS_DIR_PROM/2_30
#NUM_CLUSTER_DIR_PROM=$TIMELESS_DIR_PROM/2_30/$NUM_CLUSTER_PROM
#mkdir -p $NUM_CLUSTER_DIR_PROM
#cd $NUM_CLUSTER_DIR_PROM
#
#paste $SIGNAL_GENERATOR_DIR_PROM/allCountsNorm.txt \
#    $MODEL_DIR_PROM/classes-${NUM_CLUSTER_PROM}.txt > \
#    allCountsNorm_${NUM_CLUSTER_PROM}classes.txt
#
#Rscript $SCRIPT_DIR/open_regions/plot_clusters.r \
#    $NUM_CLUSTER_PROM $NUM_MARKS $NUM_TIME_POINTS $MODEL_DIR_PROM \
#    $TIMELESS_DIR_PROM $SIGNAL_GENERATOR_DIR_PROM "promoter"
##exit
#
#enhancers

#choose cluster number for enhancers here
NUM_CLUSTER_ENH=15

SIGNAL_GENERATOR_DIR_ENH=$OPEN_REGIONS_DIR/Signal_Generator_enhancers
TIMELESS_DIR_ENH=$OPEN_REGIONS_DIR/timeless_enhancers_K27ac

NUM_MARKS=1
NUM_TIME_POINTS=4

MODEL_DIR_ENH=$TIMELESS_DIR_ENH/2_20
NUM_CLUSTER_DIR_ENH=$TIMELESS_DIR_ENH/2_20/$NUM_CLUSTER_ENH
mkdir -p $NUM_CLUSTER_DIR_ENH
cd $NUM_CLUSTER_DIR_ENH

paste $SIGNAL_GENERATOR_DIR_ENH/allCountsNorm_K27ac.txt \
    $MODEL_DIR_ENH/classes-${NUM_CLUSTER_ENH}.txt > \
    allCountsNorm_${NUM_CLUSTER_ENH}classes.txt

Rscript $SCRIPT_DIR/open_regions/plot_clusters_K27ac.r \
    $NUM_CLUSTER_ENH $NUM_MARKS $NUM_TIME_POINTS $MODEL_DIR_ENH \
    $TIMELESS_DIR_ENH $SIGNAL_GENERATOR_DIR_ENH "enhancer_K27ac"


exit

