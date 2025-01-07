#line 1 "C:/Users/20210383/Downloads/Embedded-Systems_Final_Project-main/Embedded-Systems_Final_Project-main/src/final_project.c"
#line 1 "c:/users/20210383/downloads/embedded-systems_final_project-main/embedded-systems_final_project-main/src/../include/atd.h"



void ATD_init(void);
unsigned int ATD_read(unsigned char channel);
#line 1 "c:/users/20210383/downloads/embedded-systems_final_project-main/embedded-systems_final_project-main/src/../include/lcd_config.h"

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
#line 1 "c:/users/20210383/downloads/embedded-systems_final_project-main/embedded-systems_final_project-main/src/../include/draw_base.h"




void draw_right(unsigned char speed);
void draw_left(unsigned char speed);
void draw_down(unsigned char speed);
void draw_up(unsigned char speed);
void draw_down_right(unsigned char speed);
void draw_down_left(unsigned char speed);
void draw_up_right(unsigned char speed);
void draw_up_left(unsigned char speed);
#line 1 "c:/users/20210383/downloads/embedded-systems_final_project-main/embedded-systems_final_project-main/src/../include/timer_init.h"



void Timer0_Init(void);
void Timer2_Init(void);
void Timer1_Init(void);
#line 1 "c:/users/20210383/downloads/embedded-systems_final_project-main/embedded-systems_final_project-main/src/../include/misc.h"



void Delay(unsigned int delay);
#line 7 "C:/Users/20210383/Downloads/Embedded-Systems_Final_Project-main/Embedded-Systems_Final_Project-main/src/final_project.c"
unsigned int analog_value;
unsigned char timer_value;
char print_string[7];
unsigned char update_lcd = 0;
unsigned char HL = 1;
unsigned int angle;
unsigned char times;
unsigned char speed = 500;

unsigned char char_count = 0;
unsigned char letter = 0x00;

const char LETTER_PER_LINE = 20;
const unsigned int SERVO_UP = 1800;
const unsigned int SERVO_DOWN = 1000;
unsigned int k;
unsigned char myscaledVoltage;

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
void draw_e(void);
void draw_f(void);
void draw_h(void);
void draw_i(void);
void draw_k(void);
void draw_l(void);
void draw_space(void);

void move_next_letter(void);
void enter_new_line(void);


void interrupt(void) {

 if (INTCON & 0x04) {
 PORTC ^= 0x02;
 INTCON &= ~0x04;
 TMR0 = 0xF0;
 }

 if (PIR1 & 0x02) {
 PORTC ^= 0x08;
 PIR1 &= ~0x02;
 }

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
 Timer2_Init();
 Timer1_Init();

 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);



 INTCON |= 0x80;
 INTCON |= 0x40;

 while (1) {

 speed = ATD_read(0);
 speed >> 2;

 if ((PORTD & 0x40) == 0x40) {
 delay_ms(50);
 if (char_count == LETTER_PER_LINE) {
 Lcd_Cmd(_LCD_SECOND_ROW);
 enter_new_line();
 }
 else if(char_count == 2*LETTER_PER_LINE) {
 Lcd_Cmd(_LCD_THIRD_ROW);
 enter_new_line();
 }
 else if(char_count == 3*LETTER_PER_LINE) {
 Lcd_Cmd(_LCD_FOURTH_ROW);
 enter_new_line();
 }
 else if(char_count == 4*LETTER_PER_LINE){
 Lcd_Cmd(_LCD_CLEAR);
 enter_new_line();
 char_count == 0;
 }
 Lcd_Chr_Cp(braille_map[letter]);
 char_count++;

 if(braille_map[letter] == 'a') draw_a();
 if(braille_map[letter] == 'b') draw_b();
 if(braille_map[letter] == 'e') draw_e();
 if(braille_map[letter] == 'f') draw_f();
 if(braille_map[letter] == 'h') draw_h();
 if(braille_map[letter] == 'i') draw_i();
 if(braille_map[letter] == 'k') draw_k();
 if(braille_map[letter] == 'l') draw_l();

 letter = 0x00;
 move_next_letter();

 while ((PORTD & 0x40) == 0x40);
 delay_ms(50);
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
 draw_up_left(speed);
 draw_down(speed);
 draw_down(speed);
 draw_up(speed);
 draw_right(speed);
 draw_down_right(speed);
 pen_up();
 draw_up_left(speed);
 pen_down();
}

void draw_b(void) {
 draw_right(speed);
 draw_up(speed);
 draw_up(speed);
 draw_down(speed);
 draw_right(speed);
 draw_down(speed);
 draw_left(speed);
 draw_left(speed);
 draw_up(speed);
 draw_right(speed);
}

void draw_e(void) {
 draw_left(speed);
 draw_up(speed);
 draw_right(speed);
pen_up();
 draw_down(speed);
 draw_down(speed);
pen_down();
 draw_left(speed);
 draw_up(speed);
 draw_right(speed);
}

void draw_f(void) {
 draw_left(speed);
 draw_up(speed);
 draw_right(speed);
 pen_up();
 draw_down(speed);
pen_down();
 draw_right(speed);
 draw_down(speed);
 draw_up(speed);
 draw_right(speed);
}


void draw_h(void) {
 draw_left(speed);
 draw_up(speed);
 draw_down(speed);
 draw_down(speed);
pen_up();
 draw_right(speed);
 draw_right(speed);

 draw_up(speed);
 draw_up(speed);
 draw_down(speed);
 draw_left(speed);
}

void draw_i(void) {
 draw_up(speed);
 draw_right(speed);
 draw_left(speed);
 draw_left(speed);
pen_up();
 draw_down(speed);
 draw_down(speed);
pen_down();
 draw_right(speed);
 draw_right(speed);
 draw_left(speed);
 draw_up(speed);
}

void draw_k(void) {
 draw_up_right(speed);
pen_up();
 draw_down(speed);
 draw_down(speed);
pen_down();
 draw_up_left(speed);
 draw_up(speed);
 draw_down(speed);
 draw_down(speed);
 draw_up(speed);
}

void draw_l(void) {
 draw_up(speed);
 draw_down(speed);
 draw_down(speed);
 draw_right(speed);
 draw_left(speed);
 draw_up(speed);
}

void draw_space(void) {
 pen_up();
 draw_right(speed);
 draw_right(speed);
 draw_right(speed);
 draw_right(speed);
 pen_down();
}

void move_next_letter(void) {
pen_up();
 draw_right(speed);
 draw_right(speed);
pen_down();
}

void enter_new_line(void) {
pen_up();
 for(times = 0; times<2*(LETTER_PER_LINE-1); times++) draw_left(speed);
 draw_down(speed);
 draw_down(speed);
pen_down();
}
