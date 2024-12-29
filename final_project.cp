#line 1 "C:/Users/karim/Desktop/embedded_project/Embedded-Systems_Final_Project/final_project.c"

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
 ' ', '!', '!', '!', '!', '!', '!', '1',
 '!', '!', '!', '!', '!', '!', '!', '1',
 '!', '!', '!', '!', '!', '!', '!', '1',
 'i', '!', 's', '!', 'j', 'w', 't', '!',
 'a', '!', 'k', 'u', 'e', '!', 'o', 'z',
 'b', '!', 'l', 'v', 'h', '!', 'r', '!',
 'c', '!', 'm', 'x', 'd', '!', 'n', 'y',
 'f', '!', 'p', '!', 'g', '!', 'q', '!',
};
void main() {

 TRISD = 0xFF;
 TRISB = 0x00;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);

 while (1) {
 if (char_count > 31) {
 Lcd_Cmd(_LCD_CLEAR);
 char_count = 0;
 }


 if ((PORTD & 0x40) == 0x40) {
 delay_ms(50);
 if ((PORTD & 0x40) == 0x40) {
 if (char_count == 16) {
 Lcd_Cmd(_LCD_SECOND_ROW);
 }

 Lcd_Chr_Cp(braille_map[letter]);
 char_count++;

 letter = 0x00;


 while ((PORTD & 0x40) == 0x40);
 delay_ms(50);
 }
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
