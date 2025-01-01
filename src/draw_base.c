#include "../include/draw_base.h"

void draw_right(void) { //direction  = 1 goes to right
  PORTC |= 0x10; //set directionn = 1
  PORTC &= 0xBF; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x40; //set enable = 1
}

void draw_left(void) { //direction = 0 goes to left
  PORTC &= 0xEF;     //set direction = 0
  PORTC &= 0xBF; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x40; //set enable = 1
}

void draw_down(void){ // direction = 1
  PORTC &= 0xDF;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x80; //set enable = 1
}

void draw_up(void){ // direction = 0
  PORTC |= 0x20;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x80; //set enable = 1
}

void draw_down_right(void){
  PORTC |= 0x10; //set directionn = 1
  PORTC &= 0xBF; //set enable = 0
  PORTC &= 0xDF;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_DIAG_TIME);
  PORTC |= 0x40; //set enable = 1
  PORTC |= 0x80; //set enable = 1
}

void draw_up_left(void) {
  PORTC &= 0xEF;     //set direction = 0
  PORTC &= 0xBF; //set enable = 0
  PORTC |= 0x20;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_DIAG_TIME);
  PORTC |= 0x40; //set enable = 1
  PORTC |= 0x80; //set enable = 1
}
#include "../include/draw_base.h"
#include "../include/draw_letters.h"

void draw_e(void) {
  draw_left();
  draw_up();
  draw_right();
  draw_left();
  draw_down();
  draw_down();
  draw_right();
  draw_left();
  draw_up();
  draw_right();
}

void draw_a(void) {
  draw_up_left();
  draw_down();
  draw_down();
  draw_up();
  draw_right();
  draw_down_right();
  draw_up_left();
}

void draw_i(void) { //TODO return to origin
  draw_right();
  draw_right();
  draw_left();
  draw_down();
  draw_down();
  draw_right();
  draw_left();
  draw_left();
}

void draw_h(void) {
  draw_left();
  draw_up();
  draw_down();
  draw_down();
  draw_up();
  draw_right();
  draw_right();
  draw_up();
  draw_down();
  draw_down();
  draw_up();
}

void draw_l(void) {
  draw_down();
  draw_left();
  draw_up();
  draw_up();
  draw_down();
  draw_right();

}
void move_next_letter(void) { //TODO: change to move_right();
     draw_right();
     draw_right();
}
unsigned char times;

void enter_new_line(void) {
  for(times = 0; times<6; times++) draw_left();
  draw_down();
  draw_down();
}