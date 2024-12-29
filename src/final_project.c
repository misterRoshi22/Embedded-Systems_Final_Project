unsigned int angle; // Count value of high - pertaining to the angle
unsigned char HL;   // High Low

void interrupt(void) {
    if (PIR1 & 0x04) { // CCP1 interrupt
        if (HL) { // High state
            CCPR1H = angle >> 8;
            CCPR1L = angle;
            HL = 0; // Switch to low state
            CCP1CON = 0x09; // Compare mode, clear output on match
            TMR1H = 0;
            TMR1L = 0;
        } else { // Low state
            CCPR1H = (40000 - angle) >> 8; // Calculate low state duration
            CCPR1L = (40000 - angle);
            CCP1CON = 0x08; // Compare mode, set output on match
            HL = 1; // Switch to high state
            TMR1H = 0;
            TMR1L = 0;
        }
        PIR1 &= 0xFB; // Clear CCP1 interrupt flag
    }
}

void main() {
    TRISC = 0x00; // PWM output at CCP1 (RC2)
    PORTC = 0x00;
    TRISB = 0x03; // Set RB0 and RB1 as inputs (other pins are outputs)
    PORTB = 0x00; // Clear PORTB

    TMR1H = 0;
    TMR1L = 0;

    HL = 1; // Start with high state
    CCP1CON = 0x08; // Compare mode, set output on match

    T1CON = 0x01; // Timer1 On Fosc/4 (inc 0.5µs) with no prescaler

    INTCON = 0xC0; // Enable global and peripheral interrupts
    PIE1 |= 0x04; // Enable CCP1 interrupts

    CCPR1H = 2000 >> 8; // Initial compare value for high state
    CCPR1L = 2000;

    while (1) {
        if (PORTB & 0x01) { // Check if RB0 is pressed
            angle = 2500; // Set angle for 90° (1.25ms pulse width)
        } else if (PORTB & 0x02) { // Check if RB1 is pressed
            angle = 1000; // Set angle for 0° (0.5ms pulse width)
        }
    }
}
