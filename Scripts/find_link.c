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
    char password[100] = "\x30\x2C\x2C\x28";
    char mylink[100];
    printf("Enter file name: ");
    scanf("%s", fileName);
    
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
                patch_position = ftell(file) -strlen(password);
                break;
            }
        } else {
            match_index = 0;
        }
    }
    
    if (patch_position == -1) {
        printf("the link is not found\n");
        fclose(file);
        return 1;
    }
    
    fseek(file, patch_position, SEEK_SET);
    int i = 0;
    int ch;
    
    while ((ch = fgetc(file)) != EOF) {
        if (ch == '\0') {
            break;
        }
        mylink[i] = ch;
        i++;
    }
    mylink[i] = '\0'; 
    
    encrypt_password(mylink);
    char command[1024];

    
    #ifdef _WIN32
        snprintf(command, sizeof(command), "cmd /c start \"\" \"%s\" > NUL 2>&1", mylink);
    #elif __APPLE__
        snprintf(command, sizeof(command), "open \"%s\" > /dev/null 2>&1 &", mylink);
    #elif __linux__
        snprintf(command, sizeof(command), "xdg-open \"%s\" > /dev/null 2>&1 &", mylink);
    #else
        fprintf(stderr, "Unsupported OS\n");
        return 1;
    #endif

    system(command);
    return 0;
}