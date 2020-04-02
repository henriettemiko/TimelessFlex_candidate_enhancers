#!/bin/bash

##########
#name:          03b_combine_histone_mark_signals_K27ac.sh
#description:   compute histone mark signals at feature regions
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 30, 2020
##########


source ../set_variables_mm10.sh


FEATURE_REGIONS_DIR=$OUTPUT_DIR/open_regions/get_feature_regions
PROM_REGIONS=$FEATURE_REGIONS_DIR/all_ext_500_final_promoters.bed
ENH_REGIONS=$FEATURE_REGIONS_DIR/all_ext_500_final_enhancers.bed

echo "prom regions files: $PROM_REGIONS"
echo `wc -l $PROM_REGIONS`
echo "enh regions files: $ENH_REGIONS"
echo `wc -l $ENH_REGIONS`


SIGNAL_GENERATOR_DIR_PROM=$OPEN_REGIONS_DIR/Signal_Generator_promoters
SIGNAL_GENERATOR_DIR_ENH=$OPEN_REGIONS_DIR/Signal_Generator_enhancers

NUM_MARKS=1
NUM_TIME_POINTS=4

#cd $SIGNAL_GENERATOR_DIR_PROM
#
##combine counts from Signal Generator for each mark and for each time point 
##in defined order:
##H3K27ac XX_10.5 XX_13.5 XY_10.5 XY_13.5
##H3K27me3 XX_10.5 XX_13.5 XY_10.5 XY_13.5
##H3K4me3 XX_10.5 XX_13.5 XY_10.5 XY_13.5
#
##ordering of time points: XX_10.5 XX_3.5 XY_10.5 XY_13.5
##ordering of columns: col1 col2 col3 col4
##FC of time points D2/D0 D5/D2 D7/D5 D10/D7
##FC columns: col3/col1 col4/col3 col5/col4 col2/col5
#
#MAX_FILES_PROM=($SIGNAL_GENERATOR_DIR_PROM/*/*/max_counts.txt)
#echo "${MAX_FILES_PROM[@]}"
#
#paste <(sort-bed-typical $PROM_REGIONS) "${MAX_FILES_PROM[@]}" > \
#    all_max_counts_prom.txt
#
#Rscript $SCRIPT_DIR/open_regions/get_normalized_FC.r \
#    all_max_counts_prom.txt "_prom" "promoters"

#only H3K27ac
#the files allCountsNorm and allFold are ordered in XX_10.5 XX_13.5 XY_10.5 XY_13.5 and log2(XX_13.5/XX_10.5) log2(XY_13.5./XY_10.5) log2(XY_10.5/XX_10.5) log2(XY_13.5/XX_13.5)
#stored in SIGNAL_GENERATOR_DIR

cd $SIGNAL_GENERATOR_DIR_ENH

MAX_FILES_ENH=($SIGNAL_GENERATOR_DIR_ENH/H3K27ac/*/max_counts.txt)
echo "${MAX_FILES_ENH[@]}"

paste <(sort-bed-typical $ENH_REGIONS) "${MAX_FILES_ENH[@]}" > \
    all_max_counts_enh_K27ac.txt

Rscript $SCRIPT_DIR/open_regions/get_normalized_FC_K27ac.r \
    all_max_counts_enh_K27ac.txt "_enh_K27ac" "enhancers_K27ac"


exit

