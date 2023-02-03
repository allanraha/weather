#!/bin/bash

arguments () { #if there is a problem with the args
    echo "probleme dans la saisie de la comande, arguments valides sont les suivants :
OPTION obligatoire:
    -f<nom_fichier> (nom du fichier d'entrée)
OPTIONS (au moins une des options est obligatoire) :
    -t<1.2.3> (temperature)
    -p<1.2.3> (pression)
    -w (vent)
    -m (humiditée)
    -h (altitude)
OPTIONS DE TRIS:
    --avl (tri avec des avl)
    --abr (tri avec des abr)
    --tab (tri avec des tab)
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

#Initialisation
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
#On met par defaut le mode de tri en AVL.
tri_mode="--avl"

#Options de Tri
for i in $(seq 0 $((${#@}-1))); do
  if [ "${@:$i+1:1}" == "--tab" ]; then
    set -- "${@:1:$i}" "-a" "${@:$(($i+2))}"
  elif [ "${@:$i+1:1}" == "--abr" ]; then
    set -- "${@:1:$i}" "-b" "${@:$(($i+2))}"
  elif [ "${@:$i+1:1}" == "--avl" ]; then
    set -- "${@:1:$i}" "-c" "${@:$(($i+2))}"
  fi
done

#Récupere les options choisit par l'utilisateur.
while getopts "t:p:wmhFGSAOQf:abc" o; do
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

        #Si plusieurs options parmi F, G, S, A, O ou Q sont présentes, la fonction "arguments" est également appelée.
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
        a)
            tri_mode="--tab"
            ;;
        b)
            tri_mode="--abr"
            ;;

        c)
            tri_mode="--avl"
            ;;
        *)
            arguments
            ;;
    esac
done
shift $((OPTIND-1))

#Compile le programme C.
gcc main.c -o main


#Filtre les données en fonction des options et les tris avec le programme c
#--temperature mode 1  station,--#
if [ $do_t -eq 1 ]
then
	cut -d";" -f1,11,12,13 $fmode > out_temp.csv
    ./main -f out_temp.csv -o sorted_t1.csv -c 1 $tri_mode
#--temperature mode 2(moyenne temperature)--#
elif [ $do_t -eq 2 ]
then
	cut -d";" -f1,2,11 $fmode > out_temp.csv
    ./main -f out_temp.csv -o sorted_t2.csv -c 2 $tri_mode
#--temperature mode 3--#
elif [ $do_t -eq 3 ]
then
	cut -d";" -f1,2,11 $fmode > out_temp.csv
    ./main -f out_temp.csv -o sorted_t3.csv -c 2 $tri_mode
    ./main -f sorted_t3.csv -o sorted_t3.csv -c 1 $tri_mode
fi


#--pression mode 1--#
if [ $do_p -eq 1 ]
then
	cut -d";" -f1,7 $fmode > out_temp.csv
	./main -f out_temp.csv -o sorted_p1.csv -c 1  $tri_mode
#--pression mode 2(moyenne temperature)--#
elif [ $do_t -eq 2 ]
then
	cut -d";" -f1,2,7 $fmode > out_temp.csv
    ./main -f out_temp.csv -o sorted_p2.csv -c 2 $tri_mode

#--pression mode 3--#
elif [ $do_t -eq 3 ]
then
	cut -d";" -f1,2,7 $fmode > out_temp.csv
    ./main -f out_temp.csv -o sorted_p3.csv -c 2 $tri_mode
    ./main -f sorted_p3.csv -o sorted_p3.csv -c 1 $tri_mode
fi


#--vent--#
if [ $do_w -eq 1 ]
then
	cut -d";" -f1,4,5 $fmode > out_temp.csv
    ./main -f out_temp.csv -o sorted_w.csv -c 1 $tri_mode
fi

#--altitude--#
if [ $do_h -eq 1 ]
then
	cut -d";" -f1,14 $fmode > out_temp.csv
    ./main -f out_temp.csv -o sorted_h.csv -c 2 -r $tri_mode
fi

#--humidite--#
if [ $do_m -eq 1 ]
then
	cut -d";" -f1,6 $fmode > m.csv
    ./main -f out_temp.csv -o sorted_m.csv -c 2 -r $tri_mode
fi





##################################################################


echo "$tri_mode aaa $do_t$do_p$do_w$do_m$do_h$in_F$in_G$in_S$in_A$in_O$in_Q">temp.txt
echo "out_temp.csv">file_temp.txt

rm out_temp.csv

#gcc main.c -o test && ./test

#rm temp.txt
#rm file_temp.txt


##################################################################


#afficher les fichiers

