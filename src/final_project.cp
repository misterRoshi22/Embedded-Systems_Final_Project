#line 1 "C:/Users/20210383/Desktop/project/src/final_project.c"

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


unsigned int analog_value;
unsigned char timer_value;
char print_string[7];


void ATD_init(void) {
 ADCON0 = 0x41;
 ADCON1 = 0xCE;
 TRISA = 0x01;
}


unsigned int ATD_read(void) {
 ADCON0 |= 0x04;
 while (ADCON0 & 0x04);
 return ((ADRESH << 8) | ADRESL);
}


void interrupt() {

 if (INTCON & 0x04) {

 PORTC ^= 0x04;


 INTCON &= ~0x04;



 TMR0 = timer_value;
 }
}

void main() {

 TRISC = 0x00;
 PORTC = 0x00;


 ATD_init();
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);




 OPTION_REG = 0x05;


 TMR0 = 0;
 INTCON &= ~0x04;


 INTCON |= 0x20;
 INTCON |= 0x80;

 while (1) {

 analog_value = ATD_read();




 timer_value = (analog_value >> 2);


 IntToStr(timer_value, print_string);

 Lcd_Out(1, 1, "Timer Reload:");
 Lcd_Out(2, 1, print_string);

 Delay_ms(500);
 }
}
