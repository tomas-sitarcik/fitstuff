#include<stdio.h>

#define ROWS 5
#define COLUMNS 5

void loadMatrix(char filename[], int matice[ROWS][COLUMNS]) {
    FILE * fp;

    fp = fopen(filename, "r+");

    for (int i = 0; i < COLUMNS; i++) {
        for (int k = 0; k < ROWS; k++) {
            fscanf(fp, "%d", &matice[i][k]);
        }
    }

    fclose(fp);
}

void saveMatrix(char filename[], int matice[ROWS][COLUMNS]) {
    FILE * fp;

    fp = fopen(filename, "w");

    for (int i = 0; i < COLUMNS; i++) {
        for (int k = 0; k < ROWS; k++) {
            fprintf(fp, "%d ", matice[i][k]);
        }
        fprintf(fp, "\n");
    }

    fclose(fp);
}

int main() {
    int matice[ROWS][COLUMNS];
    loadMatrix("./matrix.txt", matice);
    saveMatrix("./matrix2.txt", matice);
    
    return 0;
}