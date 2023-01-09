#!/bin/bash

totarg=$#

#precipitation temperature humidite vitesse orientation_du_vent periode 
#prec temp humi vite orie 

if [ $totarg -lt 4 ] || [ $totarg -gt 8 ]
then
    echo "probleme il faut 4 arg minimum avec:
1-station 2-date_start 3-date_stop 

4->8 :
pression vent humidite precipitation temperature"
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

for (( i=4 ; i<=$totarg ; i++ ))
do 
    var=$(eval "echo \$arg"$i)
    valide=0
    
    if [ $var = "pression" ]
    then
        valide=1
        echo "do_pression"
    fi

    if [ $var = "vent" ]
    then
        valide=1
        echo "do_vent"
    fi

    if [ $var = "humidite" ]
    then
        valide=1
        echo "do_humidite"
    fi

    if [ $var = "precipitation" ]
    then
        valide=1
        echo "do_precipitation"
    fi
    
    if [ $var = "temperature" ]
    then
        valide=1
        echo "do_temperature"
    fi

    if [ $valide -eq 0 ]
    then 
        echo "L'argument \"$var\" n'est pas valide"
        exit 1
    fi

done

#echo $arg5
#echo $totarg
