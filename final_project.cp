#line 1 "C:/Users/20210383/Desktop/project/final_project.c"
unsigned char mysevenseg[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F};
unsigned char tick;
void ATD_init(void);
unsigned int ATD_read(void);
unsigned int myreading;
unsigned int myVoltage;

interrupt() {
 tick++;
 if (tick == 16) {
 tick = 0;
 myreading = ATD_read();
 PORTB = myreading;
 PORTC = myreading >> 8;
 myVoltage = (unsigned int)(myreading * 50) / 1023;
 }
 INTCON = INTCON & 0xFB;
}

void main() {

 TRISB = 0x00;
 TRISC = 0x00;
 TRISD = 0x00;


 ATD_init();


 OPTION_REG = 0x07;
 INTCON = 0xA0;
 TMR0 = 0;


 while (1) {
 delay_ms(5);
 PORTA = 0x04;
 PORTD = mysevenseg[myVoltage % 10];
 delay_ms(5);
 PORTA = 0x08;
 PORTD = (mysevenseg[myVoltage / 10]) | 0x80;
 }
}

void ATD_init(void) {
 ADCON0 = 0x41;
 ADCON1 = 0xCE;
 TRISA = 0x01;
}

unsigned int ATD_read(void) {
 ADCON0 = ADCON0 | 0x04;
 while (ADCON0 & 0x04);
 return ((ADRESH << 8) | ADRESL);
}
