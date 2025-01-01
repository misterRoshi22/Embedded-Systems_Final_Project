#include "../include/atd.h"
#include "../include/lcd_config.h"

// Variables
unsigned int analog_value;
unsigned char timer_value;
char print_string[7];
unsigned int i, j;
unsigned char c_i, c_j;
char print_i[7], print_j[7];
unsigned char update_lcd = 0;


// Function to initialize Timer0
void Timer0_init(void) {
    OPTION_REG = 0x05;  // Prescaler 1:64, Timer mode, internal clock (Fosc/4)
    TMR0 = 0;           // Clear Timer0
    INTCON &= ~0x04;    // Clear Timer0 overflow flag (T0IF)
    INTCON |= 0x20;     // Enable Timer0 interrupt (T0IE)
}

// Function to initialize Timer1
void Timer1_init(void) {
    T1CON = 0x31;       // Timer1 enabled, Prescaler 1:8, internal clock (Fosc/4)
    TMR1H = 0xF8;          // Clear Timer1 high byte
    TMR1L = 0x00;          // Clear Timer1 low byte
    PIR1 &= ~0x01;      // Clear Timer1 overflow flag (TMR1IF)
    PIE1 |= 0x01;       // Enable Timer1 interrupt (TMR1IE)
}

void interrupt(void) {
    // Handle Timer0 interrupt
    if (INTCON & 0x04) {       // Check if T0IF is set
        PORTC ^= 0x04;         // Toggle RC2 (Example action for Timer0)
        INTCON &= ~0x04;       // Clear T0IF
        TMR0 = 0;              // Reload Timer0 if necessary
        i++;
    }
    if(i == 100) {
        update_lcd = 1;  // Set flag for LCD update
        c_i++;
        i = 0;
    }

    // Handle Timer1 interrupt
    if (PIR1 & 0x01) {         // Check if TMR1IF is set
        PORTC ^= 0x08;         // Toggle RC3 (Example action for Timer1)
        PIR1 &= ~0x01;         // Clear TMR1IF
        TMR1H = 0xF8;             // Reload Timer1 high byte if necessary
        TMR1L = 0;             // Reload Timer1 low byte if necessary
        j++;
    }
    if(j == 100) {
        update_lcd = 1;  // Set flag for LCD update
        c_j++;
        j = 0;
    }
}


// Main Function
void main(void) {
    // Initialize I/O
    TRISC = 0x00;  // Set all PORTC pins as output
    PORTC = 0x00;  // Clear PORTC

    // Initialize Timers
    Timer0_init();  // Initialize Timer0
    Timer1_init();  // Initialize Timer1

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

    }
}
