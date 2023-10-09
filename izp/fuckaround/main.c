#include<stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <math.h> // sqrtf
#include <limits.h> // INT_MAX

int main() {
    char arr[10] = "uwuw desu";
    char * ptr = arr;
    //char ** ptr2 = &ptr;

    ptr[5] = 'X';

    printf(arr);
}
