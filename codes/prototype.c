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

// Stepper motor connections
sbit STEP1 at RC0_bit;
sbit DIR1 at RC4_bit;
sbit STEP2 at RC1_bit;
sbit DIR2 at RC5_bit;

sbit STEP1_Direction at TRISC0_bit;
sbit DIR1_Direction at TRISC4_bit;
sbit STEP2_Direction at TRISC1_bit;
sbit DIR2_Direction at TRISC5_bit;

unsigned char char_count = 0; // Variable to keep track of character count
unsigned char letter = 0x00;  // Variable to store Braille input

unsigned int angle = 2000; // Initial servo position (1ms pulse width)
unsigned char HL;          // High/Low toggle

char braille_map[64] = {
    ' ', '!', '!', '!', '!', '!', '!', '1',  // 0x00 - 0x07
    '!', '!', '!', '!', '!', '!', '!', '1',  // 0x08 - 0x0F
    '!', '!', '!', '!', '!', '!', '!', '1',  // 0x10 - 0x17
    'i', '!', 's', '!', 'j', 'w', 't', '!',  // 0x18 - 0x1F
    'a', '!', 'k', 'u', 'e', '!', 'o', 'z',  // 0x20 - 0x27
    'b', '!', 'l', 'v', 'h', '!', 'r', '!',  // 0x28 - 0x2F
    'c', '!', 'm', 'x', 'd', '!', 'n', 'y',  // 0x30 - 0x37
    'f', '!', 'p', '!', 'g', '!', 'q', '!',  // 0x38 - 0x3F
};

// Interrupt Service Routine for servo control
void interrupt() {
    if (PIR1 & 0x04) { // CCP1 interrupt
        if (HL) { // High
            CCPR1H = angle >> 8;
            CCPR1L = angle;
            HL = 0; // Next time low
            CCP1CON = 0x09; // Compare mode, clear output on match
            TMR1H = 0;
            TMR1L = 0;
        } else { // Low
            CCPR1H = (40000 - angle) >> 8; // 40000 counts correspond to 20ms
            CCPR1L = (40000 - angle);
            CCP1CON = 0x08; // Compare mode, set output on match
            HL = 1; // Next time high
            TMR1H = 0;
            TMR1L = 0;
        }
        PIR1 &= 0xFB; // Clear interrupt flag
    }
}

// Function to move servo motor
void servo_move(unsigned int new_angle) {
    if (new_angle > 3500) new_angle = 3500; // Limit to max 1.75ms
    if (new_angle < 1000) new_angle = 1000; // Limit to min 0.5ms
    angle = new_angle;                      // Update servo position
}
  unsigned int i;
// Function to control stepper motors
void step_motor(unsigned char step_pin, unsigned char dir_pin, unsigned int steps, unsigned char direction) {
    if (direction) {
        dir_pin = 1; // Set direction to forward
    } else {
        dir_pin = 0; // Set direction to backward
    }

    for (i = 0; i < steps; i++) {
        step_pin = 1; // Generate step pulse
        delay_ms(1);  // Short delay for pulse width
        step_pin = 0; // Reset step signal
        delay_ms(1);  // Short delay between pulses
    }
}


// Movement pattern for letter 'A'
void draw_A() {
    step_motor(STEP1, DIR1, 100, 0); // Motor 1 forward
    step_motor(STEP2, DIR2, 50, 1);  // Motor 2 backward
    step_motor(STEP1, DIR1, 100, 1); // Motor 1 backward
    step_motor(STEP2, DIR2, 50, 0);  // Motor 2 forward
}

// Movement pattern for letter 'B'
void draw_B() {
    step_motor(STEP1, DIR1, 50, 0);  // Motor 1 forward
    step_motor(STEP2, DIR2, 100, 1); // Motor 2 backward
    step_motor(STEP1, DIR1, 50, 1);  // Motor 1 backward
    step_motor(STEP2, DIR2, 100, 0); // Motor 2 forward
}

void main() {
    TRISC = 0x00; // PWM output at CCP1 (RC2) and motor control
    PORTC = 0x00;
    TRISD = 0xFF; // Set PORTD as input
    TRISB = 0x00; // Set PORTB as output (for LCD)
    PORTB = 0x00;

    Lcd_Init();              // Initialize LCD
    Lcd_Cmd(_LCD_CLEAR);     // Clear display

    HL = 1;                  // Start high
    CCP1CON = 0x08;          // Compare mode, set output on match
    T1CON = 0x01;            // Timer1 ON, Fosc/4, no prescaler
    INTCON = 0xC0;           // Enable global and peripheral interrupts
    PIE1 |= 0x04;            // Enable CCP1 interrupts
    CCPR1H = angle >> 8;     // Initialize CCP1 compare value (high byte)
    CCPR1L = angle;          // Initialize CCP1 compare value (low byte)

    while (1) {
        if (char_count > 31) { // Reset after filling both rows
            Lcd_Cmd(_LCD_CLEAR);
            char_count = 0;
        }

        // Check if "Enter" button on PORTD6 is pressed
        if ((PORTD & 0x40) == 0x40) { // Button pressed
            delay_ms(50);             // Debouncing delay
            if ((PORTD & 0x40) == 0x40) { // Confirm the button is still pressed
                if (char_count == 16) {
                    Lcd_Cmd(_LCD_SECOND_ROW); // Move cursor to second row
                }

                //char current_char = braille_map[letter];
                Lcd_Chr_Cp(braille_map[letter]); // Display character on LCD
                char_count++;

                servo_move(1000); // Lower servo
                delay_ms(500);   // Wait for servo to move

                // Call the corresponding drawing function
                if (braille_map[letter] == 'a') {
                    draw_A();
                } else if (braille_map[letter] == 'b') {
                    draw_B();
                }

                servo_move(2000); // Raise servo back to original position
                delay_ms(500);   // Wait for servo to move

                letter = 0x00; // Reset the letter after printing

                // Wait for button release
                while ((PORTD & 0x40) == 0x40); // Wait for button to be released
                delay_ms(50);                   // Debouncing delay after release
            }
        }

        // Read button inputs and update the Braille `letter`
        if ((PORTD & 0x01) == 0x01) letter |= 0x01; // Set bit 0
        if ((PORTD & 0x02) == 0x02) letter |= 0x02; // Set bit 1
        if ((PORTD & 0x04) == 0x04) letter |= 0x04; // Set bit 2
        if ((PORTD & 0x08) == 0x08) letter |= 0x08; // Set bit 3
        if ((PORTD & 0x10) == 0x10) letter |= 0x10; // Set bit 4
        if ((PORTD & 0x20) == 0x20) letter |= 0x20; // Set bit 5
        if ((PORTD & 0x80) == 0x80) letter = 0x00;  // Clear all bits
    }
}
