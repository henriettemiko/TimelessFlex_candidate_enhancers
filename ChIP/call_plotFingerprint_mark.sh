#!/bin/bash

##########
#name:          call_plotFingerprint_mark.sh
#description:   call plotFingerprint from deeptools
#author:        Henriette Miko (henriette.miko@mdc-berlin.de)
#date:          March 30, 2020
##########


MARK=$1
OUTPUT_DIR=$2
QUALITY_DIR=$3

echo "#####################"
echo $0 started on `hostname` at `date` with parameters $*
echo "Started processing:"
echo "current mark: $MARK"
echo "#####################"


FILES=($OUTPUT_DIR/ChIP/$MARK/X*/mapping/*nodup.bam)
echo "${FILES[@]}"

plotFingerprint -b "${FILES[@]}" --labels "XX_10.5 rep1" "XX_10.5 rep2" "XX_13.5 rep1" "XX_13.5 rep2" "XY_10.5 rep1" "XY_10.5 rep2" "XY_13.5 rep1" "XY_13.5 rep2" -T "ChIP bam files $MARK" --plotFile $QUALITY_DIR/fingerprint_${MARK}.pdf

exit

