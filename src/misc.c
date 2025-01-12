#include "../include/misc.h"

void Delay(unsigned int delay) {
    while (delay--) {
        Delay_ms(1); // Delay 1 ms at a time
    }
}

void update_current_letter_display(char current_letter) {
    Lcd_Out(4, 1, "Char: ");   // Move to the start of the 4th row
    Lcd_Chr(4, 7, current_letter);  // Display the current letter
}


void update_current_size_display(unsigned int input_size) {
    char local_print_size[7];      // Local buffer for converted size

    IntToStr(input_size, local_print_size);  // Convert size to a string
    ShiftCharsLeft(local_print_size);       // Shift characters to the left
    Lcd_Out(4, 12, "Size: ");               // Display "size:" label
    Lcd_Out(4, 18, local_print_size);       // Display the size value
}

void ShiftCharsLeft(char *str) {
    int length = strlen(str); // Get the length of the string
    int i;

    // Shift characters two positions to the left
    for (i = 3; i < length; i++) {
        str[i - 3] = str[i];
    }

    // Null-terminate the string after shifting
    str[length - 3] = '\0';
}
