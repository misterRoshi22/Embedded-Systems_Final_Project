// LCD module connections
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

unsigned int angle;                                                  // Count value of high - pertaining to the angle
unsigned char HL;                                                    // High Low


void interrupt(void){

       if(PIR1 & 0x04){                                           // CCP1 interrupt
             if(HL){                                // high
                       CCPR1H = angle >> 8;
                       CCPR1L = angle;
                       HL = 0;                      // next time low
                       CCP1CON = 0x09;              // compare mode, clear output on match
                       TMR1H = 0;
                       TMR1L = 0;
             }
             else{                                          //low
                       CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
                       CCPR1L = (40000 - angle);
                       CCP1CON = 0x08;             // compare mode, set output on match
                       HL = 1;                     //next time High
                       TMR1H = 0;
                       TMR1L = 0;
             }

             PIR1 = PIR1&0xFB;
       }


 }
char print_angle[7];

void main() {
        TRISC = 0x00;           // PWM output at CCP1(RC2)
        PORTC = 0x00;
        TRISD = 0x00;           // for 7 seg display
        PORTD = 0x00;
        ATD_init();
        PORTA = 0x08;          // Enable 4th seven segment display
        TMR1H = 0;
        TMR1L = 0;

        HL = 1;                // start high
        CCP1CON = 0x08;        // Compare mode, set output on match

        T1CON = 0x01;          // TMR1 On Fosc/4 (inc 0.5uS) with 0 prescaler (TMR1 overflow after 0xFFFF counts == 65535)==> 32.767ms

        INTCON = 0xC0;         // Enable GIE and peripheral interrupts
        PIE1 = PIE1|0x04;      // Enable CCP1 interrupts
        CCPR1H = 2000>>8;      // Value preset in a program to compare the TMR1H value to            - 1ms
        CCPR1L = 2000;         // Value preset in a program to compare the TMR1L value to

        Lcd_Init();               // Initialize LCD
        Lcd_Cmd(_LCD_CLEAR);      // Clear display
        Lcd_Cmd(_LCD_CURSOR_OFF);


        while(1){
              k = ATD_read();  // 0-1023
              myscaledVoltage = ((k*5)/1023); // 0-5
              PORTD = mysevenseg[myscaledVoltage];

              k = k>>2;  // divided by 4 ==> 0-255
              //angle = 0.5ms -> 1000 counts; 1.75ms -> 3500 counts
              angle = 1000 + ((k*25)/2.55);     //angle= 1000 + ((k*2500)/255); 1000count=500uS to 3500count =1750us
              if(angle>3500) angle = 3500;      // 1.75ms
              if(angle<1000) angle = 1000;      // 0.5ms
              IntToStr(angle, print_angle);
              Lcd_Out(1,1,"angle: ");
              Lcd_Out(1, 8, print_angle);
        }

}


void ATD_init(void){
      ADCON0=0x41;           // ON, Channel 0, Fosc/16== 500KHz, Dont Go
      ADCON1=0xCE;           // RA0 Analog, others are Digital, Right Allignment,
      TRISA=0x01;
}
unsigned int ATD_read(void){
      ADCON0=ADCON0 | 0x04;  // GO
      while(ADCON0&0x04);    // wait until DONE
      return (ADRESH<<8)|ADRESL;
}