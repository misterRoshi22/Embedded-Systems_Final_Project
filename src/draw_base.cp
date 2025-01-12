#line 1 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/draw_base.c"
#line 1 "c:/users/shaba/onedrive/desktop/uni/embedded systems/embedded-systems_final_project/src/../include/misc.h"



void Delay(unsigned int delay);
void update_current_letter_display(char current_letter);
void update_current_size_display(unsigned int input_size);
void ShiftCharsLeft(char *str);
#line 3 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/draw_base.c"
const char DRAW_LINE_TIME = 100;
const char DRAW_DIAG_TIME = 102;

void draw_right(unsigned char speed) {
 PORTC |= 0x10;
 PORTC &= 0xBF;
 Delay(speed);
 PORTC |= 0x40;
}

void draw_left(unsigned char speed) {
 PORTC &= 0xEF;
 PORTC &= 0xBF;
 Delay(speed);
 PORTC |= 0x40;
}

void draw_down(unsigned char speed){
 PORTC &= 0xDF;
 PORTC &= 0x7F;
 Delay(speed);
 PORTC |= 0x80;
}

void draw_up(unsigned char speed){
 PORTC |= 0x20;
 PORTC &= 0x7F;
 Delay(speed);
 PORTC |= 0x80;
}

void draw_down_right(unsigned char speed){
 PORTC |= 0x10;
 PORTC &= 0xBF;
 PORTC &= 0xDF;
 PORTC &= 0x7F;
 Delay(speed);
 PORTC |= 0x40;
 PORTC |= 0x80;
}

void draw_down_left(unsigned char speed) {
 PORTC &= 0xDF;
 PORTC &= 0x7F;
 PORTC &= 0xEF;
 PORTC &= 0xBF;
 Delay(speed);
 PORTC |= 0x80;
 PORTC |= 0x40;
}

void draw_up_right(unsigned char speed) {
 PORTC |= 0x10;
 PORTC &= 0xBF;
 PORTC |= 0x20;
 PORTC &= 0x7F;
 Delay(speed);
 PORTC |= 0x80;
 PORTC |= 0x40;
}

void draw_up_left(unsigned char speed) {
 PORTC &= 0xEF;
 PORTC &= 0xBF;
 PORTC |= 0x20;
 PORTC &= 0x7F;
 Delay(speed);
 PORTC |= 0x40;
 PORTC |= 0x80;
}
