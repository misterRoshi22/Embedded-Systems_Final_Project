
_Timer0_init:

;final_project.c,23 :: 		void Timer0_init(void) {
;final_project.c,25 :: 		OPTION_REG = 0x05;
	MOVLW      5
	MOVWF      OPTION_REG+0
;final_project.c,26 :: 		TMR0 = 0xF0;             // Initial load
	MOVLW      240
	MOVWF      TMR0+0
;final_project.c,27 :: 		INTCON &= ~0x04;         // Clear Timer0 overflow flag (T0IF)
	BCF        INTCON+0, 2
;final_project.c,28 :: 		INTCON |= 0x20;          // Enable Timer0 interrupt (T0IE)
	BSF        INTCON+0, 5
;final_project.c,29 :: 		}
L_end_Timer0_init:
	RETURN
; end of _Timer0_init

_Timer2_init:

;final_project.c,32 :: 		void Timer2_init(void) {
;final_project.c,45 :: 		T2CON = 0x06;   // Timer2 on, prescaler=1:16, postscaler=1:1
	MOVLW      6
	MOVWF      T2CON+0
;final_project.c,48 :: 		PR2 = 63;
	MOVLW      63
	MOVWF      PR2+0
;final_project.c,51 :: 		PIR1 &= ~0x02;   // TMR2IF = 0
	BCF        PIR1+0, 1
;final_project.c,52 :: 		PIE1 |= 0x02;    // TMR2IE = 1
	BSF        PIE1+0, 1
;final_project.c,53 :: 		}
L_end_Timer2_init:
	RETURN
; end of _Timer2_init

_draw_circle:

