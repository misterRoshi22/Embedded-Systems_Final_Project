
_Timer0_init:

;final_project.c,21 :: 		void Timer0_init(void) {
;final_project.c,23 :: 		OPTION_REG = 0x05;
	MOVLW      5
	MOVWF      OPTION_REG+0
;final_project.c,24 :: 		TMR0 = 0xF0;             // Initial load
	MOVLW      240
	MOVWF      TMR0+0
;final_project.c,25 :: 		INTCON &= ~0x04;         // Clear Timer0 overflow flag (T0IF)
	BCF        INTCON+0, 2
;final_project.c,26 :: 		INTCON |= 0x20;          // Enable Timer0 interrupt (T0IE)
	BSF        INTCON+0, 5
;final_project.c,27 :: 		}
L_end_Timer0_init:
	RETURN
; end of _Timer0_init

_Timer2_init:

;final_project.c,30 :: 		void Timer2_init(void) {
;final_project.c,43 :: 		T2CON = 0x06;   // Timer2 on, prescaler=1:16, postscaler=1:1
	MOVLW      6
	MOVWF      T2CON+0
;final_project.c,46 :: 		PR2 = 63;
	MOVLW      63
	MOVWF      PR2+0
;final_project.c,49 :: 		PIR1 &= ~0x02;   // TMR2IF = 0
	BCF        PIR1+0, 1
;final_project.c,50 :: 		PIE1 |= 0x02;    // TMR2IE = 1
	BSF        PIE1+0, 1
;final_project.c,51 :: 		}
L_end_Timer2_init:
	RETURN
