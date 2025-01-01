
_Timer0_init:

;final_project.c,15 :: 		void Timer0_init(void) {
;final_project.c,16 :: 		OPTION_REG = 0x05;  // Prescaler 1:64, Timer mode, internal clock (Fosc/4)
	MOVLW      5
	MOVWF      OPTION_REG+0
;final_project.c,17 :: 		TMR0 = 0xf0;           // Clear Timer0
	MOVLW      240
	MOVWF      TMR0+0
;final_project.c,18 :: 		INTCON &= ~0x04;    // Clear Timer0 overflow flag (T0IF)
	BCF        INTCON+0, 2
;final_project.c,19 :: 		INTCON |= 0x20;     // Enable Timer0 interrupt (T0IE)
	BSF        INTCON+0, 5
;final_project.c,20 :: 		}
L_end_Timer0_init:
	RETURN
; end of _Timer0_init

_Timer1_init:

;final_project.c,23 :: 		void Timer1_init(void) {
;final_project.c,24 :: 		T1CON = 0x31;       // Timer1 enabled, Prescaler 1:8, internal clock (Fosc/4)
	MOVLW      49
	MOVWF      T1CON+0
;final_project.c,25 :: 		TMR1H = 0xFF;          // Clear Timer1 high byte
	MOVLW      255
	MOVWF      TMR1H+0
;final_project.c,26 :: 		TMR1L = 0x80;          // Clear Timer1 low byte
	MOVLW      128
	MOVWF      TMR1L+0
;final_project.c,27 :: 		PIR1 &= ~0x01;      // Clear Timer1 overflow flag (TMR1IF)
	BCF        PIR1+0, 0
;final_project.c,28 :: 		PIE1 |= 0x01;       // Enable Timer1 interrupt (TMR1IE)
	BSF        PIE1+0, 0
;final_project.c,29 :: 		}
L_end_Timer1_init:
	RETURN
