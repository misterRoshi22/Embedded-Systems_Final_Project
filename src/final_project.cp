#line 1 "C:/Users/karim/Desktop/embedded_project/Embedded-Systems_Final_Project/final_project.c"
unsigned int angle;
unsigned char HL;

void interrupt(void) {
 if (PIR1 & 0x04) {
 if (HL) {
 CCPR1H = angle >> 8;
 CCPR1L = angle;
 HL = 0;
 CCP1CON = 0x09;
 TMR1H = 0;
 TMR1L = 0;
 } else {
 CCPR1H = (40000 - angle) >> 8;
 CCPR1L = (40000 - angle);
 CCP1CON = 0x08;
 HL = 1;
 TMR1H = 0;
 TMR1L = 0;
 }
 PIR1 &= 0xFB;
 }
}

void main() {
 TRISC = 0x00;
 PORTC = 0x00;
 TRISB = 0x03;
 PORTB = 0x00;

 TMR1H = 0;
 TMR1L = 0;

 HL = 1;
 CCP1CON = 0x08;

 T1CON = 0x01;

 INTCON = 0xC0;
 PIE1 |= 0x04;

 CCPR1H = 2000 >> 8;
 CCPR1L = 2000;

 while (1) {
 if (PORTB & 0x01) {
 angle = 2500;
 } else if (PORTB & 0x02) {
 angle = 1000;
 }
 }
}
