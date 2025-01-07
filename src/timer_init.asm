
_Timer0_Init:

;timer_init.c,3 :: 		void Timer0_Init(void) {
;timer_init.c,4 :: 		OPTION_REG = 0x05;
	MOVLW      5
	MOVWF      OPTION_REG+0
;timer_init.c,5 :: 		TMR0 = 0xF0;             // initial load
	MOVLW      240
	MOVWF      TMR0+0
;timer_init.c,6 :: 		INTCON &= ~0x04;         // clear Timer0 overflow flag (T0IF)
	BCF        INTCON+0, 2
;timer_init.c,7 :: 		INTCON |= 0x20;          // enable Timer0 interrupt (T0IE)
	BSF        INTCON+0, 5
;timer_init.c,8 :: 		}
L_end_Timer0_Init:
	RETURN
; end of _Timer0_Init

_Timer2_Init:

;timer_init.c,10 :: 		void Timer2_Init(void) {
;timer_init.c,11 :: 		T2CON = 0x06;   // Timer2 on, prescaler=1:16, postscaler=1:1
	MOVLW      6
	MOVWF      T2CON+0
;timer_init.c,12 :: 		PR2 = 63;      // PR2 = 63 for ~512 µs overflow at 8 MHz
	MOVLW      63
	MOVWF      PR2+0
;timer_init.c,13 :: 		PIR1 &= ~0x02;   // TMR2IF = 0
	BCF        PIR1+0, 1
;timer_init.c,14 :: 		PIE1 |= 0x02;    // TMR2IE = 1
	BSF        PIE1+0, 1
;timer_init.c,16 :: 		}
L_end_Timer2_Init:
	RETURN
; end of _Timer2_Init

_Timer1_Init:

;timer_init.c,18 :: 		void Timer1_Init(void) {
;timer_init.c,19 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;timer_init.c,20 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;timer_init.c,21 :: 		CCP1CON = 0x08;        // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;timer_init.c,23 :: 		T1CON = 0x01;          // TMR1 On Fosc/4 (inc 0.5uS) with 0 prescaler (TMR1 overflow after 0xFFFF counts == 65535)==> 32.767ms
	MOVLW      1
	MOVWF      T1CON+0
;timer_init.c,24 :: 		PIE1 = PIE1|0x04;      // Enable CCP1 interrupts
	BSF        PIE1+0, 2
;timer_init.c,25 :: 		CCPR1H = 2000>>8;      // Value preset in a program to compare the TMR1H value to            - 1ms
	MOVLW      7
	MOVWF      CCPR1H+0
;timer_init.c,26 :: 		CCPR1L = 2000;         // Value preset in a program to compare the TMR1L value to
	MOVLW      208
	MOVWF      CCPR1L+0
;timer_init.c,27 :: 		}
L_end_Timer1_Init:
	RETURN
; end of _Timer1_Init
