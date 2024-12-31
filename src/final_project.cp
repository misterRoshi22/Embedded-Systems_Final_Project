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

void ATD_init(void);
unsigned int ATD_read(void);
unsigned int k;
unsigned char myscaledVoltage;
unsigned char mysevenseg[10]={0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F};

unsigned int angle;
unsigned char HL;


void interrupt(void){

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
char print_angle[7];

void main() {
 TRISC = 0x00;
 PORTC = 0x00;
 TRISD = 0x00;
 PORTD = 0x00;
 ATD_init();
 PORTA = 0x08;
 TMR1H = 0;
 TMR1L = 0;

 HL = 1;
 CCP1CON = 0x08;

 T1CON = 0x01;

 INTCON = 0xC0;
 PIE1 = PIE1|0x04;
 CCPR1H = 2000>>8;
 CCPR1L = 2000;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);


 while(1){
 k = ATD_read();
 myscaledVoltage = ((k*5)/1023);
 PORTD = mysevenseg[myscaledVoltage];

 k = k>>2;

 angle = 1000 + ((k*25)/2.55);
 if(angle>3500) angle = 3500;
 if(angle<1000) angle = 1000;
 IntToStr(angle, print_angle);
 Lcd_Out(1,1,"angle: ");
 Lcd_Out(1, 8, print_angle);
 }

}


void ATD_init(void){
 ADCON0=0x41;
 ADCON1=0xCE;
 TRISA=0x01;
}
unsigned int ATD_read(void){
 ADCON0=ADCON0 | 0x04;
 while(ADCON0&0x04);
 return (ADRESH<<8)|ADRESL;
}
