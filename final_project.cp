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

void ATD_init(void);
void CCPPWM_init(void);
unsigned int ATD_read(void);
void motor1(unsigned char);
void motor2(unsigned char);

unsigned char myspeed;
char print_out[6];

void IntToStr(unsigned char num, char *str) {
 char temp[6];
 int i = 0, j, length;


 if (num == 0) {
 str[0] = '0';
 str[1] = '\0';
 return;
 }


 while (num > 0) {
 temp[i++] = (num % 10) + '0';
 num /= 10;
 }
 temp[i] = '\0';


 length = i;
 for (j = 0; j < length; j++) {
 str[j] = temp[length - j - 1];
 }
 str[length] = '\0';
}


void main() {
 unsigned int k;
 unsigned char myscaledVoltage;
 TRISB = 0x00;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);




 ATD_init();
 TRISC = 0x60;

 CCPPWM_init();

 PORTC &= 0xE7;

 while (1) {
 if ((PORTC & 0x20)) {
 PORTC |= 0x18;
 }
 if ((PORTC & 0x40)) {
 PORTC &= 0xE7;
 }

 k = ATD_read();
 myscaledVoltage = ((k * 5) / 1023);
 IntToStr(myscaledVoltage, print_out);
 Lcd_Out(1, 1, print_out);
 IntToStr(k, print_out);
 Lcd_Out(2, 1, print_out);


 myspeed = (((k >> 2) * 250) / 255);
 IntToStr(myspeed, print_out);
 Lcd_Out(2, 9, print_out);

 motor1(myspeed);
 motor2(125);
 }
}

void ATD_init(void) {
 ADCON0 = 0x41;
 ADCON1 = 0xCE;
 TRISA = 0x01;
}

unsigned int ATD_read(void) {
 ADCON0 |= 0x04;
 while (ADCON0 & 0x04);
 return (ADRESH << 8) | ADRESL;
}

void CCPPWM_init(void) {
 T2CON = 0x07;
 CCP1CON = 0x0C;
 CCP2CON = 0x0C;
 PR2 = 250;
 TRISC = 0x60;
 CCPR1L = 125;
 CCPR2L = 125;
}

void motor1(unsigned char speed) {
 CCPR1L = speed;
}

void motor2(unsigned char speed) {
 CCPR2L = speed;
}
