#!/bin/bash

##########
#name:          04b_select_model_K27ac.sh
#description:   calls plotting of model selection criteria (AIC, BIC, LR test)
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 30, 2020
##########


source ../set_variables_mm10.sh


#SIGNAL_GENERATOR_DIR_PROM=$OPEN_REGIONS_DIR/Signal_Generator_promoters
SIGNAL_GENERATOR_DIR_ENH=$OPEN_REGIONS_DIR/Signal_Generator_enhancers
#TIMELESS_DIR_PROM=$OPEN_REGIONS_DIR/timeless_promoters
TIMELESS_DIR_ENH=$OPEN_REGIONS_DIR/timeless_enhancers_K27ac


#cd $TIMELESS_DIR_PROM
#
#cat 2_30/AIC_*.mat |sort -k1,1n | cut -f2 > AIC.txt
#cat 2_30/BIC_*.mat |sort -k1,1n | cut -f2 > BIC.txt
#cat 2_30/likelihood_*.mat |sort -k1,1n | cut -f2 > likelihood.txt
#cat 2_30/numPar_*.mat |sort -k1,1n | cut -f2 > numPar.txt
#
#Rscript $SCRIPT_DIR/open_regions/plot_AIC_BIC.r AIC.txt BIC.txt \
#    $TIMELESS_DIR_PROM likelihood.txt numPar.txt
#

cd $TIMELESS_DIR_ENH

cat 2_20/AIC_*.mat |sort -k1,1n | cut -f2 > AIC.txt
cat 2_20/BIC_*.mat |sort -k1,1n | cut -f2 > BIC.txt
cat 2_20/likelihood_*.mat |sort -k1,1n | cut -f2 > likelihood.txt
cat 2_20/numPar_*.mat |sort -k1,1n | cut -f2 > numPar.txt

Rscript $SCRIPT_DIR/open_regions/plot_AIC_BIC_K27ac.r AIC.txt BIC.txt \
    $TIMELESS_DIR_ENH likelihood.txt numPar.txt


exit

