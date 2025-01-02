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
#line 1 "c:/users/20210383/desktop/project/src/../include/draw_letters.h"



void draw_e(void);
void draw_a(void);
void draw_i(void);
void draw_h(void);
void draw_l(void);
void move_next_letter(void);
void enter_new_line(void);
#line 1 "c:/users/20210383/desktop/project/src/../include/draw_base.h"




void draw_right(void);
void draw_left(void);
void draw_down(void);
void draw_up(void);
void draw_down_right(void);
void draw_up_left(void);

void move_right();
void move_left();
void move_up();
void move_down();
#line 7 "C:/Users/20210383/Desktop/project/src/final_project.c"
unsigned int analog_value;
unsigned char timer_value;
char print_string[7];
unsigned int i, j;
unsigned char c_i, c_j;
char print_i[7], print_j[7];
unsigned char update_lcd = 0;
unsigned int angle;
unsigned char HL;
unsigned char MOTOR1_SPEED;






void Timer0_init(void) {

 OPTION_REG = 0x05;
 TMR0 = 0xF0;
 INTCON &= ~0x04;
 INTCON |= 0x20;
}


void Timer2_init(void) {
#line 45 "C:/Users/20210383/Desktop/project/src/final_project.c"
 T2CON = 0x06;


 PR2 = 63;


 PIR1 &= ~0x02;
 PIE1 |= 0x02;
}
int step;
int sub;
void draw_circle() {

 angle = 1200;
 Delay_ms(200);



 for (step = 0; step < 36; step++) {


 if (step < 18) {
 MOTOR1_SPEED = 0xE0;
 } else {
 MOTOR1_SPEED = 0xF0;
 }



 for (sub = 0; sub < 5; sub++) {
 draw_right();
 draw_up();
 }



 }


 angle = 900;
 Delay_ms(200);
}


void interrupt(void) {

 if (INTCON & 0x04) {
 PORTC ^= 0x04;
 INTCON &= ~0x04;
 TMR0 = MOTOR1_SPEED;
 i++;
 }
 if (i == 100) {
 update_lcd = 1;
 c_i++;
 i = 0;
 }


 if (PIR1 & 0x02) {
 PORTC ^= 0x08;
 PIR1 &= ~0x02;
 j++;
 }
 if (j == 100) {
 update_lcd = 1;
 c_j++;
 j = 0;
 }
 if (PIR2 & 0x01) {
 if (HL) {
 CCPR2H = angle >> 8;
 CCPR2L = angle;
 HL = 0;
 CCP2CON = 0x09;
 TMR1H = 0;
 TMR1L = 0;
 } else {
 CCPR2H = (40000 - angle) >> 8;
 CCPR2L = (40000 - angle);
 CCP2CON = 0x08;
 HL = 1;
 TMR1H = 0;
 TMR1L = 0;
 }

 PIR2 &= ~0x01;
 }
}

void main() {


 TRISC = 0x00;
 PORTC = 0xC0;
 ATD_init();


 PORTD = 0xFF;


 Timer0_init();
 Timer2_init();

 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Hello!!");


 INTCON |= 0x80;
 INTCON |= 0x40;
 i = 0;
 j = 0;
 c_i = 0;
 c_j = 0;

 TMR1H = 0;
 TMR1L = 0;

 HL = 1;
 CCP2CON = 0x08;

 T1CON = 0x01;

 INTCON = 0xC0;
 PIE2 |= 0x01;
 CCPR2H = 2000 >> 8;
 CCPR2L = 2000;
 angle = 800;
 Delay_ms(100);
 draw_left();
 draw_up();
 draw_right();
 angle = 1200;
 Delay_ms(100);
 move_down();
 move_down();
 angle = 800;
 Delay_ms(100);
 draw_left();
 draw_up();
 angle = 1200;
 Delay_ms(100);
 move_right();



 while (1) {

 if (update_lcd) {
 update_lcd = 0;
 Lcd_Cmd(_LCD_CLEAR);
 IntToStr(c_i, print_i);
 IntToStr(c_j, print_j);
 Lcd_Out(1, 1, print_i);
 Lcd_Out(2, 1, print_j);

 }
#line 209 "C:/Users/20210383/Desktop/project/src/final_project.c"
 if(PORTD & 0x10) draw_e();
 if(PORTD & 0x20) draw_a();


 if (PORTD & 0x01) {
 angle = 1000;
 } else if (PORTD & 0x02) {
 angle = 1300;
 }





 }

}
