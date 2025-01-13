#line 1 "C:/Users/20210383/Desktop/project/src/final_project.c"
#line 1 "c:/users/20210383/desktop/project/src/../include/atd.h"



void ATD_init(void);
unsigned int ATD_read(unsigned char channel);
#line 1 "c:/users/20210383/desktop/project/src/../include/lcd_config.h"

sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;
#line 1 "c:/users/20210383/desktop/project/src/../include/draw_base.h"




void draw_right(unsigned char speed);
void draw_left(unsigned char speed);
void draw_down(unsigned char speed);
void draw_up(unsigned char speed);
void draw_down_right(unsigned char speed);
void draw_down_left(unsigned char speed);
void draw_up_right(unsigned char speed);
void draw_up_left(unsigned char speed);
#line 1 "c:/users/20210383/desktop/project/src/../include/timer_init.h"



void Timer0_Init(void);
void Timer2_Init(void);
void Timer1_Init(void);
#line 1 "c:/users/20210383/desktop/project/src/../include/misc.h"



void Delay(unsigned int delay);
void update_current_letter_display(char current_letter);
void update_current_size_display(unsigned int input_size);
void ShiftCharsLeft(char *str);
#line 8 "C:/Users/20210383/Desktop/project/src/final_project.c"
const unsigned int SERVO_UP = 1800;
const unsigned int SERVO_DOWN = 1000;
const char MIN_LETTERS_PER_LINE = 10;
const char MAX_LETTERS_PER_LINE = 20;

char braille_map[64] = {
 ' ', '\n', '!', '!', '!', '!', '!', '!',
 '!', '!', '!', '!', '!', '!', '!', '!',
 '!', '!', '!', '!', '!', '!', '!', '!',
 'I', '!', 'S', '!', 'J', 'W', 'T', '!',
 'A', '!', 'K', 'U', 'E', '!', 'O', 'Z',
 'B', '!', 'L', 'V', 'H', '!', 'R', '!',
 'C', '!', 'M', 'X', 'D', '!', 'N', 'Y',
 'F', '!', 'P', '!', 'G', '!', 'Q', '!',
};


char print_speed[7];
unsigned char HL = 1;
unsigned int angle;
unsigned char letter = 0x00;
unsigned char size;


unsigned char count_overflow = 0;
unsigned char speed_tester = 0;


char current_row = 1;
char current_column = 1;
char previous_letter = 0x00;
char letters_per_line = 20;

void pen_up(void);
void pen_down(void);

void draw_a(void);
void draw_b(void);
void draw_c(void);
void draw_d(void);
void draw_e(void);
void draw_f(void);
void draw_g(void);
void draw_h(void);
void draw_i(void);
void draw_j(void);
void draw_k(void);
void draw_l(void);
void draw_m(void);
void draw_n(void);
void draw_o(void);
void draw_p(void);
void draw_q(void);
void draw_r(void);
void draw_s(void);
void draw_t(void);
void draw_u(void);
void draw_v(void);
void draw_w(void);
void draw_x(void);
void draw_y(void);
void draw_z(void);
void draw_space(void);

void move_next_letter(void);
void enter_new_line(void);


void interrupt(void) {

 if (INTCON & 0x04) {
 PORTC ^= 0x02;
 PORTC ^= 0x08;
 INTCON &= ~0x04;
TMR0 = 150 + ((size - 50) * (250 - 150)) / (150 - 50);



 count_overflow++;
 }

 if(count_overflow == 255) speed_tester++;






 if(PIR1 & 0x04){
 if(HL) {
 CCPR1H = angle >> 8;
 CCPR1L = angle;
 HL = 0;
 CCP1CON = 0x09;
 TMR1H = 0;
 TMR1L = 0;
 }

 else {
 CCPR1H = (40000 - angle) >> 8;
 CCPR1L = (40000 - angle);
 CCP1CON = 0x08;
 HL = 1;
 TMR1H = 0;
 TMR1L = 0;
 }

 PIR1 = PIR1&0xFB;
 }
}

