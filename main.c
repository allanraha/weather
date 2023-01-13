#include <stdlib.h>
#include <stdio.h>


int get_args(){
    FILE * file;
    char ch;
    
    file = fopen("temp.txt", "r");

    if (file == NULL){
        printf("erreur ouverture temp\n");
        return 1;
    }

    do {
        ch = fgetc(file);
        printf("%c", ch);
    }while (ch != EOF);

    fclose(file);
    return 0;
}


int main(){
    get_args();
    return 0;
}
