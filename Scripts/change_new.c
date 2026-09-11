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

int main() {
    char fileName[100];
    char password[100] = "(9++";
    char password2[95];
    
    printf("Enter file name: ");
    scanf("%s", fileName);
    
    printf("Enter new password: ");
    scanf("%s", password2);
    encrypt_password(password2);
    
    FILE *file = fopen(fileName, "rb+");
    if (file == NULL) {
        printf("could not open file.\n");
        return 1;
    }
    
    int match_index = 0;
    int current_byte;
    long patch_position = -1;
    while ((current_byte = fgetc(file)) != EOF) {
        if (current_byte == password[match_index]) {
            match_index++;
            if (match_index == strlen(password)) {
                patch_position = ftell(file);
                break;
            }
        } else {
            match_index = 0;
        }
    }
    
    if (patch_position == -1) {
        printf("old password is different\n");
        fclose(file);
        return 1;
    }
    
    fseek(file, patch_position, SEEK_SET);
    fwrite(password2, 1, strlen(password2), file);
    char null_byte = '\0';
    fwrite(&null_byte, 1, 1, file);
    printf("password changed successfully.\n");
    fclose(file);
    return 0;
}