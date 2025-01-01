#line 1 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/draw_letters.c"
#line 1 "c:/users/shaba/onedrive/desktop/uni/embedded systems/embedded-systems_final_project/src/../include/draw_base.h"




void draw_right(void);
void draw_left(void);
void draw_down(void);
void draw_up(void);
void draw_down_right(void);
void draw_up_left(void);
#line 1 "c:/users/shaba/onedrive/desktop/uni/embedded systems/embedded-systems_final_project/src/../include/draw_letters.h"



void draw_e(void);
void draw_a(void);
void draw_i(void);
void draw_h(void);
void draw_l(void);
void move_next_letter(void);
void enter_new_line(void);
#line 4 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/draw_letters.c"
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

void draw_i(void) {
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
void move_next_letter(void) {
 draw_right();
 draw_right();
}
unsigned char times;

void enter_new_line(void) {
 for(times = 0; times<6; times++) draw_left();
 draw_down();
 draw_down();
}