; end of _Timer2_init

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;final_project.c,54 :: 		void interrupt(void) {
;final_project.c,56 :: 		if (INTCON & 0x04) {    // T0IF?
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;final_project.c,57 :: 		PORTC ^= 0x04;      // Toggle RC2 (example action for Timer0)
	MOVLW      4
	XORWF      PORTC+0, 1
;final_project.c,58 :: 		INTCON &= ~0x04;    // Clear T0IF
	BCF        INTCON+0, 2
;final_project.c,59 :: 		TMR0 = 0xF0;        // Reload Timer0 if necessary
	MOVLW      240
	MOVWF      TMR0+0
;final_project.c,60 :: 		i++;
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;final_project.c,61 :: 		}
L_interrupt0:
;final_project.c,62 :: 		if (i == 100) {
	MOVLW      0
	XORWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt21
	MOVLW      100
	XORWF      _i+0, 0
L__interrupt21:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;final_project.c,63 :: 		update_lcd = 1;  // Set flag for LCD update
	MOVLW      1
	MOVWF      _update_lcd+0
;final_project.c,64 :: 		c_i++;
	INCF       _c_i+0, 1
;final_project.c,65 :: 		i = 0;
	CLRF       _i+0
	CLRF       _i+1
;final_project.c,66 :: 		}
L_interrupt1:
;final_project.c,69 :: 		if (PIR1 & 0x02) {      // TMR2IF?
	BTFSS      PIR1+0, 1
	GOTO       L_interrupt2
;final_project.c,70 :: 		PORTC ^= 0x08;      // Toggle RC3 (example action for Timer2)
	MOVLW      8
	XORWF      PORTC+0, 1
;final_project.c,71 :: 		PIR1 &= ~0x02;      // Clear TMR2IF
	BCF        PIR1+0, 1
;final_project.c,74 :: 		j++;
	INCF       _j+0, 1
	BTFSC      STATUS+0, 2
	INCF       _j+1, 1
;final_project.c,75 :: 		}
L_interrupt2:
;final_project.c,76 :: 		if (j == 100) {
	MOVLW      0
	XORWF      _j+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt22
	MOVLW      100
	XORWF      _j+0, 0
L__interrupt22:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;final_project.c,77 :: 		update_lcd = 1;  // Set flag for LCD update
	MOVLW      1
	MOVWF      _update_lcd+0
;final_project.c,78 :: 		c_j++;
	INCF       _c_j+0, 1
;final_project.c,79 :: 		j = 0;
	CLRF       _j+0
	CLRF       _j+1
;final_project.c,80 :: 		}
L_interrupt3:
;final_project.c,81 :: 		if (PIR2 & 0x01) {  // CCP2 interrupt
	BTFSS      PIR2+0, 0
	GOTO       L_interrupt4
;final_project.c,82 :: 		if (HL) {  // High
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt5
;final_project.c,83 :: 		CCPR2H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR2H+0
;final_project.c,84 :: 		CCPR2L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR2L+0
;final_project.c,85 :: 		HL = 0;  // Next time low
	CLRF       _HL+0
;final_project.c,86 :: 		CCP2CON = 0x09;  // Compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP2CON+0
;final_project.c,87 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,88 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,89 :: 		} else {  // Low
	GOTO       L_interrupt6
L_interrupt5:
;final_project.c,90 :: 		CCPR2H = (40000 - angle) >> 8;  // 40000 counts correspond to 20ms
	MOVF       _angle+0, 0
	SUBLW      64
	MOVWF      R3+0
	MOVF       _angle+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      156
	MOVWF      R3+1
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR2H+0
;final_project.c,91 :: 		CCPR2L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR2L+0
;final_project.c,92 :: 		CCP2CON = 0x08;  // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP2CON+0
;final_project.c,93 :: 		HL = 1;  // Next time high
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,94 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,95 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,96 :: 		}
L_interrupt6:
;final_project.c,98 :: 		PIR2 &= ~0x01;  // Clear CCP2 interrupt flag
	BCF        PIR2+0, 0
;final_project.c,99 :: 		}
L_interrupt4:
;final_project.c,100 :: 		}
L_end_interrupt:
L__interrupt20:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;final_project.c,102 :: 		void main() {
;final_project.c,105 :: 		TRISC = 0x00;  // Set all PORTC pins as output
	CLRF       TRISC+0
;final_project.c,106 :: 		PORTC = 0xC0;  // Clear PORTC, set enables to 0 active low
	MOVLW      192
	MOVWF      PORTC+0
;final_project.c,107 :: 		ATD_init();
	CALL       _ATD_init+0
;final_project.c,110 :: 		PORTD = 0xFF;
	MOVLW      255
	MOVWF      PORTD+0
;final_project.c,113 :: 		Timer0_init();  // Initialize Timer0
	CALL       _Timer0_init+0
;final_project.c,114 :: 		Timer2_init();  // Initialize Timer1
	CALL       _Timer2_init+0
;final_project.c,116 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;final_project.c,117 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,118 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,119 :: 		Lcd_Out(1,1,"Hello!!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_final_project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,122 :: 		INTCON |= 0x80; // Global Interrupt Enable (GIE)
	BSF        INTCON+0, 7
;final_project.c,123 :: 		INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)
	BSF        INTCON+0, 6
;final_project.c,124 :: 		i = 0;
	CLRF       _i+0
	CLRF       _i+1
;final_project.c,125 :: 		j = 0;
	CLRF       _j+0
	CLRF       _j+1
;final_project.c,126 :: 		c_i = 0;
	CLRF       _c_i+0
;final_project.c,127 :: 		c_j = 0;
	CLRF       _c_j+0
;final_project.c,129 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,130 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,132 :: 		HL = 1;  // Start high
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,133 :: 		CCP2CON = 0x08;  // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP2CON+0
;final_project.c,135 :: 		T1CON = 0x01;  // TMR1 On Fosc/4 (increment 0.5µs) with 0 prescaler (TMR1 overflow after 0xFFFF counts == 32.767ms)
	MOVLW      1
	MOVWF      T1CON+0
;final_project.c,137 :: 		INTCON = 0xC0;  // Enable GIE and peripheral interrupts
	MOVLW      192
	MOVWF      INTCON+0
;final_project.c,138 :: 		PIE2 |= 0x01;   // Enable CCP2 interrupts
	BSF        PIE2+0, 0
;final_project.c,139 :: 		CCPR2H = 2000 >> 8;  // Value preset in a program to compare the TMR1H value to - 1ms
	MOVLW      7
	MOVWF      CCPR2H+0
;final_project.c,140 :: 		CCPR2L = 2000;       // Value preset in a program to compare the TMR1L value to
	MOVLW      208
	MOVWF      CCPR2L+0
;final_project.c,143 :: 		while (1) {
L_main7:
;final_project.c,145 :: 		if (update_lcd) {
	MOVF       _update_lcd+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main9
;final_project.c,146 :: 		update_lcd = 0;  // Clear the flag
	CLRF       _update_lcd+0
;final_project.c,147 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,148 :: 		IntToStr(c_i, print_i);       // Convert values to strings
	MOVF       _c_i+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _print_i+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;final_project.c,149 :: 		IntToStr(c_j, print_j);
	MOVF       _c_j+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _print_j+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;final_project.c,150 :: 		Lcd_Out(1, 1, print_i);       // Display values
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_i+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,151 :: 		Lcd_Out(2, 1, print_j);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_j+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,153 :: 		}
L_main9:
;final_project.c,159 :: 		if(PORTD & 0x10) draw_e();
	BTFSS      PORTD+0, 4
	GOTO       L_main10
	CALL       _draw_e+0
L_main10:
;final_project.c,160 :: 		if(PORTD & 0x20) draw_a();
	BTFSS      PORTD+0, 5
	GOTO       L_main11
	CALL       _draw_a+0
L_main11:
;final_project.c,163 :: 		if (PORTD & 0x01) {  // RD0 pressed
	BTFSS      PORTD+0, 0
	GOTO       L_main12
;final_project.c,164 :: 		angle = 1000;  // 0° (0.5 ms pulse width)
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;final_project.c,165 :: 		} else if (PORTD & 0x02) {  // RD1 pressed
	GOTO       L_main13
L_main12:
	BTFSS      PORTD+0, 1
	GOTO       L_main14
;final_project.c,166 :: 		angle = 1300;  // 90° (1.5 ms pulse width)
	MOVLW      20
	MOVWF      _angle+0
	MOVLW      5
	MOVWF      _angle+1
;final_project.c,167 :: 		} else if (PORTD & 0x04) {  // RD2 pressed
	GOTO       L_main15
L_main14:
	BTFSS      PORTD+0, 2
	GOTO       L_main16
;final_project.c,168 :: 		angle = 3500;  // 180° (2 ms pulse width)
	MOVLW      172
	MOVWF      _angle+0
	MOVLW      13
	MOVWF      _angle+1
;final_project.c,169 :: 		}
L_main16:
L_main15:
L_main13:
;final_project.c,173 :: 		}
	GOTO       L_main7
;final_project.c,175 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
