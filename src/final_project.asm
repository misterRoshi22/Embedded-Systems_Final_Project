
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;final_project.c,77 :: 		void interrupt(void) {
;final_project.c,79 :: 		if (INTCON & 0x04) {    // STEPPER MOTOR 1 Toggle
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;final_project.c,80 :: 		PORTC ^= 0x02;      // toggle RC1
	MOVLW      2
	XORWF      PORTC+0, 1
;final_project.c,81 :: 		PORTC ^= 0x08;      // toggle RC3
	MOVLW      8
	XORWF      PORTC+0, 1
;final_project.c,82 :: 		INTCON &= ~0x04;    // clear T0IF
	BCF        INTCON+0, 2
;final_project.c,83 :: 		TMR0 = 0xE8 + ((size - 50) * (0xF8 - 0xE8)) / (255 - 50);
	MOVLW      50
	SUBWF      _size+0, 0
	MOVWF      R3+0
	CLRF       R3+1
	BTFSS      STATUS+0, 0
	DECF       R3+1, 1
	MOVLW      4
	MOVWF      R2+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__interrupt22:
	BTFSC      STATUS+0, 2
	GOTO       L__interrupt23
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__interrupt22
L__interrupt23:
	MOVLW      205
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	ADDLW      232
	MOVWF      TMR0+0
;final_project.c,84 :: 		count_overflow++;
	INCF       _count_overflow+0, 1
;final_project.c,85 :: 		}
L_interrupt0:
;final_project.c,87 :: 		if(count_overflow == 255) speed_tester++;
	MOVF       _count_overflow+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
	INCF       _speed_tester+0, 1
L_interrupt1:
;final_project.c,94 :: 		if(PIR1 & 0x04){                                    // Servo Motor CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt2
;final_project.c,95 :: 		if(HL) {                                // high
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt3
;final_project.c,96 :: 		CCPR1H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;final_project.c,97 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;final_project.c,98 :: 		HL = 0;                      // next time low
	CLRF       _HL+0
;final_project.c,99 :: 		CCP1CON = 0x09;              // compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP1CON+0
;final_project.c,100 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,101 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,102 :: 		}
	GOTO       L_interrupt4
L_interrupt3:
;final_project.c,105 :: 		CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
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
	MOVWF      CCPR1H+0
;final_project.c,106 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;final_project.c,107 :: 		CCP1CON = 0x08;             // compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;final_project.c,108 :: 		HL = 1;                     //next time High
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,109 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,110 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,111 :: 		}
L_interrupt4:
;final_project.c,113 :: 		PIR1 = PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;final_project.c,114 :: 		}
L_interrupt2:
;final_project.c,115 :: 		}
L_end_interrupt:
L__interrupt21:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;final_project.c,117 :: 		void main() {
;final_project.c,118 :: 		TRISC = 0x00;  // Set all PORTC pins as output
	CLRF       TRISC+0
;final_project.c,119 :: 		PORTC = 0xC0;  // Clear PORTC, set enables to 0 active low
	MOVLW      192
	MOVWF      PORTC+0
;final_project.c,121 :: 		TRISD = 0xFF;
	MOVLW      255
	MOVWF      TRISD+0
;final_project.c,122 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;final_project.c,126 :: 		ATD_init();
	CALL       _ATD_init+0
;final_project.c,127 :: 		Timer0_Init();  // Initialize Timer0
	CALL       _Timer0_Init+0
;final_project.c,129 :: 		Timer1_Init();  // Initialize Timer1
	CALL       _Timer1_Init+0
;final_project.c,130 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;final_project.c,132 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,133 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,137 :: 		INTCON |= 0x80; // Global Interrupt Enable (GIE)
	BSF        INTCON+0, 7
;final_project.c,138 :: 		INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)
	BSF        INTCON+0, 6
