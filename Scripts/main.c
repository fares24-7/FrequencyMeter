#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void encrypt_password(char *password) {
    char key = 'X';
    int i = 0;
    while (password[i] != '\0') {
        password[i] = password[i] ^ key;
        i++;
    }
}
//original password is 1234
int main() {
    static char password[100] = "(9++ijkl\0XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    char password2[100];
    printf("Enter password: ");
    scanf("%s", password2);
    encrypt_password(password2);
    if (strcmp(password + 4, password2) == 0) {
        printf("Password is correct.\n");
    } else {
        printf("Password is incorrect.\n");
    }
    return 0;
}