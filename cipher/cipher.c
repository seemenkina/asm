#include <stdlib.h>
#include <stdio.h>
#include <string.h>

extern  void cipher(char* b, int len_b, char* k);
extern size_t input_key(char* key, int key_max_size);

int main (int argc, char * argv[]) {
    if (argc < 4){
        printf("Usage: %s INPUT_FILE CIPHER_FILE RESULT_FILE", argv[0]);
        return 1;
    }
    char* input_file = argv[1];
    char* enc_file = argv[2];
    char* dec_file = argv[3];

    FILE *fptr;
    fptr = fopen(input_file,"r");

    char buffer[1024];
    int len_buffer = fread(buffer, 1, 1024, fptr);

    fclose(fptr);

    char key[100];
    printf("Enter key: ");
    fflush(stdout);
    int len_key = input_key(key, 100);

    cipher(buffer, len_buffer, key);
    printf("Writing encrypted to %s...\n", enc_file);
    fptr = fopen(enc_file, "w");
    fwrite(buffer, 1, len_buffer, fptr);
    fclose(fptr);

    cipher(buffer, len_buffer, key);
    printf("Writing decrypted to %s...\n", dec_file);
    fptr = fopen(dec_file, "w");
    fwrite(buffer, 1, len_buffer, fptr);
    fclose(fptr);

}