; end of _Timer1_init

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;final_project.c,31 :: 		void interrupt(void) {
;final_project.c,33 :: 		if (INTCON & 0x04) {       // Check if T0IF is set
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;final_project.c,34 :: 		PORTC ^= 0x04;         // Toggle RC2 (Example action for Timer0)
	MOVLW      4
	XORWF      PORTC+0, 1
;final_project.c,35 :: 		INTCON &= ~0x04;       // Clear T0IF
	BCF        INTCON+0, 2
;final_project.c,36 :: 		TMR0 = 0xF0;              // Reload Timer0 if necessary
	MOVLW      240
	MOVWF      TMR0+0
;final_project.c,37 :: 		i++;
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;final_project.c,38 :: 		}
L_interrupt0:
;final_project.c,39 :: 		if(i == 100) {
	MOVLW      0
	XORWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt11
	MOVLW      100
	XORWF      _i+0, 0
L__interrupt11:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;final_project.c,40 :: 		update_lcd = 1;  // Set flag for LCD update
	MOVLW      1
	MOVWF      _update_lcd+0
;final_project.c,41 :: 		c_i++;
	INCF       _c_i+0, 1
;final_project.c,42 :: 		i = 0;
	CLRF       _i+0
	CLRF       _i+1
;final_project.c,43 :: 		}
L_interrupt1:
;final_project.c,46 :: 		if (PIR1 & 0x01) {         // Check if TMR1IF is set
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt2
;final_project.c,47 :: 		PORTC ^= 0x08;         // Toggle RC3 (Example action for Timer1)
	MOVLW      8
	XORWF      PORTC+0, 1
;final_project.c,48 :: 		PIR1 &= ~0x01;         // Clear TMR1IF
	BCF        PIR1+0, 0
;final_project.c,49 :: 		TMR1H = 0xFF;          // Reload Timer1 high byte if necessary
	MOVLW      255
	MOVWF      TMR1H+0
;final_project.c,50 :: 		TMR1L = 0x80;             // Reload Timer1 low byte if necessary
	MOVLW      128
	MOVWF      TMR1L+0
;final_project.c,51 :: 		j++;
	INCF       _j+0, 1
	BTFSC      STATUS+0, 2
	INCF       _j+1, 1
;final_project.c,52 :: 		}
L_interrupt2:
;final_project.c,53 :: 		if(j == 100) {
	MOVLW      0
	XORWF      _j+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt12
	MOVLW      100
	XORWF      _j+0, 0
L__interrupt12:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;final_project.c,54 :: 		update_lcd = 1;  // Set flag for LCD update
	MOVLW      1
	MOVWF      _update_lcd+0
;final_project.c,55 :: 		c_j++;
	INCF       _c_j+0, 1
;final_project.c,56 :: 		j = 0;
	CLRF       _j+0
	CLRF       _j+1
;final_project.c,57 :: 		}
L_interrupt3:
;final_project.c,59 :: 		}
L_end_interrupt:
L__interrupt10:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;final_project.c,62 :: 		void main(void) {
;final_project.c,64 :: 		TRISC = 0x00;  // Set all PORTC pins as output
	CLRF       TRISC+0
;final_project.c,65 :: 		PORTC = 0xC0;  // Clear PORTC, set enables to 0 active low
	MOVLW      192
	MOVWF      PORTC+0
;final_project.c,66 :: 		ATD_init();
	CALL       _ATD_init+0
;final_project.c,69 :: 		PORTD = 0xFF;
	MOVLW      255
	MOVWF      PORTD+0
;final_project.c,72 :: 		Timer0_init();  // Initialize Timer0
	CALL       _Timer0_init+0
;final_project.c,73 :: 		Timer1_init();  // Initialize Timer1
	CALL       _Timer1_init+0
;final_project.c,75 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;final_project.c,76 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,77 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,78 :: 		Lcd_Out(1,1,"Hello!!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_final_project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,81 :: 		INTCON |= 0x80; // Global Interrupt Enable (GIE)
	BSF        INTCON+0, 7
;final_project.c,82 :: 		INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)
	BSF        INTCON+0, 6
;final_project.c,83 :: 		i = 0;
	CLRF       _i+0
	CLRF       _i+1
;final_project.c,84 :: 		j = 0;
	CLRF       _j+0
	CLRF       _j+1
;final_project.c,85 :: 		c_i = 0;
	CLRF       _c_i+0
;final_project.c,86 :: 		c_j = 0;
	CLRF       _c_j+0
;final_project.c,88 :: 		draw_h();
	CALL       _draw_h+0
;final_project.c,89 :: 		move_next_letter();
	CALL       _move_next_letter+0
;final_project.c,90 :: 		draw_e();
	CALL       _draw_e+0
;final_project.c,91 :: 		move_next_letter();
	CALL       _move_next_letter+0
;final_project.c,92 :: 		draw_l();
	CALL       _draw_l+0
;final_project.c,93 :: 		move_next_letter();
	CALL       _move_next_letter+0
;final_project.c,94 :: 		draw_l();
	CALL       _draw_l+0
;final_project.c,95 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,98 :: 		while (1) {
L_main4:
;final_project.c,100 :: 		if (update_lcd) {
	MOVF       _update_lcd+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main6
;final_project.c,101 :: 		update_lcd = 0;  // Clear the flag
	CLRF       _update_lcd+0
;final_project.c,102 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,103 :: 		IntToStr(c_i, print_i);       // Convert values to strings
	MOVF       _c_i+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _print_i+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;final_project.c,104 :: 		IntToStr(c_j, print_j);
	MOVF       _c_j+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _print_j+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;final_project.c,105 :: 		Lcd_Out(1, 1, print_i);       // Display values
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_i+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,106 :: 		Lcd_Out(2, 1, print_j);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_j+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,108 :: 		}
L_main6:
;final_project.c,119 :: 		}
	GOTO       L_main4
;final_project.c,122 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
