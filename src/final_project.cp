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
#line 72 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/final_project.c"
void move_next_letter(void);
void enter_new_line(void);


void interrupt(void) {

 if (INTCON & 0x04) {
 PORTC ^= 0x02;
 PORTC ^= 0x08;
 INTCON &= ~0x04;
 TMR0 = 0xF0;
 }
#line 90 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/final_project.c"
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
 size = 50 + ((size * (150 - 50)) / 242);




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
#line 192 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/final_project.c"
 letter = 0x00;
 move_next_letter();

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
#line 549 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/final_project.c"
void draw_space(void) {
 pen_up();
 draw_right(size);
 draw_right(size);
 draw_right(size);
 draw_right(size);
 pen_down();
}

void move_next_letter(void) {
pen_up();
 draw_right(size);
 draw_right(size);
pen_down();
}

void enter_new_line(void) {
pen_up();
 for(times = 0; times<2*(letters_per_line-1); times++) draw_left(size);
 draw_down(size);
 draw_down(size);
pen_down();
}
