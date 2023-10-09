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
    // load the next contact and save it into a contact struct
    if (loadLine(cont->name) && loadLine(cont->number)) {
        return true;
    } else {
        return false;
    }
    return false;
}

int correctIndex(int index) {
    // convert an incremented or decremented index for charDict to the correct value
    // eg. an index of -2 would wrap around and become 8

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
    // see if the passed character is contained in the passed element of charDict 
    for (int i = matchStringIndex - distance; i <= matchStringIndex + distance; i++) {
        for (int k = 0; k < charDictLen; k++) {
            if (input == charDict[correctIndex(i)][k]) {
                return true;
            }
        }
        
    }
    
    return false;
}

int getMatchStringIndex(char num) {
    //get the index of the corresponding line in charDict based on the query number
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

    int queryIterator = 0;

    for (int stringIterator = 0; stringIterator < (int)strlen(input); stringIterator++) {
        for (int i = 0; i < (int)strlen(query); i++) {
            if (matchChars(input[stringIterator], getMatchStringIndex(query[queryIterator]), distance)) {
                queryIterator++; // match found! now looking for the next matching character

                if (queryIterator == (int)strlen(query) - 1) {
                    return true;
                } else {
                    break;
                }
                
            }
        }
    }

    return false;
}

bool printMatchingContacts(char query[], int distance) {
    contact cont;
    bool loadedCorrectly = loadContact(&cont);
    while (cont.name[0] != '\0' && cont.number[0] != '\0') {
        if (loadedCorrectly) {
            if (matchString(cont.name, query, distance) || matchString(cont.number, query, distance) ) {
                printf("%s, %s\n", cont.name, cont.number);
            }
        } else {
            return true;
        }
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
                return 1;
            }
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
        return 1;
    }
    
    return 0;       
    
}