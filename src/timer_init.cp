#line 1 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/timer_init.c"
#line 1 "c:/users/shaba/onedrive/desktop/uni/embedded systems/embedded-systems_final_project/src/../include/timer_init.h"



void Timer0_Init(void);
void Timer2_Init(void);
void Timer1_Init(void);
#line 3 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/timer_init.c"
void Timer0_Init(void) {
 OPTION_REG = 0x05;
 TMR0 = 0xF0;
 INTCON &= ~0x04;
 INTCON |= 0x20;
}

void Timer2_Init(void) {
 T2CON = 0x06;
 PR2 = 63;
 PIR1 &= ~0x02;
 PIE1 |= 0x02;

}

void Timer1_Init(void) {
 TMR1H = 0;
 TMR1L = 0;
 CCP1CON = 0x08;

 T1CON = 0x01;
 PIE1 = PIE1|0x04;
 CCPR1H = 2000>>8;
 CCPR1L = 2000;
}
