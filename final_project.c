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
void CCPPWM_init(void);
unsigned int ATD_read(void);
void motor1(unsigned char);
void motor2(unsigned char);

unsigned char myspeed;
char print_out[6]; // Enough space for "XXXXX\0";

void IntToStr(unsigned char num, char *str) {
    char temp[6];  // Temporary array to store the reversed string
    int i = 0, j, length;

    // Handle 0 explicitly
    if (num == 0) {
        str[0] = '0';
        str[1] = '\0';
        return;
    }

    // Convert digits to characters in reverse order
    while (num > 0) {
        temp[i++] = (num % 10) + '0';
        num /= 10;
    }
    temp[i] = '\0';

    // Reverse the string to get the correct order
    length = i;
    for (j = 0; j < length; j++) {
        str[j] = temp[length - j - 1];
    }
    str[length] = '\0';  // Null-terminate the string
}


void main() {
    unsigned int k;                        // ADC reading
    unsigned char myscaledVoltage;         // Voltage scaled to 0-5
    TRISB = 0x00; // Set PORTB as output (for LCD)
    Lcd_Init();               // Initialize LCD
    Lcd_Cmd(_LCD_CLEAR);      // Clear display
    Lcd_Cmd(_LCD_CURSOR_OFF);
    
    // c1, c2, c3, c4 are outputs, c5, c6 are inputs (c1,c2)-> step, (c3, c4)-> direction (c5, c6)->push buttos
  
    
    ATD_init();                 // Initialize ADC module
    TRISC = 0x60;  
   
    CCPPWM_init();              // Initialize CCP1 and CCP2 for PWM
    
    PORTC &= 0xE7;               // initialize direction pins to CW
     //Lcd_Out(1,1,"hello");
    while (1) {
        if ((PORTC & 0x20)) { //c5 pressed 
            PORTC |= 0x18;  // Motors CCW
        }
        if ((PORTC & 0x40)) {  //c6 pressed
            PORTC &= 0xE7;  // Motors CW
        }

        k = ATD_read();                     // ADC reading: 0-1023
        myscaledVoltage = ((k * 5) / 1023); // Scale to 0-5
        IntToStr(myscaledVoltage, print_out);
        Lcd_Out(1, 1, print_out);
        IntToStr(k, print_out);
        Lcd_Out(2, 1, print_out);        
        

        myspeed = (((k >> 2) * 250) / 255); // Scale to 0-250
        IntToStr(myspeed, print_out);
        Lcd_Out(2, 9, print_out); 

        motor1(myspeed);                    // Control step pin for Motor 1
        motor2(125);                        // Constant speed for Motor 2                                    
    }
}

void ATD_init(void) {
    ADCON0 = 0x41; // Turn on ADC, select channel 0 (AN0)
    ADCON1 = 0xCE; // Configure RA0 as analog input
    TRISA = 0x01;  // Set RA0 as input
}

unsigned int ATD_read(void) {
    ADCON0 |= 0x04;             // Start ADC conversion
    while (ADCON0 & 0x04);      // Wait until conversion is complete
    return (ADRESH << 8) | ADRESL; // Combine ADRESH and ADRESL
}

void CCPPWM_init(void) {
    T2CON = 0x07;               // Enable Timer2 with prescaler 1:16
    CCP1CON = 0x0C;             // Configure CCP1 in PWM mode
    CCP2CON = 0x0C;             // Configure CCP2 in PWM mode
    PR2 = 250;                  // Set Timer2 period for 2ms PWM
    TRISC = 0x60;               // Set RC1 and RC2 as outputs
    CCPR1L = 125;               // Initialize CCP1 duty cycle
    CCPR2L = 125;               // Initialize CCP2 duty cycle
}

void motor1(unsigned char speed) {
    CCPR1L = speed;             // Adjust PWM duty cycle for step pin
}

void motor2(unsigned char speed) {
    CCPR2L = speed;             // Adjust PWM duty cycle for step pin
}