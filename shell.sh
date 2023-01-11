#!/bin/bash

totarg=$#

#precipitation temperature humidite vitesse orientation_du_vent periode 

if [ $totarg -lt 4 ] || [ $totarg -gt 9 ]
then
    echo "probleme il faut 4 arg minimum avec:
1-station 2-date_start 3-date_stop 

4->9 :
pression vent humidite precipitation temperature orientation"
    exit 1
fi

arg1=$1
arg2=$2
arg3=$3
arg4=$4
arg5=$5
arg6=$6
arg7=$7
arg8=$8

do_pression=0
do_vent=0
do_humidite=0
do_precipitation=0
do_temperature=0
do_orientation=0

for (( i=4 ; i<=$totarg ; i++ ))
do 
    var=$(eval "echo \$arg"$i)
    valide=0
    
    if [ $var = "pression" ]
    then
        valide=1
        do_pression=1
    fi

    if [ $var = "vent" ]
    then
        valide=1
        do_vent=1
    fi

    if [ $var = "humidite" ]
    then
        valide=1
        do_humidite=1
    fi

    if [ $var = "precipitation" ]
    then
        valide=1
        do_precipitation=1
    fi
    
    if [ $var = "temperature" ]
    then
        valide=1
        do_temperature=1
    fi

    if [ $var = "orientation" ]
    then
        valide=1
        do_orientation=1
    fi

    if [ $valide -eq 0 ]
    then 
        echo "L'argument \"$var\" n'est pas valide"
        exit 1
    fi
done


##################################################################


grep -e $arg1 meteo_filtered_data_v1.csv > temp.csv
sort -t ';' -k 2 temp.csv>data.csv
rm temp.csv


##################################################################


m


##################################################################
rm data.csv
