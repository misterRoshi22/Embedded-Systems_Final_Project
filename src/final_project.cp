#line 1 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/final_project.c"
#line 1 "c:/users/shaba/onedrive/desktop/uni/embedded systems/embedded-systems_final_project/src/../include/atd.h"



void ATD_init(void);
unsigned int ATD_read(unsigned char channel);
#line 1 "c:/users/shaba/onedrive/desktop/uni/embedded systems/embedded-systems_final_project/src/../include/lcd_config.h"

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
#line 1 "c:/users/shaba/onedrive/desktop/uni/embedded systems/embedded-systems_final_project/src/../include/draw_base.h"




void draw_right(unsigned char speed);
void draw_left(unsigned char speed);
void draw_down(unsigned char speed);
void draw_up(unsigned char speed);
void draw_down_right(unsigned char speed);
void draw_down_left(unsigned char speed);
void draw_up_right(unsigned char speed);
void draw_up_left(unsigned char speed);
#line 1 "c:/users/shaba/onedrive/desktop/uni/embedded systems/embedded-systems_final_project/src/../include/timer_init.h"



void Timer0_Init(void);
void Timer2_Init(void);
void Timer1_Init(void);
#line 1 "c:/users/shaba/onedrive/desktop/uni/embedded systems/embedded-systems_final_project/src/../include/misc.h"



void Delay(unsigned int delay);
#line 7 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/final_project.c"
unsigned int analog_value;
unsigned char timer_value;
char print_string[7];
unsigned char update_lcd = 0;
unsigned char HL = 1;
unsigned int angle;
unsigned char times;
unsigned char size = 500;

unsigned char char_count = 0;
unsigned char letter = 0x00;

const char letters_per_line = 20;
const unsigned int SERVO_UP = 1800;
const unsigned int SERVO_DOWN = 1000;
unsigned int k;
unsigned char myscaledVoltage;

char print_speed[7];
char print_angle[7];

char braille_map[64] = {
 ' ', '!', '!', '!', '!', '!', '!', '1',
 '!', '!', '!', '!', '!', '!', '!', '1',
 '!', '!', '!', '!', '!', '!', '!', '1',
 'i', '!', 's', '!', 'j', 'w', 't', '!',
 'a', '!', 'k', 'u', 'e', '!', 'o', 'z',
 'b', '!', 'l', 'v', 'h', '!', 'r', '!',
 'c', '!', 'm', 'x', 'd', '!', 'n', 'y',
 'f', '!', 'p', '!', 'g', '!', 'q', '!',
};

void Delay(unsigned int delay);

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

unsigned char count_overflow = 0;
unsigned char speed_tester = 0;
char print_speed_tester[7];


void interrupt(void) {

 if (INTCON & 0x04) {
 PORTC ^= 0x02;
 PORTC ^= 0x08;
 INTCON &= ~0x04;
 TMR0 = 0xE8 + ((size - 50) * (0xF8 - 0xE8)) / (255 - 50);
 count_overflow++;
 }
 if(count_overflow == 255) speed_tester++;
#line 96 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/final_project.c"
 if(PIR1 & 0x04){
 if(HL){
 CCPR1H = angle >> 8;
 CCPR1L = angle;
 HL = 0;
 CCP1CON = 0x09;
 TMR1H = 0;
 TMR1L = 0;
 }
 else{
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
 ATD_init();

 TRISD = 0xFF;


 Timer0_Init();

 Timer1_Init();

 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);



 INTCON |= 0x80;
 INTCON |= 0x40;

 while (1) {

 size = ATD_read(0);

 IntToStr(size, print_speed);
 Lcd_Out(1, 1, print_speed);

 IntToStr(speed_tester, print_speed_tester);
 Lcd_Out(2, 1, print_speed_tester);


 if ((PORTD & 0x40) == 0x40) {
 Delay(50);
 if (char_count == letters_per_line) {
 Lcd_Cmd(_LCD_SECOND_ROW);
 enter_new_line();
 }
 else if(char_count == 2*letters_per_line) {
 Lcd_Cmd(_LCD_THIRD_ROW);
 enter_new_line();
 }
 else if(char_count == 3*letters_per_line) {
 Lcd_Cmd(_LCD_FOURTH_ROW);
 enter_new_line();
 }
 else if(char_count == 4*letters_per_line){
 Lcd_Cmd(_LCD_CLEAR);
 enter_new_line();
 char_count == 0;
 }
 Lcd_Chr_Cp(braille_map[letter]);
 char_count++;

 if(braille_map[letter] == 'a') draw_a();
 if(braille_map[letter] == 'b') draw_b();
 if(braille_map[letter] == 'c') draw_c();
 if(braille_map[letter] == 'd') draw_d();
 if(braille_map[letter] == 'e') draw_e();
 if(braille_map[letter] == 'f') draw_f();
 if(braille_map[letter] == 'g') draw_g();
 if(braille_map[letter] == 'h') draw_h();
 if(braille_map[letter] == 'i') draw_i();
 if(braille_map[letter] == 'j') draw_j();
 if(braille_map[letter] == 'k') draw_k();
 if(braille_map[letter] == 'l') draw_l();
 if(braille_map[letter] == 'm') draw_m();
 if(braille_map[letter] == 'n') draw_n();
 if(braille_map[letter] == 'o') draw_o();
 if(braille_map[letter] == 'p') draw_p();
 if(braille_map[letter] == 'q') draw_q();
 if(braille_map[letter] == 'r') draw_r();
 if(braille_map[letter] == 's') draw_s();
 if(braille_map[letter] == 't') draw_t();
 if(braille_map[letter] == 'u') draw_u();
 if(braille_map[letter] == 'v') draw_v();
 if(braille_map[letter] == 'w') draw_w();
 if(braille_map[letter] == 'x') draw_x();
 if(braille_map[letter] == 'y') draw_y();
 if(braille_map[letter] == 'z') draw_z();

 letter = 0x00;


 while ((PORTD & 0x40) == 0x40);
 Delay(50);
 }

 if ((PORTD & 0x01) == 0x01) letter |= 0x01;
 if ((PORTD & 0x02) == 0x02) letter |= 0x02;
 if ((PORTD & 0x04) == 0x04) letter |= 0x04;
 if ((PORTD & 0x08) == 0x08) letter |= 0x08;
 if ((PORTD & 0x10) == 0x10) letter |= 0x10;
 if ((PORTD & 0x20) == 0x20) letter |= 0x20;
 if ((PORTD & 0x80) == 0x80) letter = 0x00;
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
 draw_right(100);
 draw_right(100);
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
 pen_up();
 draw_right(100);
 draw_right(100);
 draw_right(100);
 draw_right(100);
 pen_down();
}

void move_next_letter(void) {
pen_up();
 draw_right(100);
 draw_right(100);
pen_down();
}

void enter_new_line(void) {
pen_up();
 for(times = 0; times<2*(letters_per_line-1); times++) draw_left(100);
 draw_down(100);
 draw_down(100);
pen_down();
}
