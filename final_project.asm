
_main:

;final_project.c,29 :: 		void main() {
;final_project.c,31 :: 		TRISD = 0xFF; // Set PORTD as input
	MOVLW      255
	MOVWF      TRISD+0
;final_project.c,32 :: 		TRISB = 0x00; // Set PORTB as output (for LCD)
	CLRF       TRISB+0
;final_project.c,34 :: 		Lcd_Init();               // Initialize LCD
	CALL       _Lcd_Init+0
;final_project.c,35 :: 		Lcd_Cmd(_LCD_CLEAR);      // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,37 :: 		while (1) {
L_main0:
;final_project.c,38 :: 		if (char_count > 31) { // Reset after filling both rows
	MOVF       _char_count+0, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L_main2
;final_project.c,39 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,40 :: 		char_count = 0;
	CLRF       _char_count+0
;final_project.c,41 :: 		}
L_main2:
;final_project.c,44 :: 		if ((PORTD & 0x40) == 0x40) {  // Button pressed
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;final_project.c,45 :: 		delay_ms(50);            // Debouncing delay
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	NOP
	NOP
;final_project.c,46 :: 		if ((PORTD & 0x40) == 0x40) {  // Confirm the button is still pressed
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;final_project.c,47 :: 		if (char_count == 16) {
	MOVF       _char_count+0, 0
	XORLW      16
	BTFSS      STATUS+0, 2
	GOTO       L_main6
;final_project.c,48 :: 		Lcd_Cmd(_LCD_SECOND_ROW); // Move cursor to second row
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,49 :: 		}
L_main6:
;final_project.c,51 :: 		Lcd_Chr_Cp(braille_map[letter]); // Display character on LCD
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;final_project.c,52 :: 		char_count++;
	INCF       _char_count+0, 1
;final_project.c,54 :: 		letter = 0x00; // Reset the letter after printing
	CLRF       _letter+0
;final_project.c,57 :: 		while ((PORTD & 0x40) == 0x40); // Wait for button to be released
L_main7:
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main8
	GOTO       L_main7
L_main8:
;final_project.c,58 :: 		delay_ms(50);                // Debouncing delay after release
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	NOP
	NOP
;final_project.c,59 :: 		}
L_main5:
;final_project.c,60 :: 		}
L_main3:
;final_project.c,63 :: 		if ((PORTD & 0x01) == 0x01) letter |= 0x01; // Set bit 0
	MOVLW      1
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main10
	BSF        _letter+0, 0
L_main10:
;final_project.c,64 :: 		if ((PORTD & 0x02) == 0x02) letter |= 0x02; // Set bit 1
	MOVLW      2
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main11
	BSF        _letter+0, 1
L_main11:
;final_project.c,65 :: 		if ((PORTD & 0x04) == 0x04) letter |= 0x04; // Set bit 2
	MOVLW      4
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main12
	BSF        _letter+0, 2
L_main12:
;final_project.c,66 :: 		if ((PORTD & 0x08) == 0x08) letter |= 0x08; // Set bit 3
	MOVLW      8
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      8
	BTFSS      STATUS+0, 2
	GOTO       L_main13
	BSF        _letter+0, 3
L_main13:
;final_project.c,67 :: 		if ((PORTD & 0x10) == 0x10) letter |= 0x10; // Set bit 4
	MOVLW      16
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      16
	BTFSS      STATUS+0, 2
	GOTO       L_main14
	BSF        _letter+0, 4
L_main14:
;final_project.c,68 :: 		if ((PORTD & 0x20) == 0x20) letter |= 0x20; // Set bit 5
	MOVLW      32
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	BSF        _letter+0, 5
L_main15:
;final_project.c,69 :: 		if ((PORTD & 0x80) == 0x80) letter = 0x00;  // Clear all bits
	MOVLW      128
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      128
	BTFSS      STATUS+0, 2
	GOTO       L_main16
	CLRF       _letter+0
L_main16:
;final_project.c,70 :: 		}
	GOTO       L_main0
;final_project.c,71 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
