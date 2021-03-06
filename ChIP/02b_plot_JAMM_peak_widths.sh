#!/bin/bash

##########
#name:          02b_plot_JAMM_peak_widths.sh
#description:   plot widths of peaks called with JAMM
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 28, 2020
##########


source ../set_variables_mm10.sh

QUALITY_DIR=$OUTPUT_DIR/quality_ChIP
mkdir -p $QUALITY_DIR

for f in $OUTPUT_DIR/ChIP/H3K*
do

    MARK=$(echo $f | rev | cut -d "/" -f 1 | rev)
    echo $MARK

    qsub -hold_jid "call_JAMM_*" -N plot_peaks_${MARK} \
        -V -j y \
        -o $QUALITY_DIR/plot_peaks_${MARK}.txt -cwd -pe smp 1 \
        -l mem_free=10G,h_vmem=10G -l h_rt=24:00:00 \
        $SCRIPT_DIR/ChIP/call_plot_JAMM_peak_widths.sh $OUTPUT_DIR \
        $MARK $SCRIPT_DIR $QUALITY_DIR

done

exit

