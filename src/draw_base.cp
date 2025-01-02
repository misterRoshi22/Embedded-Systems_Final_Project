#line 1 "C:/Users/20210383/Desktop/project/src/draw_base.c"
const char DRAW_LINE_TIME = 400;
const char DRAW_DIAG_TIME = 408;
const char SERVO_UP = 1500;
const char SERVO_DOWN = 1000;



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

void move_right(void) {

 PORTC |= 0x10;
 PORTC &= 0xBF;
 Delay_ms(DRAW_LINE_TIME);
 PORTC |= 0x40;
}

void move_left(void) {

 PORTC &= 0xEF;
 PORTC &= 0xBF;
 Delay_ms(DRAW_LINE_TIME);
 PORTC |= 0x40;
}

void move_down(void){

 PORTC &= 0xDF;
 PORTC &= 0x7F;
 Delay_ms(DRAW_LINE_TIME);
 PORTC |= 0x80;
}

void move_up(void){

 PORTC |= 0x20;
 PORTC &= 0x7F;
 Delay_ms(DRAW_LINE_TIME);
 PORTC |= 0x80;
}
