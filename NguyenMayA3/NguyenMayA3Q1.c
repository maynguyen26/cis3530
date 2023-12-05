 /*
 * CIS*3530 Assignment 3 - Question 1: C program that implements a given SQL subquery
 * 
 * File Description: 
 * - Given the structure defintions of Supplier and SupplierPart, this program
 *   populates arrays with values given by a csv file and then implements the 
 *   following subquery: 
 * 
        SELECT SNAME
        FROM S
        WHERE NOT EXISTS (SELECT *
        FROM SP
        WHERE S.SNO=SP.SNO
        AND SP.PNO = ‘P2’);
 
 * Execution: 
 * - ./a3q1 <Sfilename>.csv <SPfilename>.csv, 
 *                          where Xfilename is the name of a csv file (that uses ','
 *                          as a delimiter) provided in the same directory as the 
 *                          executable file containing tuples of a relation defined 
 *                          with the same attributes as Supplier and SupplierPart, 
 *                          respectively
 * 
 * Author: May Nguyen (1051760)
 * Due Date: Friday, November 24th, 2023
 * 
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_ROWS 100   // Maximum number of tuples in CSV
#define MAX_STRING 100 // Maximum length of a string

/* Given by the assignment description */
struct Supplier {
    char sno [4]; // Supplier Number
    char sname [20]; // Supplier Name
    int status;
    char city [20];
};

struct SupplierPart {
    char sno [4]; // Supplier Number
    char pno [4]; // Part Number
    int qty;
};


/* readCSV: reads the s.csv file and imports the data into array given 
            returns the number of lines read */
int readSCSV(const char *filename, struct Supplier *array) {
    // if file does not exists
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        perror("error opening the s.csv file");
        exit(1);
    }

    char line[MAX_STRING];
    int row = 0;

    //loop through each line of the file
    while (fgets(line, sizeof(line), file) != NULL) {
        // skip the header line
        if (row != 0) {
            sscanf(line, "%4[^,],%20[^,],%d,%20[^,\n]", array[row-1].sno, array[row-1].sname, &(array[row-1].status), array[row-1].city);
        }
        row++;
    }

    fclose(file);
    return row-1;
}

/* readSPCSV: reads the sp.csv files and imports the data into array given
              returns the number of lines read */ 
int readSPCSV(const char *filename, struct SupplierPart *array) {
    // if file does not exists
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        perror("error opening the sp.csv file");
        exit(1);
    }

    char line[MAX_STRING];
    int row = 0;

    //loop through each line of the file
    while (fgets(line, sizeof(line), file) != NULL) {
        // skip the header line
        if (row != 0) {
            sscanf(line, "%4[^,],%4[^,],%d", array[row-1].sno, array[row-1].pno, &(array[row-1].qty));
        }
        row++;
    }

    fclose(file);
    return row-1;
}

/* strcmp_ignorecase: compare the lower case values of two strings and 
                      returns -1 if the two strings are not equal, 0 if they are */
int strcmp_ignorecase(char *str1, char *str2) {
    int cmp = 0;
    while (*str1 && *str2) {
        if (tolower(*str1) != tolower(*str2)) {
            cmp = -1;
        } 
        str1++;
        str2++;
    }

    if (cmp == 0 && !(*str1 == '\0' && *str2 == '\0')) {
        cmp = -1;
    }

    return cmp;
}

/* string_to_upper: converts the given string to uppercase */
char* string_to_upper (char *string) {
    char* print_str = (char*) malloc(strlen(string)+1);
    strcpy(print_str, string);
    char* ch = print_str;
    while (*print_str) {
        *print_str = toupper(*print_str);
        print_str++;
    }
    return ch;
}

/* sub_query: returns true if there are no instances where s.sno == sp.sno and sp.pno == "P2" */
int sub_query(char* ssno, int i, struct SupplierPart *sp, int sp_length) {
    int query = 1; 
    for (int j = 0; j < sp_length; j++) {
        if (strcmp_ignorecase(ssno, sp[j].sno) == 0 && strcmp_ignorecase(sp[j].pno, "p2") == 0) {
            query = 0;
        }
    }
    return query;
}

/* implement_query: */
void implement_query(struct Supplier *s, int s_length, struct SupplierPart *sp, int sp_length) {
    int rows = 0;
    //SELECT sname from s
    printf(" sname \n-------\n");

    for (int i = 0; i < s_length; i++) {
        // WHERE NOT EXISTS 
        if (sub_query(s[i].sno, i, sp, sp_length)) {
            char* print_str = string_to_upper(s[i].sname);
            printf(" %s\n", print_str); 
            free(print_str);
            rows++;
        }
    }

    printf("(%d rows)\n\n", rows);
}

int main(int argc, char *argv[]) {

    struct Supplier suppliers[MAX_ROWS];
    struct SupplierPart supplierParts[MAX_ROWS];

    // failure to provide input file
   if (argc != 3) {
      fprintf(stderr, "usage: %s <Sfilename>.csv <SPfilename>.csv\n", argv[0]);
      exit(1);
   }

    // read data from s.csv and populate the s array
    int s_length = readSCSV(argv[1], suppliers);

    // read data from sp.csv and populate the sp array
    int sp_length = readSPCSV(argv[2], supplierParts);

    /*
    // print the data from the s array
    printf("supplier array:\n");
    for (int i = 0; i < s_length; i++) {
        printf("row %d: sno = %s sname = %s status = %d city = %s \n", i+1, suppliers[i].sno, suppliers[i].sname, suppliers[i].status, suppliers[i].city);
    }

    // print the data from the sp array 
    printf("\nsupplierpart array:\n");
    for (int i = 0; i < sp_length; i++) {
        printf("row %d: sno = %s pno = %s qty = %d\n", i+1, supplierParts[i].sno, supplierParts[i].pno, supplierParts[i].qty);
    }
    */

    implement_query(suppliers, s_length, supplierParts, sp_length);

    return 0;
}

