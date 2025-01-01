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
#line 6 "C:/Users/20210383/Desktop/project/src/final_project.c"
unsigned int analog_value;
unsigned char timer_value;
char print_string[7];
unsigned int i, j;
unsigned char c_i, c_j;
char print_i[7], print_j[7];
unsigned char update_lcd = 0;


void Timer0_init(void) {
 OPTION_REG = 0x05;
 TMR0 = 0xf0;
 INTCON &= ~0x04;
 INTCON |= 0x20;
}


void Timer1_init(void) {
 T1CON = 0x31;
 TMR1H = 0xFF;
 TMR1L = 0x80;
 PIR1 &= ~0x01;
 PIE1 |= 0x01;
}

void interrupt(void) {

 if (INTCON & 0x04) {
 PORTC ^= 0x04;
 INTCON &= ~0x04;
 TMR0 = 0xF0;
 i++;
 }
 if(i == 100) {
 update_lcd = 1;
 c_i++;
 i = 0;
 }


 if (PIR1 & 0x01) {
 PORTC ^= 0x08;
 PIR1 &= ~0x01;
 TMR1H = 0xFF;
 TMR1L = 0x80;
 j++;
 }
 if(j == 100) {
 update_lcd = 1;
 c_j++;
 j = 0;
 }

}


void main(void) {

 TRISC = 0x00;
 PORTC = 0xC0;
 ATD_init();


 PORTD = 0xFF;


 Timer0_init();
 Timer1_init();

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

 draw_h();
 move_next_letter();
 draw_e();
 move_next_letter();
 draw_l();
 move_next_letter();
 draw_l();
 enter_new_line();


 while (1) {

 if (update_lcd) {
 update_lcd = 0;
 Lcd_Cmd(_LCD_CLEAR);
 IntToStr(c_i, print_i);
 IntToStr(c_j, print_j);
 Lcd_Out(1, 1, print_i);
 Lcd_Out(2, 1, print_j);

 }
#line 119 "C:/Users/20210383/Desktop/project/src/final_project.c"
 }


}
