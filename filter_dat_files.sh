#! /bin/bash

if [ -z "$1" ]
then
    echo "Kein Ordner angegeben" && exit 1
fi

#
# somehow, we have non-ASCII characters in some lines. Those will be filtered by the following command. Incomplete lines
# do not make it into the final evaluation file, anyway.
#
# excellent source https://stackoverflow.com/questions/3264915/remove-non-ascii-characters-in-a-file
#
for i in ${1}/*.dat
do
    sed -i.bak '/^.\{2048\}./d' $i
done

for i in 1 3 5 7 9
do

    # search for full lines only
    # replace the colon with a comma for better parsability
    # replace the long file names by something that is better readible
    # append the fixing rate to every row.
    grep -P "(\d\.\d+,){8,8}" ${1}/*0.${i}.dat | sed -e 's/:/,/g' -e 's/\/home.*\/bzfhende\.mipdev-sorted\.//g' -e 's/\.scip\.M630.*\.dat//g' -e "s/$/,0.${i}/g"

done  | tee all-rewards/fulllines.txt