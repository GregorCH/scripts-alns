#! /bin/bash

# setup settings files

if [ -z "$1" ] ;
then
    echo SCIP_DIR nicht spezifiziert
    exit 1
fi
scipdir="$1"
banditchars=(u e g)
lnss=( crossover dins localbranching mutation proximity rens rins zeroobjective )
SETTINGS="no-alns"
cp "no-alns.set" ${scipdir}/settings/
for b in ${banditchars[@]}
do
    setname="alns_$b"
    setfile="${scipdir}/settings/${setname}.set"
    echo > $setfile
    echo heuristics/alns/banditalgo = $b >> $setfile
    for l in ${lnss[@]}
    do
        echo heuristics/alns/${l}/minfixingrate = 0.3 >> $setfile
        echo heuristics/alns/${l}/maxfixingrate = 0.9 >> $setfile
    done
    echo heuristics/alns/minimprovelow = 0.01 >> $setfile
    echo heuristics/alns/minimprovehigh = 0.01 >> $setfile
    echo heuristics/alns/adjustminimprove = FALSE >> $setfile

    echo heuristics/alns/alpha = 0.0016 >> $setfile
    echo heuristics/alns/gamma = 0.07041455 >> $setfile
    echo heuristics/alns/eps = 0.4685844 >> $setfile

    SETTINGS="$SETTINGS,$setname"
    more $setfile
done
echo $SETTINGS
make -C $scipdir testcluster EXECUTABLE=alns/bin/scip OUTPUTDIR=alns-final-tests TEST=mipdev-sorted QUEUE=M620v3 TIME=7200 SETTINGS="$SETTINGS" MEM=35000 EXCLUSIVE=true
