#include <ctype.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef struct Node{
	int elt;
	char *str;
	struct Node * fg;
	struct Node * fd;
	int equilibre;	
}Node;

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

Node * creerNode(int e, char *str_val){
	printf("test");
	Node * noeud = malloc(sizeof(Node));
	if(noeud==NULL){
		printf("Impossible de creer l'Node");
		exit(1);
	}
	else{
		noeud->elt = e;
		noeud->str = str_val;
		noeud->fg = NULL;
		noeud->fd = NULL;
		noeud->equilibre = 0;
	}
	return noeud;
}

Node * rotationGauche(Node * a){
	Node * pivot;
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

Node * rotationDroite(Node * a){
	Node * pivot;
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

Node * doubleRotationGauche(Node * a){
	a->fd = rotationDroite(a->fd);
	return(rotationGauche(a));
}

Node * doubleRotationDroite(Node * a){
	a->fg = rotationGauche(a->fg);
	return(rotationDroite(a));
}

Node * equilibreAVL(Node * a){
	if(a->equilibre == 2){
		if(a->fd->equilibre >= 0){
			return(rotationGauche(a));
		}
		else{
			return(doubleRotationGauche(a));
		}
	}
	else if(a->equilibre == -2){
		if(a->fg->equilibre <= 0){
			return(rotationDroite(a));
		}
		else{
			return(doubleRotationDroite(a));
		}
	}
	return(a);
}

Node * insertionAVL(Node * a,int e,int * h, char *str_val){
	if(a == NULL){
		*h=1;
		return(creerNode(e, str_val));
	}
	if(e < a->elt){
		a->fg = insertionAVL(a->fg,e,h,str_val);
		*h = -*h;
	}
	else if( e > a->elt){
		a->fd = insertionAVL(a->fd,e,h,str_val);
	}
	else{
		*h=0;
		return(a);
	}
	
	if(*h != 0){
		a->equilibre = a->equilibre + *h;
        a = equilibreAVL(a);
		if(a->equilibre == 0){
			*h=0;
		}
		else{
			*h=1;
		}
	}
	return(a);
}

FILE * fetch_file(char *file_name){
	FILE *f = NULL;
	f = fopen(file_name, "r");
	if (f == NULL){
		exit(2);
	}
	return f;
}

void parcours_save(FILE *file, Node *arbre){
	fprintf(file, "%s", arbre->str);
}

FILE * sort(FILE *file, int column, FILE *output_file){
	char str[200];
	char strcp[200];
	char *temp;
	int val;
	int i;

	Node *arbre = NULL;

	while (fgets(str, 200, file)!=NULL){
		strcpy(strcp, str);
		temp = strtok(strcp, ";");
		for (i = 0; i < column; i++){
			temp = strtok(NULL, ";");
		}
		val = atoi(temp);
		
		arbre = insertionAVL(arbre, val, 0, str);
	}

	//parcours_save(output_file, arbre);
}



//  ./main -f <file> -o <output_file> -c <column_sorted> -r (optional, reverse) --tab/--abr/--avl (optional)

int main(int argc, char **argv){
    int fflag = 0;
    int oflag = 0;
    int rflag = 0;
    int optflag = 2; //tab = 0 abr = 1 avl = 2
    int _arg = 0;
    
    for (int i = 0; i<argc; i++){
        if (strcmp(argv[i], "--tab") == 0){
            argv[i] = "-x";
        }
        else if (strcmp(argv[i], "--abr") == 0){
            argv[i] = "-y";
        }
        else if (strcmp(argv[i], "--avl") == 0){
            argv[i] = "-z";
        }
    }

    char *input_file = NULL;
    char *output_file = NULL;
	int column_to_sort;

    while ((_arg = getopt(argc, argv, "f:o:rxyzc:")) != -1)
        switch (_arg){
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
        case 'x':
            optflag = 0;
            break;
        case 'y':
            optflag = 1;
            break;
        case 'z':
            optflag = 2;
            break;
		case 'c':

			column_to_sort = atoi(optarg);
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

	FILE *data;
	data = fetch_file(input_file);

	FILE *foutput;
	foutput = fopen(output_file, "w");
	if (foutput == NULL){
		exit(2);
	}

	sort(data, 1, foutput);

	fclose(data);

    return 0;
}
