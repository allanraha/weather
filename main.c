#include <ctype.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef struct Arbre{
	int elt;
	struct Arbre * fg;
	struct Arbre * fd;
	int equilibre;	
}Arbre;

Arbre * creerArbre(int e){
	Arbre * noeud = malloc(sizeof(Arbre));
	if(noeud==NULL){
		printf("Impossible de creer l'arbre");
		exit(1);
	}
	else{
		noeud->elt = e;
		noeud->fg = NULL;
		noeud->fd = NULL;
		noeud->equilibre = 0;
	}
	return noeud;
}

Arbre * insertionAVL(Arbre * a,int e,int * h){
	if(a == NULL){
		*h=1;
		return(creerArbre(e));
	}
	else if (e < a->elt){
		a->fg = insertionAVL(a->fg,e,h);
		*h = -*h;
	}
	else if( e > a->elt){
		a->fd = insertionAVL(a->fd,e,h);
	}
	else{
		*h=0;
		return(a);
	}
	
	if(*h != 0){
		a->equilibre = a->equilibre + *h;
		if(a->equilibre = 0){
			*h=0;
		}
		else{
			*h=1;
		}
	}
	return(a);
}

int max(int a,int b){
	if(a>b){
		return(a);
	}
	else{
		return(b);
	}
}

int min(int a,int b){
	if(a<b){
		return(a);
	}
	else{
		return(b);
	}
}

Arbre * rotationGauche(Arbre * a){
	Arbre * pivot;
	int eq_a;
	int eq_p;
	
	pivot = a->fd;
	a->fd = pivot->fg;
	pivot->fg = a;
	eq_a = a->equilibre;
	eq_p = pivot->equilibre;
	a->equilibre = eq_a - max(eq_p , 0)-1;
	pivot->equilibre = min(min(eq_a-2, eq_a+eq_p-2),eq_p-1);
	a = pivot;
	return(a); 
		
}

Arbre * rotationDroite(Arbre * a){
	Arbre * pivot;
	int eq_a;
	int eq_p;
	
	pivot = a->fg;
	a->fg = pivot->fd;
	pivot->fd = a;
	eq_a = a->equilibre;
	eq_p = pivot->equilibre;
	a->equilibre = eq_a - min(eq_p , 0)+1;
	pivot->equilibre = max(max(eq_a+2, eq_a+eq_p+2),eq_p+1);
	a = pivot;
	return(a); 
		
}

Arbre * doubleRotationGauche(Arbre * a){
	a->fd = rotationDroite(a->fd);
	return(rotationGauche(a));
}

Arbre * doubleRotationDroite(Arbre * a){
	a->fg = rotationGauche(a->fg);
	return(rotationDroite(a));
}

Arbre * equilibreAVL(Arbre * a){
	if(a->equilibre >= 2){
		if(a->fd->equilibre >= 0){
			return(rotationGauche(a));
		}
		else{
			return(doubleRotationGauche(a));
		}
	}
	else if(a->equilibre <= -2){
		if(a->fg->equilibre <= 0){
			return(rotationDroite(a));
		}
		else{
			return(doubleRotationDroite(a));
		}
	}
	return(a);
}


//  ./main -f <file> -o <output_file> -r (optional, reverse) --tab/--abr/--avl (optional)

int main(int argc, char **argv){
    int fflag = 0;
    int oflag = 0;
    int rflag = 0;
    int optflag = 2; //tab = 0 abr = 1 avl = 2
    int c = 0;
    
    for (int i = 0; i<argc; i++){
        if (strcmp(argv[i], "--tab") == 0){
            argv[i] = "-a";
        }
        else if (strcmp(argv[i], "--abr") == 0){
            argv[i] = "-b";
        }
        else if (strcmp(argv[i], "--avl") == 0){
            argv[i] = "-c";
        }
    }

    char *input_file = NULL;
    char *output_file = NULL;

    while ((c = getopt(argc, argv, "f:o:rabc")) != -1)
        switch (c){
        case 'f':
            fflag = 1;
            input_file = optarg;
            break;
        case 'o':
            oflag = 1;
            output_file = optarg;
            break;
        case 'r':
            rflag = 1;
            break;
        case 'a':
            printf("non");
            optflag = 0;
            break;
        case 'b':
            printf("oui");
            optflag = 1;
            break;
        case 'c':
            optflag = 2;
            break;

        case '?':
            fprintf(stderr, "Option `-%c' non existante\n", optopt);
            return 1;
        default:
            printf("not recognized\n");
            abort();
    }
    
    if (!(fflag & oflag)){
        return 1;
    }

    printf("\n\n");
    printf("fflag = %d, oflag = %d, rflag = %d, optflag = %d\n", fflag, oflag, rflag, optflag);
    printf("input_file = %s, output_file = %s\n", input_file, output_file);

    return 0;
}
