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

// Variables
unsigned int analog_value;
unsigned char timer_value;
char print_string[7];

// Function to initialize ADC
void ATD_init(void) {
    ADCON0 = 0x41;   // ADC enabled, Fosc/16, Channel 0 (AN0)
    ADCON1 = 0xCE;   // All pins digital except AN0, right justified
    TRISA  = 0x01;   // Configure RA0/AN0 as input
}

// Function to read analog value from AN0
unsigned int ATD_read(void) {
    ADCON0 |= 0x04;         // Start ADC conversion
    while (ADCON0 & 0x04);  // Wait for conversion to complete
    return ((ADRESH << 8) | ADRESL);  // Return 10-bit result (0..1023)
}

// Interrupt Service Routine
void interrupt() {
    // Check if Timer0 overflow flag (T0IF) is set
    if (INTCON & 0x04) {
        // Toggle RC2 (your "step" pin)
        PORTC ^= 0x04;    // Bit-2 of PORTC

        // Clear Timer0 interrupt flag (T0IF)
        INTCON &= ~0x04;

        // IMPORTANT: Reload Timer0 here to ensure a consistent overflow period
        //            based on the value we wrote from the main loop
        TMR0 = timer_value;
    }
}

void main() {
    // Initialize I/O
    TRISC = 0x00;        // All PORTC pins as output
    PORTC = 0x00;        // Initialize PORTC to 0

    // ADC and LCD setup
    ATD_init();          // Initialize ADC
    Lcd_Init();          // Initialize LCD
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);

    // Configure Timer0
    // Prescaler 1:64, Timer mode, internal clock (Fosc/4)
    // => OPTION_REG = 0b00000101 = 0x05
    OPTION_REG = 0x05;

    // Clear Timer0 register & flag
    TMR0   = 0;
    INTCON &= ~0x04;     // Clear T0IF

    // Enable Timer0 interrupt and global interrupts
    INTCON |= 0x20;      // T0IE
    INTCON |= 0x80;      // GIE

    while (1) {
        // Read analog value from AN0: 0..1023
        analog_value = ATD_read();

        // Map the 10-bit ADC value (0..1023) to something in 0..255
        // so we can use it as a Timer0 reload value.
        // A large timer_value => TMR0 only counts a few steps to 255 => faster overflow => faster toggles.
        timer_value = (analog_value >> 2);  // simple approach: 0..1023 => 0..255

        // Convert timer_value to string for LCD
        IntToStr(timer_value, print_string);

        Lcd_Out(1, 1, "Timer Reload:");
        Lcd_Out(2, 1, print_string);

        Delay_ms(500);   // Slow refresh to observe changes on LCD
    }
}
