#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void loadLine(char line[100]) {
    int i = 0;
    char input = getchar();
    while (input != '\n' && input != EOF && input != '\0') {

        if (input == '\0') {
            *line = input;
        }

        if (i > 99) {
            fprintf(stderr, "Line contains over 100 characters\n");
            exit(1);
        }

        //printf("%d-%d, ", i, input);
        line[i] = input;
        input = getchar();

        i++;
    }
    line[i] = '\0';
  }

void loadContacts(char contacts[100][2][100]) {
    char name[100];
    char number[100];

    for (int i = 0; i < 100; i++) {
        loadLine(name);
        loadLine(number);
        if (name[0] != '\0' && name[0] != EOF) {
            if(number[0] != '\0' && number[0] != EOF) {
                strcpy(contacts[i][0], name);
                strcpy(contacts[i][1], number);
            }
        } else {
            fprintf(stderr, "Badly formatted input file\n");
            exit(1);
        }
    }
}

int sizeOfContacts(char contacts[100][2][100]) {
    for (int i = 0; i < 100; i++) {
        if (contacts[i][0][0] == '\0' || contacts[i][1][0] == '\0') {
            return i;
        }
    }
    return -1;
}

int main() {
    // using the passed integer(s) as an index
    char silly_map[][4] = {
         {'+'},
         {},
         {'a', 'b', 'c'},
         {'d', 'e', 'f'},
         {'g', 'h', 'i'},
         {'j', 'k', 'l'},
         {'m', 'n', 'o'},
         {'p', 'q', 'r', 's'},
         {'t', 'u', 'v'},
         {'w', 'x', 'y', 'z'}
                          };

    printf("%c\n", silly_map[0][0]);

    char contacts[100][2][100];

    loadContacts(contacts);

    for (int i = 0; i < sizeOfContacts(contacts); i++) {
        if (*contacts[i][0] != '\0') {
            printf("%s %s\n", contacts[i][0], contacts[i][1]);
        }      
    }

    printf("%d\n", sizeOfContacts(contacts));

    return 0;
}