#include "../include/atd.h"
#include "../include/lcd_config.h"
#include "../include/draw_letters.h"
#include "../include/draw_base.h"

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
unsigned char MOTOR1_SPEED;

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
int step;
int sub;
void draw_circle() {
    // 1) Put pen down or set servo to a certain angle (if needed)
    angle = 1200;  // For example, ~1.5 ms (90°) if that lowers the pen
    Delay_ms(200);

    // 2) Start drawing: approximate circle in small increments
    //    We’ll do 36 “steps” (like a 360° circle broken into 36 arcs of 10° each)
    for (step = 0; step < 36; step++) {
        // (A) Adjust speed if you want to accelerate or vary speed
        //     Example: motor goes faster in the first half, slower in second half
        if (step < 18) {
            MOTOR1_SPEED = 0xE0; // faster stepping
        } else {
            MOTOR1_SPEED = 0xF0; // slower stepping
        }

        // (B) Move a small arc: e.g., 5 steps in X, 5 steps in Y
        //     Each call might do 1 or more steps, so you might call them in a loop
        for (sub = 0; sub < 5; sub++) {
            draw_right(); // or a custom function that does 1 step to the right
            draw_up();    // 1 step up
        }

        // (C) Optional small delay or check
        // Delay_ms(10);
    }

    // 3) Lift pen or reset servo angle
    angle = 900;  // ~0.5 ms (0°), maybe lifts the pen
    Delay_ms(200);
}

// Interrupt Service Routine
void interrupt(void) {
    // Handle Timer0 interrupt
    if (INTCON & 0x04) {    // T0IF?
        PORTC ^= 0x04;      // Toggle RC2 (example action for Timer0)
        INTCON &= ~0x04;    // Clear T0IF
        TMR0 = MOTOR1_SPEED;        // Reload Timer0 if necessary
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
  angle = 800;  // 0° (0.5 ms pulse width)
                        Delay_ms(100);
            draw_left();
          draw_up();
          draw_right();
          angle = 1200;  // 90° (1.5 ms pulse width)
                 Delay_ms(100);
          move_down();
          move_down();
          angle = 800;  // 0° (0.5 ms pulse width)
                 Delay_ms(100);
          draw_left();
          draw_up();
          angle = 1200;  // 90° (1.5 ms pulse width)
                 Delay_ms(100);
          move_right();


    
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
        }
        




    }

}