#line 1 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/misc.c"
#line 1 "c:/users/shaba/onedrive/desktop/uni/embedded systems/embedded-systems_final_project/src/../include/misc.h"



void Delay(unsigned int delay);
void update_current_letter_display(char current_letter);
void update_current_size_display(unsigned int input_size);
void ShiftCharsLeft(char *str);
#line 3 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/misc.c"
void Delay(unsigned int delay) {
 while (delay--) {
 Delay_ms(1);
 }
}

void update_current_letter_display(char current_letter) {
 Lcd_Out(4, 1, "Char: ");
 Lcd_Chr(4, 7, current_letter);
}


void update_current_size_display(unsigned int input_size) {
 char local_print_size[7];

 IntToStr(input_size, local_print_size);
 ShiftCharsLeft(local_print_size);
 Lcd_Out(4, 12, "Size: ");
 Lcd_Out(4, 18, local_print_size);
}

void ShiftCharsLeft(char *str) {
 int length = strlen(str);
 int i;


 for (i = 3; i < length; i++) {
 str[i - 3] = str[i];
 }


 str[length - 3] = '\0';
}
