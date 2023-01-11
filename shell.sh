#!/bin/bash

arguments () {
    echo "probleme dans la saisie de la comande, arguments valides sont les suivants :

    -t<1.2.3> (temperature)
    -p<1.2.3> (pression)
    -w (vent)
    -m (humiditée)
    -h (altitude)

    -F (France metropolitaine+Corse)
    -G (Guillane francaise)
    -S (St Perre et Miquelon)
    -A (Antilles)
    -O (Ocean Indien)
    -Q (Antartique)"
    exit 1
}

totarg=$#
if [ $totarg -eq 0 ]
then 
    arguments
fi

while getopts "t:p:wmhFGSAOQ" o; do
    case "${o}" in
        t)
            tmode=${OPTARG}
            if [ $tmode -gt 3 ]
            then 
                arguments
            fi
            ;;
        p)
            pmode=${OPTARG}
            if [ $pmode -gt 3 ]
            then 
                arguments
            fi
            ;;

        w)
            echo "w"
            ;;
        m)
            echo "m"
            ;;
        h)
            echo "h"
            ;;
        F)
            ;;
        G)
            ;;
        S)
            ;;
        A)
            ;;
        O)
            ;;
        Q)
            ;;
        *)
            arguments
            ;;
    esac
done
shift $((OPTIND-1))


##################################################################


echo ${startstopdate[@]}

<<c
grep -e $arg1 meteo_filtered_data_v1.csv > temp.csv
sort -t ';' -k 2 temp.csv>data.csv
rm temp.csv
c

##################################################################


#m


##################################################################
#rm data.csv
