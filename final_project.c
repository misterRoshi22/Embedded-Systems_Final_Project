unsigned char mysevenseg[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F};
unsigned char tick;
void ATD_init(void);
unsigned int ATD_read(void);
unsigned int myreading;
unsigned int myVoltage;

interrupt() { // TMR0 overflow interrupt occurs every 32ms
    tick++; // Increment tick every 32ms
    if (tick == 16) { // This condition is true approximately every 500ms
        tick = 0;
        myreading = ATD_read();
        PORTB = myreading;         // Display on PORTB the lower 8 bits of myreading
        PORTC = myreading >> 8;    // Display on PORTC the higher 8 bits by shifting 8 positions
        myVoltage = (unsigned int)(myreading * 50) / 1023;
    }
    INTCON = INTCON & 0xFB; // Clear the interrupt flag
}

void main() {
    // Set data direction registers
    TRISB = 0x00;
    TRISC = 0x00;
    TRISD = 0x00;

    // Initialize Analog-to-Digital conversion
    ATD_init();

    // Timer and interrupt configuration
    OPTION_REG = 0x07; // Oscillator clock / 4, prescale of 256
    INTCON = 0xA0;     // Enable global interrupt and TMR0 overflow interrupt
    TMR0 = 0;

    // Main loop
    while (1) {
        delay_ms(5);
        PORTA = 0x04;
        PORTD = mysevenseg[myVoltage % 10]; // Display first digit
        delay_ms(5);
        PORTA = 0x08;
        PORTD = (mysevenseg[myVoltage / 10]) | 0x80; // Display second digit
    }
}

void ATD_init(void) {
    ADCON0 = 0x41; // ATD ON, Don't GO, Channel 0, Fosc/16
    ADCON1 = 0xCE; // All channels are digital except RA0/AN0 is analog, 500 kHz, right justified
    TRISA = 0x01;  // Set RA0/AN0 as input
}

unsigned int ATD_read(void) {
    ADCON0 = ADCON0 | 0x04; // Start conversion (GO bit set)
    while (ADCON0 & 0x04);  // Wait for conversion to complete
    return ((ADRESH << 8) | ADRESL); // Combine high and low bits of the result
}
