#include "../include/timer_init.h"

void Timer0_Init(void) {
    OPTION_REG = 0x05;
    TMR0 = 0xF0;             // initial load
    INTCON &= ~0x04;         // clear Timer0 overflow flag (T0IF)
    INTCON |= 0x20;          // enable Timer0 interrupt (T0IE)
}

void Timer2_Init(void) {
    T2CON = 0x06;   // Timer2 on, prescaler=1:16, postscaler=1:1
    PR2 = 63;      // PR2 = 63 for ~512 �s overflow at 8 MHz
    PIR1 &= ~0x02;   // TMR2IF = 0
    PIE1 |= 0x02;    // TMR2IE = 1

}

void Timer1_Init(void) {
        TMR1H = 0;
        TMR1L = 0;
        CCP1CON = 0x08;        // Compare mode, set output on match

        T1CON = 0x01;          // TMR1 On Fosc/4 (inc 0.5uS) with 0 prescaler (TMR1 overflow after 0xFFFF counts == 65535)==> 32.767ms
        PIE1 = PIE1|0x04;      // Enable CCP1 interrupts
        CCPR1H = 2000>>8;      // Value preset in a program to compare the TMR1H value to            - 1ms
        CCPR1L = 2000;         // Value preset in a program to compare the TMR1L value to
}