;final_project.c,140 :: 		while (1) {
L_main5:
;final_project.c,142 :: 		size = ATD_read(0);  //0-255
	CLRF       FARG_ATD_read_channel+0
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _size+0
;final_project.c,143 :: 		size = 50 + ((size * (150 - 50)) / 242); //  50-150
	MOVLW      0
	MOVWF      R0+1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      242
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	ADDLW      50
	MOVWF      _size+0
;final_project.c,152 :: 		if (previous_letter != braille_map[letter]) {
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       _previous_letter+0, 0
	XORWF      INDF+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main7
;final_project.c,153 :: 		update_current_letter_display(braille_map[letter]);
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_update_current_letter_display_current_letter+0
	CALL       _update_current_letter_display+0
;final_project.c,154 :: 		previous_letter = braille_map[letter];
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      _previous_letter+0
;final_project.c,155 :: 		}
L_main7:
;final_project.c,156 :: 		update_current_size_display(size);  // Update size display
	MOVF       _size+0, 0
	MOVWF      FARG_update_current_size_display_input_size+0
	CLRF       FARG_update_current_size_display_input_size+1
	CALL       _update_current_size_display+0
;final_project.c,158 :: 		if ((PORTD & 0x40) == 0x40) {  // check if enter is pressed
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main8
;final_project.c,159 :: 		Delay(50);
	MOVLW      50
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,160 :: 		if (current_column > letters_per_line) { // move to next row
	MOVF       _current_column+0, 0
	SUBLW      20
	BTFSC      STATUS+0, 0
	GOTO       L_main9
;final_project.c,161 :: 		current_row++;
	INCF       _current_row+0, 1
;final_project.c,162 :: 		current_column = 1;
	MOVLW      1
	MOVWF      _current_column+0
;final_project.c,164 :: 		if (current_row > 3) { // clear screen after 3rd row is full
	MOVF       _current_row+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_main10
;final_project.c,165 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,166 :: 		update_current_letter_display(braille_map[letter]);
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_update_current_letter_display_current_letter+0
	CALL       _update_current_letter_display+0
;final_project.c,167 :: 		current_row = 1;
	MOVLW      1
	MOVWF      _current_row+0
;final_project.c,168 :: 		}
L_main10:
;final_project.c,169 :: 		}
L_main9:
;final_project.c,171 :: 		Lcd_Chr(current_row, current_column, braille_map[letter]);
	MOVF       _current_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _current_column+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;final_project.c,200 :: 		current_column++; // Move to the next column
	INCF       _current_column+0, 1
;final_project.c,201 :: 		letter = 0x00; // Clear letter
	CLRF       _letter+0
;final_project.c,203 :: 		while ((PORTD & 0x40));
L_main11:
	BTFSS      PORTD+0, 6
	GOTO       L_main12
	GOTO       L_main11
L_main12:
;final_project.c,204 :: 		Delay(50);
	MOVLW      50
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,205 :: 		}
L_main8:
;final_project.c,207 :: 		if (PORTD & 0x01) letter |= 0x01; // Set bit 0
	BTFSS      PORTD+0, 0
	GOTO       L_main13
	BSF        _letter+0, 0
L_main13:
;final_project.c,208 :: 		if (PORTD & 0x02) letter |= 0x02; // Set bit 1
	BTFSS      PORTD+0, 1
	GOTO       L_main14
	BSF        _letter+0, 1
L_main14:
;final_project.c,209 :: 		if (PORTD & 0x04) letter |= 0x04; // Set bit 2
	BTFSS      PORTD+0, 2
	GOTO       L_main15
	BSF        _letter+0, 2
L_main15:
;final_project.c,210 :: 		if (PORTD & 0x08) letter |= 0x08; // Set bit 3
	BTFSS      PORTD+0, 3
	GOTO       L_main16
	BSF        _letter+0, 3
L_main16:
;final_project.c,211 :: 		if (PORTD & 0x10) letter |= 0x10; // Set bit 4
	BTFSS      PORTD+0, 4
	GOTO       L_main17
	BSF        _letter+0, 4
L_main17:
;final_project.c,212 :: 		if (PORTD & 0x20) letter |= 0x20; // Set bit 5
	BTFSS      PORTD+0, 5
	GOTO       L_main18
	BSF        _letter+0, 5
L_main18:
;final_project.c,213 :: 		if (PORTD & 0x80) letter = 0x00;  // Clear all bits
	BTFSS      PORTD+0, 7
	GOTO       L_main19
	CLRF       _letter+0
L_main19:
;final_project.c,215 :: 		}
	GOTO       L_main5
;final_project.c,217 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
