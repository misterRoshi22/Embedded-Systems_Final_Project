#include "../include/atd.h"
#include "../include/lcd_config.h"
#include "../include/draw_letters.h"

// Variables
unsigned int analog_value;
unsigned char timer_value;
char print_string[7];
unsigned int i, j;
unsigned char c_i, c_j;
char print_i[7], print_j[7];
unsigned char update_lcd = 0;
unsigned int angle;  // Count value of high - pertaining to the angle
unsigned char HL;    // High Low

//const char SERVO_UP =  2500;
//const char SERVO_DOWN = 1000;


// Timer0 remains as is, no changes
void Timer0_init(void) {
    // Prescaler 1:64, Timer mode, internal clock (Fosc/4)
    OPTION_REG = 0x05;
    TMR0 = 0xF0;             // Initial load
    INTCON &= ~0x04;         // Clear Timer0 overflow flag (T0IF)
    INTCON |= 0x20;          // Enable Timer0 interrupt (T0IE)
}

// Replace Timer1_init() with Timer2_init()
void Timer2_init(void) {
    /*
      T2CON format (for many PIC devices):
        bit 7..6, 2..0: Postscaler
        bit 5..4: Prescaler
        bit 3:    Timer2 ON/OFF

      We want:
        - Timer2 ON
        - Prescaler = 1:16
        - Postscaler = 1:1
        => T2CON = 0b00000110 = 0x06
    */
    T2CON = 0x06;   // Timer2 on, prescaler=1:16, postscaler=1:1

    // PR2 = 63 for ~512 µs overflow at 8 MHz
    PR2 = 63;

    // Clear and enable Timer2 interrupt
    PIR1 &= ~0x02;   // TMR2IF = 0
    PIE1 |= 0x02;    // TMR2IE = 1
}

// Interrupt Service Routine
void interrupt(void) {
    // Handle Timer0 interrupt
    if (INTCON & 0x04) {    // T0IF?
        PORTC ^= 0x04;      // Toggle RC2 (example action for Timer0)
        INTCON &= ~0x04;    // Clear T0IF
        TMR0 = 0xF0;        // Reload Timer0 if necessary
        i++;
    }
    if (i == 100) {
        update_lcd = 1;  // Set flag for LCD update
        c_i++;
        i = 0;
    }

    // Handle Timer2 interrupt instead of Timer1
    if (PIR1 & 0x02) {      // TMR2IF?
        PORTC ^= 0x08;      // Toggle RC3 (example action for Timer2)
        PIR1 &= ~0x02;      // Clear TMR2IF

        // Timer2 automatically resets to 0 after matching PR2
        j++;
    }
    if (j == 100) {
        update_lcd = 1;  // Set flag for LCD update
        c_j++;
        j = 0;
    }
    if (PIR2 & 0x01) {  // CCP2 interrupt
        if (HL) {  // High
            CCPR2H = angle >> 8;
            CCPR2L = angle;
            HL = 0;  // Next time low
            CCP2CON = 0x09;  // Compare mode, clear output on match
            TMR1H = 0;
            TMR1L = 0;
        } else {  // Low
            CCPR2H = (40000 - angle) >> 8;  // 40000 counts correspond to 20ms
            CCPR2L = (40000 - angle);
            CCP2CON = 0x08;  // Compare mode, set output on match
            HL = 1;  // Next time high
            TMR1H = 0;
            TMR1L = 0;
        }

        PIR2 &= ~0x01;  // Clear CCP2 interrupt flag
    }
}

void main() {

  // Initialize I/O
    TRISC = 0x00;  // Set all PORTC pins as output
    PORTC = 0xC0;  // Clear PORTC, set enables to 0 active low
    ATD_init();

    //FOR TESTING PURPOSES ONLY
    PORTD = 0xFF;

    // Initialize Timers
    Timer0_init();  // Initialize Timer0
    Timer2_init();  // Initialize Timer1

    Lcd_Init();
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1,1,"Hello!!");

    // Enable global interrupts
    INTCON |= 0x80; // Global Interrupt Enable (GIE)
    INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)
    i = 0;
    j = 0;
    c_i = 0;
    c_j = 0;

    TMR1H = 0;
    TMR1L = 0;

    HL = 1;  // Start high
    CCP2CON = 0x08;  // Compare mode, set output on match

    T1CON = 0x01;  // TMR1 On Fosc/4 (increment 0.5µs) with 0 prescaler (TMR1 overflow after 0xFFFF counts == 32.767ms)

    INTCON = 0xC0;  // Enable GIE and peripheral interrupts
    PIE2 |= 0x01;   // Enable CCP2 interrupts
    CCPR2H = 2000 >> 8;  // Value preset in a program to compare the TMR1H value to - 1ms
    CCPR2L = 2000;       // Value preset in a program to compare the TMR1L value to


    while (1) {
        // Check if LCD update is required
        if (update_lcd) {
            update_lcd = 0;  // Clear the flag
            Lcd_Cmd(_LCD_CLEAR);          // Clear LCD
            IntToStr(c_i, print_i);       // Convert values to strings
            IntToStr(c_j, print_j);
            Lcd_Out(1, 1, print_i);       // Display values
            Lcd_Out(2, 1, print_j);

        }

/*if(PORTD & 0x01) draw_right();
          if(PORTD & 0x02) draw_left_x();
          if(PORTD & 0x04) draw_down_y();
          if(PORTD & 0x08) draw_up_y();*/
          if(PORTD & 0x10) draw_e();
          if(PORTD & 0x20) draw_a();

        // Check RD0, RD1, RD2 to set angle
        if (PORTD & 0x01) {  // RD0 pressed
            angle = 1000;  // 0° (0.5 ms pulse width)
        } else if (PORTD & 0x02) {  // RD1 pressed
            angle = 1300;  // 90° (1.5 ms pulse width)
        } else if (PORTD & 0x04) {  // RD2 pressed
            angle = 3500;  // 180° (2 ms pulse width)
        }



    }

}