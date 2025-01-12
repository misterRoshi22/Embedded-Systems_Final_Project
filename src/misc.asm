
_Delay:

;misc.c,3 :: 		void Delay(unsigned int delay) {
;misc.c,4 :: 		while (delay--) {
L_Delay0:
	MOVF       FARG_Delay_delay+0, 0
	MOVWF      R0+0
	MOVF       FARG_Delay_delay+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      FARG_Delay_delay+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_Delay_delay+1, 1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Delay1
;misc.c,5 :: 		Delay_ms(1); // Delay 1 ms at a time
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_Delay2:
	DECFSZ     R13+0, 1
	GOTO       L_Delay2
	DECFSZ     R12+0, 1
	GOTO       L_Delay2
	NOP
	NOP
;misc.c,6 :: 		}
	GOTO       L_Delay0
L_Delay1:
;misc.c,7 :: 		}
L_end_Delay:
	RETURN
; end of _Delay

_update_current_letter_display:

;misc.c,9 :: 		void update_current_letter_display(char current_letter) {
;misc.c,10 :: 		Lcd_Out(4, 1, "Char: ");   // Move to the start of the 4th row
	MOVLW      4
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_misc+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;misc.c,11 :: 		Lcd_Chr(4, 7, current_letter);  // Display the current letter
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       FARG_update_current_letter_display_current_letter+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;misc.c,12 :: 		}
L_end_update_current_letter_display:
	RETURN
; end of _update_current_letter_display

_update_current_size_display:

;misc.c,15 :: 		void update_current_size_display(unsigned int input_size) {
;misc.c,18 :: 		IntToStr(input_size, local_print_size);  // Convert size to a string
	MOVF       FARG_update_current_size_display_input_size+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_update_current_size_display_input_size+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      update_current_size_display_local_print_size_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;misc.c,19 :: 		ShiftCharsLeft(local_print_size);       // Shift characters to the left
	MOVLW      update_current_size_display_local_print_size_L0+0
	MOVWF      FARG_ShiftCharsLeft_str+0
	CALL       _ShiftCharsLeft+0
;misc.c,20 :: 		Lcd_Out(4, 12, "Size: ");               // Display "size:" label
	MOVLW      4
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_misc+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;misc.c,21 :: 		Lcd_Out(4, 18, local_print_size);       // Display the size value
	MOVLW      4
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      18
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      update_current_size_display_local_print_size_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;misc.c,22 :: 		}
L_end_update_current_size_display:
	RETURN
; end of _update_current_size_display

_ShiftCharsLeft:

;misc.c,24 :: 		void ShiftCharsLeft(char *str) {
;misc.c,25 :: 		int length = strlen(str); // Get the length of the string
	MOVF       FARG_ShiftCharsLeft_str+0, 0
	MOVWF      FARG_strlen_s+0
	CALL       _strlen+0
	MOVF       R0+0, 0
	MOVWF      ShiftCharsLeft_length_L0+0
	MOVF       R0+1, 0
	MOVWF      ShiftCharsLeft_length_L0+1
;misc.c,29 :: 		for (i = 3; i < length; i++) {
	MOVLW      3
	MOVWF      ShiftCharsLeft_i_L0+0
	MOVLW      0
	MOVWF      ShiftCharsLeft_i_L0+1
L_ShiftCharsLeft3:
	MOVLW      128
	XORWF      ShiftCharsLeft_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      ShiftCharsLeft_length_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ShiftCharsLeft10
	MOVF       ShiftCharsLeft_length_L0+0, 0
	SUBWF      ShiftCharsLeft_i_L0+0, 0
L__ShiftCharsLeft10:
	BTFSC      STATUS+0, 0
	GOTO       L_ShiftCharsLeft4
;misc.c,30 :: 		str[i - 3] = str[i];
	MOVLW      3
	SUBWF      ShiftCharsLeft_i_L0+0, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      ShiftCharsLeft_i_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDWF      FARG_ShiftCharsLeft_str+0, 0
	MOVWF      R1+0
	MOVF       ShiftCharsLeft_i_L0+0, 0
	ADDWF      FARG_ShiftCharsLeft_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;misc.c,29 :: 		for (i = 3; i < length; i++) {
	INCF       ShiftCharsLeft_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       ShiftCharsLeft_i_L0+1, 1
;misc.c,31 :: 		}
	GOTO       L_ShiftCharsLeft3
L_ShiftCharsLeft4:
;misc.c,34 :: 		str[length - 3] = '\0';
	MOVLW      3
	SUBWF      ShiftCharsLeft_length_L0+0, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      ShiftCharsLeft_length_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDWF      FARG_ShiftCharsLeft_str+0, 0
	MOVWF      FSR
	CLRF       INDF+0
;misc.c,35 :: 		}
L_end_ShiftCharsLeft:
	RETURN
; end of _ShiftCharsLeft
