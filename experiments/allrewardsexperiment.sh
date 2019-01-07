#! /bin/bash

# setup settings files

if [ -z "$1" ] ;
then
    echo SCIP_DIR nicht spezifiziert
    exit 1
fi
scipdir="$1"

fixrates=( 0.1 0.3 0.5 0.7 0.9 )

lnss=( crossover dins localbranching mutation proximity rens rins zeroobjective )
oldlnss=( crossover lpface rens rins gins )
SETTINGS=""
for f in ${fixrates[@]}
do

    #
    #
    #
    setname="allrewards_$f"
    setfile="${scipdir}/settings/${setname}.set"
    echo > $setfile

    # set fixing rate to the specific value
    for l in ${lnss[@]}
    do
        echo heuristics/alns/${l}/minfixingrate = $f >> $setfile
        echo heuristics/alns/${l}/maxfixingrate = $f >> $setfile
    done

    # disable old heuristics
    for o in ${oldlnss[@]}
    do
        echo heuristics/${o}/freq = -1 >> $setfile
    done

    echo heuristics/alns/adjustminimprove = FALSE >> $setfile
    echo heuristics/alns/adjusttargetnodes = FALSE >> $setfile
    echo heuristics/alns/nsolslim = 3 >> $setfile

    SETTINGS="$SETTINGS,$setname"
    more $setfile
done
echo $SETTINGS
# use VISUALIZE=true to highjack visualization file
make -C $scipdir testcluster EXECUTABLE=alns-fine-tuning/bin/scip OUTPUTDIR=alns-rewards-new TEST=mipdev-sorted QUEUE=M630 TIME=18000 SETTINGS="$SETTINGS" MEM=20000 VISUALIZE=true
