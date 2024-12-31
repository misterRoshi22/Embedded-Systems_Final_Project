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


unsigned int analog_value;
unsigned char timer_value;
unsigned int overflow_count = 0;  // Counter for overflows
unsigned int direction_delay = 1000; // Set this based on your Timer0 configuration
unsigned char direction = 0;  // 0 = one direction, 1 = opposite direction
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
        PORTC ^= 0x04;    // Bit-2 of PORTC (Step Pin)

        // Increment the overflow count
        overflow_count++;

        // Check if enough overflows have occurred to toggle direction
        if (overflow_count >= direction_delay) {
            direction = !direction;    // Toggle direction
            overflow_count = 0;        // Reset overflow counter
        }

        // Clear Timer0 interrupt flag (T0IF)
        INTCON &= ~0x04;

        // Reload Timer0 with timer_value
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
    OPTION_REG = 0x05;  // Prescaler 1:64, Timer mode, internal clock (Fosc/4)

    // Clear Timer0 register & flag
    TMR0 = 0;
    INTCON &= ~0x04;     // Clear T0IF

    // Enable Timer0 interrupt and global interrupts
    INTCON |= 0x20;      // T0IE
    INTCON |= 0x80;      // GIE

    while (1) {
        // Read analog value from AN0: 0..1023
        analog_value = ATD_read();

        // Map the 10-bit ADC value (0..1023) to something in 0..255
        timer_value = (analog_value >> 2);  // 0..1023 => 0..255

        // Convert timer_value to string for LCD
        IntToStr(timer_value, print_string);

        // Update the direction pin (RC4) based on the current direction
        if (direction) {
            PORTC |= 0x10;  // Set RC4 HIGH for one direction
        } else {
            PORTC &= 0xEF;  // Set RC4 LOW for the other direction
        }

        Lcd_Out(1, 1, "Timer Reload:");
        Lcd_Out(2, 1, print_string);

        // Delay for better LCD readability (optional)
        Delay_ms(500);
    }
}
