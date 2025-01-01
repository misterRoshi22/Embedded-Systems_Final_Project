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