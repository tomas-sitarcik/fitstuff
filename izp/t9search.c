#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct {
    char name[100];
    char number[100];
} contact;

contact contactList[100];
contact cont;

char charDict[10][10] = {
            "0+",
            "1",
            "2abcABC",
            "3defDEF",
            "4hgiGHI",
            "5jklJKL",
            "6mnoMNO",
            "7pqrsPQRS",
            "8tuvTUV",
            "9wxyzWXYZ"
                    };

const int charDictLen = 10;

bool loadLine(char line[100]) {
    char input = getchar();
    int i = 0;

    if (input == EOF) {
        line[0] = EOF;
        return false;
    }

    while (input != '\n' && input != EOF) {
        
        if (i > 99) {
            fprintf(stderr, "Invalid input format - a line is over 100 characters long.");
            return false;
        }
        line[i] = input;
        i++;

        input = getchar();
    }

    line[i] = '\0';

    if(line[0] == '\0') {
        return false;
    }

    return true;

}

bool loadContact(contact * cont) {  
    if (loadLine(cont->name) && loadLine(cont->number)) {
        // printf("Loading stage: name and number: %s, %s\n", cont->name, cont->number);
        return true;
    } else {
        // printf("Loading stage: name and number: %d, %d\n", cont->name[0], cont->number[0]);
        return false; // normal behaviour for a correctly formatted input file.
    }

    return false;
}

int correctIndex(int index) {
    // convert an in or decremented index for charDict to the correct value

    if (index >= 0 && index <= 9) {
        return index;
    } 

    if (index < 0) {
        return 10 + (index % 10); 
    }

    if (index > 9) {
        return index % 10;
    }

    return -1;
}

bool matchChars(char input, int matchStringIndex, int distance) {
    // printf("matchStringIndex is %d\n", matchStringIndex);
    for (int i = matchStringIndex - distance; i < matchStringIndex + 1 + distance; i++) {
        // printf("matching, string = %c with input: = %s\n", input, charDict[correctIndex(i)]);
        // printf("index: %d\n", i);
        if (input == *charDict[correctIndex(i)]) {
            return true;
        }
    }
    
    return false;
}

int getMatchStringIndex(char num) {
    for(int i = 0; i < charDictLen; i++) {
        if (charDict[i][0] == num) {
            return i;
        }
    }
    return -1;
}

bool matchString(char input[], char query[], int distance) {
    if (query[0] == '\0') {
        return true;
    }

    int qIter = 0;

    for (int sIter = 0; sIter < (int)strlen(input); sIter++) {
        for (int i = 0; i < (int)strlen(query); i++) {
            //printf("input and query: %c, %d\n", input[sIter], getMatchStringIndex(query[qIter]));
            if (matchChars(input[sIter], getMatchStringIndex(query[i]), distance)) {
                // printf("match on: %c, with matchStringIndex: %d, pos in string: %d, pos in query: %d\n", input[sIter], getMatchStringIndex(query[qIter]), sIter, qIter);
                qIter++; 

                if (qIter == (int)strlen(query)) {
                    // printf("Full match found.\n");
                    return true;
                }
            }
        //    printf("ending match on %c for query(i is %d) %c\n", input[sIter], i, query[i]); 
        }
    }

    return false;
}

bool printMatchingContacts(char query[], int distance) {
    contact cont;
    bool loadedCorrectly = loadContact(&cont);
    // printf("loaded correctly?: %d, data: %s, %s\n", loadedCorrectly, cont.name, cont.number);
    while (cont.name[0] != '\0' && cont.number[0] != '\0') {
        if (loadedCorrectly) {
            // printf("evaluating %s, %s\n", cont.name, cont.number);
            if (matchString(cont.name, query, distance) || matchString(cont.number, query, distance) ) {
                printf("%s, %s\n", cont.name, cont.number);
            }
        } else {
            return true;
        }
        // printf("\n");
        loadedCorrectly = loadContact(&cont);
    }

    return true;
    
}   

bool checkQueryLen(char query[]) {
    if ((int)strlen(query) > 100) {
            /*
                if the query was over 100 characters nothing could possibly match and it would be
                redundant to perform any searches
            */
        fprintf(stderr, "Passed query is over 100 characters.");
        return false;
        }

    return true;
    
}

bool findMatchingContacts(char query[], int distance) {
    if (checkQueryLen(query)) {
        return printMatchingContacts(query, distance);
    } else {
        return false;
    }
}

int main(int argc, char *argv[]) {

    if (argc == 4) { // query, flag and char distance passed
        if (strcmp(argv[2], "-l") == 0) {
            int distance = atoi(argv[3]);
            if (!findMatchingContacts(argv[1], distance)) {
                exit(0);
            }
            //todo complete bonus thing
        }
    }

    if (argc == 2) { // query passed
        findMatchingContacts(argv[1], 0);
    }
    
    if (argc == 1) { // no query
        printMatchingContacts("\0", 0);
    }

    if (argc == 3) {
        fprintf(stderr,"Entered amount of arguments is invalid, did you perhaps forget to specifify the value for the\"-l\" flag?\n");
    }
    
    return 0;       
    
}