void main() {
 TRISC = 0x00;
 PORTC = 0xC0;

 TRISD = 0xFF;
 PORTD = 0x00;



 ATD_init();
 Timer0_Init();

 Timer1_Init();
 Lcd_Init();

 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);



 INTCON |= 0x80;
 INTCON |= 0x40;


 while (1) {

 size = ATD_read(0);
 size = 50 + ((size * (150 - 50)) / 242);
 letters_per_line = MAX_LETTERS_PER_LINE - ((size - 50) * (MAX_LETTERS_PER_LINE - MIN_LETTERS_PER_LINE)) / (150 - 50);







 if (previous_letter != braille_map[letter]) {
 update_current_letter_display(braille_map[letter]);
 previous_letter = braille_map[letter];
 }
 update_current_size_display(size);

 if ((PORTD & 0x40) == 0x40) {
 Delay(50);
 if (current_column > letters_per_line) {
 current_row++;
 current_column = 1;

 if (current_row > 3) {
 Lcd_Cmd(_LCD_CLEAR);
 update_current_letter_display(braille_map[letter]);
 current_row = 1;
 }
 }

 Lcd_Chr(current_row, current_column, braille_map[letter]);

 if (braille_map[letter] == 'A') draw_a();
 if (braille_map[letter] == 'B') draw_b();
 if (braille_map[letter] == 'C') draw_c();
 if (braille_map[letter] == 'D') draw_d();
 if (braille_map[letter] == 'E') draw_e();
 if (braille_map[letter] == 'F') draw_f();
 if (braille_map[letter] == 'G') draw_g();
 if (braille_map[letter] == 'H') draw_h();
 if (braille_map[letter] == 'I') draw_i();
 if (braille_map[letter] == 'J') draw_j();
 if (braille_map[letter] == 'K') draw_k();
 if (braille_map[letter] == 'L') draw_l();
 if (braille_map[letter] == 'M') draw_m();
 if (braille_map[letter] == 'N') draw_n();
 if (braille_map[letter] == 'O') draw_o();
 if (braille_map[letter] == 'P') draw_p();
 if (braille_map[letter] == 'Q') draw_q();
 if (braille_map[letter] == 'R') draw_r();
 if (braille_map[letter] == 'S') draw_s();
 if (braille_map[letter] == 'T') draw_t();
 if (braille_map[letter] == 'U') draw_u();
 if (braille_map[letter] == 'V') draw_v();
 if (braille_map[letter] == 'W') draw_w();
 if (braille_map[letter] == 'X') draw_x();
 if (braille_map[letter] == 'Y') draw_y();
 if (braille_map[letter] == 'Z') draw_z();
 if (braille_map[letter] == '\n') {
 enter_new_line();
 current_column = 1;
 current_row++;
 if (current_row > 3) {
 Lcd_Cmd(_LCD_CLEAR);
 current_row = 1;
 }
 }
 if (braille_map[letter] == ' ') draw_space();

 if (braille_map[letter] != '\n') {
 move_next_letter();
 current_column++;
 }

 letter = 0x00;

 while ((PORTD & 0x40));
 Delay(50);
 }

 if (PORTD & 0x01) letter |= 0x01;
 if (PORTD & 0x02) letter |= 0x02;
 if (PORTD & 0x04) letter |= 0x04;
 if (PORTD & 0x08) letter |= 0x08;
 if (PORTD & 0x10) letter |= 0x10;
 if (PORTD & 0x20) letter |= 0x20;
 if (PORTD & 0x80) letter = 0x00;

 }

}


void pen_up(void) {
 angle = SERVO_UP;
 Delay(100);
}

void pen_down(void) {
 angle = SERVO_DOWN;
 Delay(100);
}

void draw_a(void) {
 draw_up_left(100);
 draw_down(100);
 draw_down(100);
 draw_up(100);
 draw_right(100);
 draw_down_right(100);
 pen_up();
 draw_up_left(100);
 pen_down();
}

void draw_b(void) {
 draw_right(100);
 draw_down(100);
 draw_left(100);
 draw_left(100);
 draw_up(100);
 draw_up(100);
 draw_right(100);
 draw_down(100);
 draw_left(100);
 draw_right(100);
}

void draw_c(void) {
 pen_up();
 draw_up_right(100);
 pen_down();
 draw_left(100);
 draw_left(100);
 draw_down(100);
 draw_down(100);
 draw_right(100);
 draw_right(100);
 pen_up();
 draw_up_left(100);
 pen_down();
}

void draw_d(void) {
 draw_up_left(100);
 draw_down(100);
 draw_down(100);
 draw_up_right(100);
}

void draw_e(void) {
 draw_left(100);
 draw_up(100);
 draw_right(100);
 pen_up();
 draw_down(100);
 draw_down(100);
 pen_down();
 draw_left(100);
 draw_up(100);
 draw_right(100);
}

void draw_f(void) {
 draw_left(100);
 draw_up(100);
 draw_right(100);
 pen_up();
 draw_down(100);
 draw_down(100);
 draw_left(100);
 pen_down();
 draw_up(100);
 pen_up();
 draw_right(100);
 pen_down();
}

void draw_g(void) {
 draw_right(100);
 draw_down_left(100);
 draw_up_left(100);
 draw_up_right(100);
 pen_up();
 draw_down(100);
}

void draw_h(void) {
 draw_left(100);
 draw_up(100);
 draw_down(100);
 draw_down(100);
 pen_up();
 draw_right(100);
 draw_right(100);
 pen_down();
 draw_up(100);
 draw_up(100);
 draw_down(100);
 draw_left(100);
}

