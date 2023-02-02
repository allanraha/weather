#!/bin/bash

arguments () { #if there is a problem with the args
    echo "probleme dans la saisie de la comande, arguments valides sont les suivants :

OPTIONS :
    -t<1.2.3> (temperature)
    -p<1.2.3> (pression)
    -w (vent)
    -m (humiditée)
    -h (altitude)

LIEU (Un valide):
    -F (France metropolitaine+Corse)
    -G (Guillane francaise)
    -S (St Perre et Miquelon)
    -A (Antilles)
    -O (Ocean Indien)
    -Q (Antartique)"
    exit 1
}

totarg=$#
if [ $totarg -lt 2 ]
then 
    arguments
fi

do_t=0
do_p=0
do_w=0
do_m=0
do_h=0

in_F=0
in_G=0
in_S=0
in_A=0
in_O=0
in_Q=0

#add --tab --avl --abr
while getopts "t:p:wmhFGSAOQf:" o; do
    case "${o}" in
        t)
            tmode=${OPTARG}
            if [ $tmode -gt 3 ] || [ $tmode -lt 1 ]
            then 
                arguments
            fi
            do_t=$tmode
            ;;
        p)
            pmode=${OPTARG}
            if [ $pmode -gt 3 ] || [ $pmode -lt 1 ]
            then 
                arguments
            fi
            do_p=$pmode
            ;;

        w)
            do_w=1
            ;;
        m)
            do_m=1
            ;;
        h)
            do_h=1
            ;;
        
        F)
            if [ $in_A -eq 1 ] || [ $in_F -eq 1 ] || [ $in_G -eq 1 ] || [ $in_O -eq 1 ] || [ $in_Q -eq 1 ] || [ $in_S -eq 1]
            then
                arguments
            fi
            in_F=1
            ;;
        G)
            if [ $in_A -eq 1 ] || [ $in_F -eq 1 ] || [ $in_G -eq 1 ] || [ $in_O -eq 1 ] || [ $in_Q -eq 1 ] || [ $in_S -eq 1]
            then
                arguments
            fi
            in_G=1
            ;;
        S)
            if [ $in_A -eq 1 ] || [ $in_F -eq 1 ] || [ $in_G -eq 1 ] || [ $in_O -eq 1 ] || [ $in_Q -eq 1 ] || [ $in_S -eq 1]
            then
                arguments
            fi
            in_S=1
            ;;
        A)
            if [ $in_A -eq 1 ] || [ $in_F -eq 1 ] || [ $in_G -eq 1 ] || [ $in_O -eq 1 ] || [ $in_Q -eq 1 ] || [ $in_S -eq 1]
            then
                arguments
            fi
            in_A=1
            ;;
        O)
            if [ $in_A -eq 1 ] || [ $in_F -eq 1 ] || [ $in_G -eq 1 ] || [ $in_O -eq 1 ] || [ $in_Q -eq 1 ] || [ $in_S -eq 1]
            then
                arguments
            fi
            in_O=1
            ;;
        Q)
            if [ $in_A -eq 1 ] || [ $in_F -eq 1 ] || [ $in_G -eq 1 ] || [ $in_O -eq 1 ] || [ $in_Q -eq 1 ] || [ $in_S -eq 1]
            then
                arguments
            fi
            in_Q=1
            ;;
        f)
            fmode=${OPTARG}
            ;;

        *)
            arguments
            ;;
    esac
done
shift $((OPTIND-1))

#--temperature mode 1--#
if [ $do_t -eq 1]
then
	cut -d";" -f1,11,12,13 meteo_filtered_data_v1.csv > t1.csv
#--temperature mode 2(moyenne temperature)--#
elif [ $do_t -eq 2]
	cut -d";" -f1,2,11 meteo_filtered_data_v1.csv > t2.csv

#--temperature mode 3--#
elif [ $do_t -eq 3]
	cut -d";" -f1,2,11 meteo_filtered_data_v1.csv > t3.csv
fi


#--pression mode 1--#
if [ $do_p -eq 1]
then
	cut -d";" -f1,7 meteo_filtered_data_v1.csv > p1.csv
	
#--pression mode 2(moyenne temperature)--#
elif [ $do_t -eq 2]
	cut -d";" -f1,2,7 meteo_filtered_data_v1.csv > p2.csv

#--pression mode 3--#
elif [ $do_t -eq 3]
	cut -d";" -f1,2,7 meteo_filtered_data_v1.csv > p3.csv
fi


#--vent--#
if [ $do_w -eq 1]
then
	cut -d";" -f1,4,5 meteo_filtered_data_v1.csv > w.csv
fi

#--altitude--#
if [ $do_h -eq 1]
then
	cut -d";" -f1,14 meteo_filtered_data_v1.csv > h.csv
fi

#--humidite--#
if [ $do_m -eq 1]
then
	cut -d";" -f1,6 meteo_filtered_data_v1.csv > m.csv
fi



##################################################################


echo "$do_t$do_p$do_w$do_m$do_h$in_F$in_G$in_S$in_A$in_O$in_Q">temp.txt
echo "$fmode">file_temp.txt

gcc main.c -o test && ./test

#rm temp.txt
#rm file_temp.txt


##################################################################


#afficher les fichiers
