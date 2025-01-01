#line 1 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/draw_base.c"
const char DRAW_LINE_TIME = 100;
const char DRAW_DIAG_TIME = 102;

void draw_right(void) {
 PORTC |= 0x10;
 PORTC &= 0xBF;
 Delay_ms(DRAW_LINE_TIME);
 PORTC |= 0x40;
}

void draw_left(void) {
 PORTC &= 0xEF;
 PORTC &= 0xBF;
 Delay_ms(DRAW_LINE_TIME);
 PORTC |= 0x40;
}

void draw_down(void){
 PORTC &= 0xDF;
 PORTC &= 0x7F;
 Delay_ms(DRAW_LINE_TIME);
 PORTC |= 0x80;
}

void draw_up(void){
 PORTC |= 0x20;
 PORTC &= 0x7F;
 Delay_ms(DRAW_LINE_TIME);
 PORTC |= 0x80;
}

void draw_down_right(void){
 PORTC |= 0x10;
 PORTC &= 0xBF;
 PORTC &= 0xDF;
 PORTC &= 0x7F;
 Delay_ms(DRAW_DIAG_TIME);
 PORTC |= 0x40;
 PORTC |= 0x80;
}

void draw_up_left(void) {
 PORTC &= 0xEF;
 PORTC &= 0xBF;
 PORTC |= 0x20;
 PORTC &= 0x7F;
 Delay_ms(DRAW_DIAG_TIME);
 PORTC |= 0x40;
 PORTC |= 0x80;
}
