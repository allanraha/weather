#!/bin/bash

totarg=$#

#precipitation temperature humidite vitesse orientation_du_vent periode 
#prec temp humi vite orie 

if [ $totarg -lt 4 ]
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

#for VAR in 

echo $arg5


echo $totarg
