
_ATD_init:

;final_project.c,22 :: 		void ATD_init(void) {
;final_project.c,23 :: 		ADCON0 = 0x41;   // ADC enabled, Fosc/16, Channel 0 (AN0)
	MOVLW      65
	MOVWF      ADCON0+0
;final_project.c,24 :: 		ADCON1 = 0xCE;   // All pins digital except AN0, right justified
	MOVLW      206
	MOVWF      ADCON1+0
;final_project.c,25 :: 		TRISA  = 0x01;   // Configure RA0/AN0 as input
	MOVLW      1
	MOVWF      TRISA+0
;final_project.c,26 :: 		}
L_end_ATD_init:
	RETURN
; end of _ATD_init

_ATD_read:

;final_project.c,29 :: 		unsigned int ATD_read(void) {
;final_project.c,30 :: 		ADCON0 |= 0x04;         // Start ADC conversion
	BSF        ADCON0+0, 2
;final_project.c,31 :: 		while (ADCON0 & 0x04);  // Wait for conversion to complete
L_ATD_read0:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read1
	GOTO       L_ATD_read0
L_ATD_read1:
;final_project.c,32 :: 		return ((ADRESH << 8) | ADRESL);  // Return 10-bit result (0..1023)
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;final_project.c,33 :: 		}
L_end_ATD_read:
	RETURN
; end of _ATD_read

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;final_project.c,36 :: 		void interrupt() {
;final_project.c,38 :: 		if (INTCON & 0x04) {
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt2
;final_project.c,40 :: 		PORTC ^= 0x04;    // Bit-2 of PORTC
	MOVLW      4
	XORWF      PORTC+0, 1
;final_project.c,43 :: 		INTCON &= ~0x04;
	BCF        INTCON+0, 2
;final_project.c,47 :: 		TMR0 = timer_value;
	MOVF       _timer_value+0, 0
	MOVWF      TMR0+0
;final_project.c,48 :: 		}
L_interrupt2:
;final_project.c,49 :: 		}
L_end_interrupt:
L__interrupt9:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;final_project.c,51 :: 		void main() {
;final_project.c,53 :: 		TRISC = 0x00;        // All PORTC pins as output
	CLRF       TRISC+0
;final_project.c,54 :: 		PORTC = 0x00;        // Initialize PORTC to 0
	CLRF       PORTC+0
;final_project.c,57 :: 		ATD_init();          // Initialize ADC
	CALL       _ATD_init+0
;final_project.c,58 :: 		Lcd_Init();          // Initialize LCD
	CALL       _Lcd_Init+0
;final_project.c,59 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,60 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,65 :: 		OPTION_REG = 0x05;
	MOVLW      5
	MOVWF      OPTION_REG+0
;final_project.c,68 :: 		TMR0   = 0;
	CLRF       TMR0+0
;final_project.c,69 :: 		INTCON &= ~0x04;     // Clear T0IF
	BCF        INTCON+0, 2
;final_project.c,72 :: 		INTCON |= 0x20;      // T0IE
	BSF        INTCON+0, 5
;final_project.c,73 :: 		INTCON |= 0x80;      // GIE
	BSF        INTCON+0, 7
;final_project.c,75 :: 		while (1) {
L_main3:
;final_project.c,77 :: 		analog_value = ATD_read();
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _analog_value+0
	MOVF       R0+1, 0
	MOVWF      _analog_value+1
;final_project.c,82 :: 		timer_value = (analog_value >> 2);  // simple approach: 0..1023 => 0..255
	MOVF       R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	MOVWF      R2+1
	RRF        R2+1, 1
	RRF        R2+0, 1
	BCF        R2+1, 7
	RRF        R2+1, 1
	RRF        R2+0, 1
	BCF        R2+1, 7
	MOVF       R2+0, 0
	MOVWF      _timer_value+0
;final_project.c,85 :: 		IntToStr(timer_value, print_string);
	MOVF       R2+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _print_string+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;final_project.c,87 :: 		Lcd_Out(1, 1, "Timer Reload:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_final_project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,88 :: 		Lcd_Out(2, 1, print_string);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_string+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,90 :: 		Delay_ms(500);   // Slow refresh to observe changes on LCD
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	DECFSZ     R11+0, 1
	GOTO       L_main5
	NOP
	NOP
;final_project.c,91 :: 		}
	GOTO       L_main3
;final_project.c,92 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
