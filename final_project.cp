#line 1 "C:/Users/20210383/Desktop/project/final_project.c"

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

unsigned char char_count = 0;
unsigned char letter = 0x00;

char braille_map[64] = {
 ' ', 'a', 'b', 'k', 'l', 'c', 'i', 'f',
 'e', 'h', 'd', 'j', 'm', 'n', 'o', 'p',
 'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
 'i', 'z', 's', '2', 'j', 'w', 't', '6',
 'a', '8', 'k', 'u', 'e', ',', 'o', 'z',
 'b', ';', 'l', 'v', 'h', '#', 'r', '*',
 'c', ' ', 'm', 'x', 'd', ' ', 'n', 'y',
 'f', ' ', 'p', ' ', 'g', ' ', 'q', ' ',
};

void main() {

 TRISC = 0xFF;
 TRISB = 0x00;
 TRISD = 0xFF;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);


 while (1) {
 if (char_count > 31) {
 Lcd_Cmd(_LCD_CLEAR);
 char_count = 0;
 }

 if ((PORTD & 0x40) == 0x40) {
 if (char_count == 16) {
 Lcd_Cmd(_LCD_SECOND_ROW);
 }

 Lcd_Chr_Cp(braille_map[letter]);
 char_count++;



 letter = 0x00;
 while ((PORTD & 0x40) == 0x40);
 }


 if ((PORTC & 0x01) == 0x01) letter |= 0x01;
 if ((PORTC & 0x02) == 0x02) letter |= 0x02;
 if ((PORTC & 0x04) == 0x04) letter |= 0x04;
 if ((PORTC & 0x08) == 0x08) letter |= 0x08;
 if ((PORTC & 0x10) == 0x10) letter |= 0x10;
 if ((PORTC & 0x20) == 0x20) letter |= 0x20;

 }
}
