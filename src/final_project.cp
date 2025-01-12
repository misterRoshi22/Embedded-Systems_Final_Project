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
void update_current_letter_display(char current_letter);
void update_current_size_display(unsigned int input_size);
void ShiftCharsLeft(char *str);
#line 8 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/final_project.c"
const unsigned int SERVO_UP = 1800;
const unsigned int SERVO_DOWN = 1000;

char braille_map[64] = {
 ' ', '!', '!', '!', '!', '!', '!', '!',
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
unsigned char times;
unsigned char size;


unsigned char count_overflow = 0;
unsigned char speed_tester = 0;


char current_row = 1;
char current_column = 1;
char previous_letter = 0x00;
const char letters_per_line = 20;
#line 77 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/final_project.c"
void interrupt(void) {

 if (INTCON & 0x04) {
 PORTC ^= 0x02;
 PORTC ^= 0x08;
 INTCON &= ~0x04;
 TMR0 = 0xE8 + ((size - 50) * (0xF8 - 0xE8)) / (255 - 50);
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
#line 200 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/final_project.c"
 current_column++;
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
