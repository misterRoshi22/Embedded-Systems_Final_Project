#line 1 "C:/Users/20210383/Downloads/Embedded-Systems_Final_Project-main/Embedded-Systems_Final_Project-main/src/draw_base.c"
#line 1 "c:/users/20210383/downloads/embedded-systems_final_project-main/embedded-systems_final_project-main/src/../include/misc.h"



void Delay(unsigned int delay);
#line 3 "C:/Users/20210383/Downloads/Embedded-Systems_Final_Project-main/Embedded-Systems_Final_Project-main/src/draw_base.c"
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