void draw_i(void) {
 draw_up(100);
 draw_right(100);
 draw_left(100);
 draw_left(100);
 pen_up();
 draw_down(100);
 draw_down(100);
 pen_down();
 draw_right(100);
 draw_right(100);
 draw_left(100);
 draw_up(100);
}

void draw_j(void) {
 pen_up();
 draw_up(100);
 pen_down();
 draw_right(100);
 draw_down(100);
 draw_down_left(100);
 draw_up(100);
}

void draw_k(void) {
 draw_up_right(100);
 pen_up();
 draw_down(100);
 draw_down(100);
 pen_down();
 draw_up_left(100);
 draw_up(100);
 draw_down(100);
 draw_down(100);
 draw_up(100);
}

void draw_l(void) {
 pen_up();
 draw_up_left(100);
 pen_down();
 draw_down(100);
 draw_down(100);
 draw_right(100);
 pen_up();
 draw_up(100);
 pen_down();






}

void draw_m(void) {
 draw_up_right(100);
 draw_down(100);
 draw_down(100);
 pen_up();
 draw_left(100);
 draw_left(100);
 pen_down();
 draw_up(100);
 draw_up(100);
 draw_down_right(100);
}

void draw_n(void) {
 pen_up();
 draw_down_left(100);
 pen_down();
 draw_up(100);
 draw_up(100);
 draw_down_right(100);
 draw_down_right(100);
 draw_up(100);
 draw_up(100);
 pen_up();
 draw_down_right(100);
 pen_down();
}

void draw_o(void) {
 pen_up();
 draw_up(100);
 pen_down();
 draw_down_right(100);
 draw_down_left(100);
 draw_up_left(100);
 draw_up_right(100);
 pen_up();
 draw_down(100);
 pen_down();
}

void draw_p(void) {
 draw_right(100);
 draw_up(100);
 draw_left(100);
 draw_down(100);
 draw_down(100);
 pen_up();
 draw_up_right(100);
}

void draw_q(void) {
 draw_down_right(100);
 pen_up();
 draw_left(100);
 pen_down();
 draw_up_left(100);
 draw_up_right(100);
 draw_down_right(100);
 draw_down_left(100);
 pen_up();
 draw_up(100);
 pen_down();
}

void draw_r(void) {
 draw_down(100);
 pen_up();
 draw_right(100);
 pen_down();
 draw_up_left(100);
 draw_up(100);
 draw_down_right(100);
 draw_left(100);
}

void draw_s(void) {
 pen_up();
 draw_down_left(100);
 pen_down();
 draw_right(100);
 draw_up_right(100);
 draw_left(100);
 draw_left(100);
 draw_up_right(100);
 draw_right(100);
 pen_up();
 draw_down_left(100);
 pen_down();
}

void draw_t(void){
 draw_up(100);
 draw_right(100);
 draw_left(100);
 draw_left(100);
 pen_up();
 draw_down_right(100);
 pen_down();
 draw_down(100);
 draw_up(100);
}

void draw_u(void) {
 pen_up();
 draw_up_left(100);
 pen_down();
 draw_down(100);
 draw_down_right(100);
 draw_right(100);
 draw_up(100);
 draw_up(100);
 pen_up();
 draw_down_left(100);
 pen_down();
}

void draw_v(void) {
 pen_up();
 draw_up_left(100);
 pen_down();
 draw_down(100);
 draw_down(100);
 draw_up_right(100);
 draw_up_right(100);
 pen_up();
 draw_down_left(100);
}

void draw_x(void) {
 draw_up_left(100);
 pen_up();
 draw_down(100);
 draw_down(100);
 pen_down();
 draw_up_right(100);
 draw_up_right(100);
 pen_up();
 draw_down(100);
 draw_down(100);
 pen_down();
 draw_up_left(100);
}

void draw_w(void) {
 draw_down_left(100);
 draw_up(100);
 draw_up(100);
 pen_up();
 draw_right(100);
 draw_right(100);
 pen_down();
 draw_down(100);
 draw_down(100);
 draw_up_left(100);
}

void draw_y(void) {
 draw_up_left(100);
 pen_up();
 draw_right(100);
 draw_right(100);
 pen_down();
 draw_down_left(100);
 draw_down(100);
 pen_up();
 draw_up(100);
}

void draw_z(void) {
 draw_up_right(100);
 draw_left(100);
 draw_left(100);
 pen_up();
 draw_down_right(100);
 pen_down();
 draw_down_left(100);
 draw_right(100);
 draw_right(100);
 pen_up();
 draw_up_left(100);
}


void draw_space(void) {






}

void move_next_letter(void) {
 pen_up();
 draw_right(100);
 draw_right(100);
 draw_right(100);
 pen_down();
}

unsigned char times;
void enter_new_line(void) {
 pen_up();
 for(times = 0; times<2*(current_column)+2; times++) draw_left(100);
 draw_down(100);
 draw_down(100);
 draw_down(100);
 pen_down();
}
