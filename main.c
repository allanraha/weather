#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//  ./main -f <file> -o <output_file> -r (optional, reverse) --tab/--abr/--avl (optional)

int main(int argc, char **argv){
    int fflag = 0;
    int oflag = 0;
    int rflag = 0;
    int optflag = 0; 
    int c;

    for (int i = 0; i<argc; i++){
        if (strcmp(argv[i], "--tab")){
            argv[i] = "-0";
        }
        else if (strcmp(argv[i], "--abr")){
            argv[i] = "-1";
        }
        else if (strcmp(argv[i], "--avl")){
            argv[i] = "-2";
        }
    }

    while ((c = getopt(argc, argv, "f:o:r012")) != -1) switch (c){
        case 'f':
            fflag = 1;
            break;
        case 'o':
            oflag = 1;
            break;
        case 'r':
            rflag = 1;
            break;
        case '0':
            optflag = 1;
            break;


        case '?':
            fprintf(stderr, "Option `-%c' non existante\n", optopt);
            return 1;
        default:
            abort();
        }

    if (!fflag || !oflag){
        return 1;
    }
    
    printf("fflag = %d, oflag = %d\n", fflag, oflag);

    return 0;
}