;final_project.c,56 :: 		void draw_circle() {
;final_project.c,58 :: 		angle = 1200;  // For example, ~1.5 ms (90°) if that lowers the pen
	MOVLW      176
	MOVWF      _angle+0
	MOVLW      4
	MOVWF      _angle+1
;final_project.c,59 :: 		Delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_draw_circle0:
	DECFSZ     R13+0, 1
	GOTO       L_draw_circle0
	DECFSZ     R12+0, 1
	GOTO       L_draw_circle0
	DECFSZ     R11+0, 1
	GOTO       L_draw_circle0
;final_project.c,63 :: 		for (step = 0; step < 36; step++) {
	CLRF       _step+0
	CLRF       _step+1
L_draw_circle1:
	MOVLW      128
	XORWF      _step+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_circle32
	MOVLW      36
	SUBWF      _step+0, 0
L__draw_circle32:
	BTFSC      STATUS+0, 0
	GOTO       L_draw_circle2
;final_project.c,66 :: 		if (step < 18) {
	MOVLW      128
	XORWF      _step+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_circle33
	MOVLW      18
	SUBWF      _step+0, 0
L__draw_circle33:
	BTFSC      STATUS+0, 0
	GOTO       L_draw_circle4
;final_project.c,67 :: 		MOTOR1_SPEED = 0xE0; // faster stepping
	MOVLW      224
	MOVWF      _MOTOR1_SPEED+0
;final_project.c,68 :: 		} else {
	GOTO       L_draw_circle5
L_draw_circle4:
;final_project.c,69 :: 		MOTOR1_SPEED = 0xF0; // slower stepping
	MOVLW      240
	MOVWF      _MOTOR1_SPEED+0
;final_project.c,70 :: 		}
L_draw_circle5:
;final_project.c,74 :: 		for (sub = 0; sub < 5; sub++) {
	CLRF       _sub+0
	CLRF       _sub+1
L_draw_circle6:
	MOVLW      128
	XORWF      _sub+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_circle34
	MOVLW      5
	SUBWF      _sub+0, 0
L__draw_circle34:
	BTFSC      STATUS+0, 0
	GOTO       L_draw_circle7
;final_project.c,75 :: 		draw_right(); // or a custom function that does 1 step to the right
	CALL       _draw_right+0
;final_project.c,76 :: 		draw_up();    // 1 step up
	CALL       _draw_up+0
;final_project.c,74 :: 		for (sub = 0; sub < 5; sub++) {
	INCF       _sub+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sub+1, 1
;final_project.c,77 :: 		}
	GOTO       L_draw_circle6
L_draw_circle7:
;final_project.c,63 :: 		for (step = 0; step < 36; step++) {
	INCF       _step+0, 1
	BTFSC      STATUS+0, 2
	INCF       _step+1, 1
;final_project.c,81 :: 		}
	GOTO       L_draw_circle1
L_draw_circle2:
;final_project.c,84 :: 		angle = 900;  // ~0.5 ms (0°), maybe lifts the pen
	MOVLW      132
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;final_project.c,85 :: 		Delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_draw_circle9:
	DECFSZ     R13+0, 1
	GOTO       L_draw_circle9
	DECFSZ     R12+0, 1
	GOTO       L_draw_circle9
	DECFSZ     R11+0, 1
	GOTO       L_draw_circle9
;final_project.c,86 :: 		}
L_end_draw_circle:
	RETURN
; end of _draw_circle

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;final_project.c,89 :: 		void interrupt(void) {
;final_project.c,91 :: 		if (INTCON & 0x04) {    // T0IF?
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt10
;final_project.c,92 :: 		PORTC ^= 0x04;      // Toggle RC2 (example action for Timer0)
	MOVLW      4
	XORWF      PORTC+0, 1
;final_project.c,93 :: 		INTCON &= ~0x04;    // Clear T0IF
	BCF        INTCON+0, 2
;final_project.c,94 :: 		TMR0 = MOTOR1_SPEED;        // Reload Timer0 if necessary
	MOVF       _MOTOR1_SPEED+0, 0
	MOVWF      TMR0+0
;final_project.c,95 :: 		i++;
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;final_project.c,96 :: 		}
L_interrupt10:
;final_project.c,97 :: 		if (i == 100) {
	MOVLW      0
	XORWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt37
	MOVLW      100
	XORWF      _i+0, 0
L__interrupt37:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt11
;final_project.c,98 :: 		update_lcd = 1;  // Set flag for LCD update
	MOVLW      1
	MOVWF      _update_lcd+0
;final_project.c,99 :: 		c_i++;
	INCF       _c_i+0, 1
;final_project.c,100 :: 		i = 0;
	CLRF       _i+0
	CLRF       _i+1
;final_project.c,101 :: 		}
L_interrupt11:
;final_project.c,104 :: 		if (PIR1 & 0x02) {      // TMR2IF?
	BTFSS      PIR1+0, 1
	GOTO       L_interrupt12
;final_project.c,105 :: 		PORTC ^= 0x08;      // Toggle RC3 (example action for Timer2)
	MOVLW      8
	XORWF      PORTC+0, 1
;final_project.c,106 :: 		PIR1 &= ~0x02;      // Clear TMR2IF
	BCF        PIR1+0, 1
;final_project.c,107 :: 		j++;
	INCF       _j+0, 1
	BTFSC      STATUS+0, 2
	INCF       _j+1, 1
;final_project.c,108 :: 		}
L_interrupt12:
;final_project.c,109 :: 		if (j == 100) {
	MOVLW      0
	XORWF      _j+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt38
	MOVLW      100
	XORWF      _j+0, 0
L__interrupt38:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt13
;final_project.c,110 :: 		update_lcd = 1;  // Set flag for LCD update
	MOVLW      1
	MOVWF      _update_lcd+0
;final_project.c,111 :: 		c_j++;
	INCF       _c_j+0, 1
;final_project.c,112 :: 		j = 0;
	CLRF       _j+0
	CLRF       _j+1
;final_project.c,113 :: 		}
L_interrupt13:
;final_project.c,114 :: 		if (PIR2 & 0x01) {  // CCP2 interrupt
	BTFSS      PIR2+0, 0
	GOTO       L_interrupt14
;final_project.c,115 :: 		if (HL) {  // High
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt15
;final_project.c,116 :: 		CCPR2H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR2H+0
;final_project.c,117 :: 		CCPR2L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR2L+0
;final_project.c,118 :: 		HL = 0;  // Next time low
	CLRF       _HL+0
;final_project.c,119 :: 		CCP2CON = 0x09;  // Compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP2CON+0
;final_project.c,120 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,121 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,122 :: 		} else {  // Low
	GOTO       L_interrupt16
L_interrupt15:
;final_project.c,123 :: 		CCPR2H = (40000 - angle) >> 8;  // 40000 counts correspond to 20ms
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
;final_project.c,124 :: 		CCPR2L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR2L+0
;final_project.c,125 :: 		CCP2CON = 0x08;  // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP2CON+0
;final_project.c,126 :: 		HL = 1;  // Next time high
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,127 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,128 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,129 :: 		}
L_interrupt16:
;final_project.c,131 :: 		PIR2 &= ~0x01;  // Clear CCP2 interrupt flag
	BCF        PIR2+0, 0
;final_project.c,132 :: 		}
L_interrupt14:
;final_project.c,133 :: 		}
L_end_interrupt:
L__interrupt36:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;final_project.c,135 :: 		void main() {
;final_project.c,138 :: 		TRISC = 0x00;  // Set all PORTC pins as output
	CLRF       TRISC+0
;final_project.c,139 :: 		PORTC = 0xC0;  // Clear PORTC, set enables to 0 active low
	MOVLW      192
	MOVWF      PORTC+0
;final_project.c,140 :: 		ATD_init();
	CALL       _ATD_init+0
;final_project.c,143 :: 		PORTD = 0xFF;
	MOVLW      255
	MOVWF      PORTD+0
;final_project.c,146 :: 		Timer0_init();  // Initialize Timer0
	CALL       _Timer0_init+0
;final_project.c,147 :: 		Timer2_init();  // Initialize Timer1
	CALL       _Timer2_init+0
;final_project.c,149 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;final_project.c,150 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,151 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,152 :: 		Lcd_Out(1,1,"Hello!!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_final_project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,155 :: 		INTCON |= 0x80; // Global Interrupt Enable (GIE)
	BSF        INTCON+0, 7
;final_project.c,156 :: 		INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)
	BSF        INTCON+0, 6
;final_project.c,157 :: 		i = 0;
	CLRF       _i+0
	CLRF       _i+1
;final_project.c,158 :: 		j = 0;
	CLRF       _j+0
	CLRF       _j+1
;final_project.c,159 :: 		c_i = 0;
	CLRF       _c_i+0
;final_project.c,160 :: 		c_j = 0;
	CLRF       _c_j+0
;final_project.c,162 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,163 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,165 :: 		HL = 1;  // Start high
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,166 :: 		CCP2CON = 0x08;  // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP2CON+0
;final_project.c,168 :: 		T1CON = 0x01;  // TMR1 On Fosc/4 (increment 0.5µs) with 0 prescaler (TMR1 overflow after 0xFFFF counts == 32.767ms)
	MOVLW      1
	MOVWF      T1CON+0
;final_project.c,170 :: 		INTCON = 0xC0;  // Enable GIE and peripheral interrupts
	MOVLW      192
	MOVWF      INTCON+0
;final_project.c,171 :: 		PIE2 |= 0x01;   // Enable CCP2 interrupts
	BSF        PIE2+0, 0
;final_project.c,172 :: 		CCPR2H = 2000 >> 8;  // Value preset in a program to compare the TMR1H value to - 1ms
	MOVLW      7
	MOVWF      CCPR2H+0
;final_project.c,173 :: 		CCPR2L = 2000;       // Value preset in a program to compare the TMR1L value to
	MOVLW      208
	MOVWF      CCPR2L+0
;final_project.c,174 :: 		angle = 800;  // 0° (0.5 ms pulse width)
	MOVLW      32
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;final_project.c,175 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main17:
	DECFSZ     R13+0, 1
	GOTO       L_main17
	DECFSZ     R12+0, 1
	GOTO       L_main17
	DECFSZ     R11+0, 1
	GOTO       L_main17
	NOP
;final_project.c,176 :: 		draw_left();
	CALL       _draw_left+0
;final_project.c,177 :: 		draw_up();
	CALL       _draw_up+0
;final_project.c,178 :: 		draw_right();
	CALL       _draw_right+0
;final_project.c,179 :: 		angle = 1200;  // 90° (1.5 ms pulse width)
	MOVLW      176
	MOVWF      _angle+0
	MOVLW      4
	MOVWF      _angle+1
;final_project.c,180 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main18:
	DECFSZ     R13+0, 1
	GOTO       L_main18
	DECFSZ     R12+0, 1
	GOTO       L_main18
	DECFSZ     R11+0, 1
	GOTO       L_main18
	NOP
;final_project.c,181 :: 		move_down();
	CALL       _move_down+0
;final_project.c,182 :: 		move_down();
	CALL       _move_down+0
;final_project.c,183 :: 		angle = 800;  // 0° (0.5 ms pulse width)
	MOVLW      32
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;final_project.c,184 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main19:
	DECFSZ     R13+0, 1
	GOTO       L_main19
	DECFSZ     R12+0, 1
	GOTO       L_main19
	DECFSZ     R11+0, 1
	GOTO       L_main19
	NOP
;final_project.c,185 :: 		draw_left();
	CALL       _draw_left+0
;final_project.c,186 :: 		draw_up();
	CALL       _draw_up+0
;final_project.c,187 :: 		angle = 1200;  // 90° (1.5 ms pulse width)
	MOVLW      176
	MOVWF      _angle+0
	MOVLW      4
	MOVWF      _angle+1
;final_project.c,188 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	DECFSZ     R11+0, 1
	GOTO       L_main20
	NOP
;final_project.c,189 :: 		move_right();
	CALL       _move_right+0
;final_project.c,193 :: 		while (1) {
L_main21:
;final_project.c,195 :: 		if (update_lcd) {
	MOVF       _update_lcd+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main23
;final_project.c,196 :: 		update_lcd = 0;  // Clear the flag
	CLRF       _update_lcd+0
;final_project.c,197 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,198 :: 		IntToStr(c_i, print_i);       // Convert values to strings
	MOVF       _c_i+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _print_i+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;final_project.c,199 :: 		IntToStr(c_j, print_j);
	MOVF       _c_j+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _print_j+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;final_project.c,200 :: 		Lcd_Out(1, 1, print_i);       // Display values
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_i+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,201 :: 		Lcd_Out(2, 1, print_j);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_j+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,203 :: 		}
L_main23:
;final_project.c,209 :: 		if(PORTD & 0x10) draw_e();
	BTFSS      PORTD+0, 4
	GOTO       L_main24
	CALL       _draw_e+0
L_main24:
;final_project.c,210 :: 		if(PORTD & 0x20) draw_a();
	BTFSS      PORTD+0, 5
	GOTO       L_main25
	CALL       _draw_a+0
L_main25:
;final_project.c,213 :: 		if (PORTD & 0x01) {  // RD0 pressed
	BTFSS      PORTD+0, 0
	GOTO       L_main26
;final_project.c,214 :: 		angle = 1000;  // 0° (0.5 ms pulse width)
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;final_project.c,215 :: 		} else if (PORTD & 0x02) {  // RD1 pressed
	GOTO       L_main27
L_main26:
	BTFSS      PORTD+0, 1
	GOTO       L_main28
;final_project.c,216 :: 		angle = 1300;  // 90° (1.5 ms pulse width)
	MOVLW      20
	MOVWF      _angle+0
	MOVLW      5
	MOVWF      _angle+1
;final_project.c,217 :: 		}
L_main28:
L_main27:
;final_project.c,223 :: 		}
	GOTO       L_main21
;final_project.c,225 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
