#include <ctype.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

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
