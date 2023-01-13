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
if [ $totarg -eq 0 ]
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

while getopts "t:p:wmhFGSAOQ" o; do
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
        
        *)
            arguments
            ;;
    esac
done
shift $((OPTIND-1))


##################################################################


echo "$do_t$do_p$do_w$do_m$do_h$in_F$in_G$in_S$in_A$in_O$in_Q">temp.txt
gcc main.c -o test && ./test
rm test
#rm temp.txt


##################################################################
