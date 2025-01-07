
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;final_project.c,75 :: 		void interrupt(void) {
;final_project.c,77 :: 		if (INTCON & 0x04) {    // STEPPER MOTOR 1 Toggle
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;final_project.c,78 :: 		PORTC ^= 0x02;      // Toggle RC1 (example action for Timer0)
	MOVLW      2
	XORWF      PORTC+0, 1
;final_project.c,79 :: 		INTCON &= ~0x04;    // Clear T0IF
	BCF        INTCON+0, 2
;final_project.c,80 :: 		TMR0 = 0xF0;        // Reload Timer0 if necessary
	MOVLW      240
	MOVWF      TMR0+0
;final_project.c,81 :: 		}
L_interrupt0:
;final_project.c,83 :: 		if (PIR1 & 0x02) {      // STEPPER MOTOR 2 Toggle
	BTFSS      PIR1+0, 1
	GOTO       L_interrupt1
;final_project.c,84 :: 		PORTC ^= 0x08;      // Toggle RC3 (example action for Timer2)
	MOVLW      8
	XORWF      PORTC+0, 1
;final_project.c,85 :: 		PIR1 &= ~0x02;      // Clear TMR2IF
	BCF        PIR1+0, 1
;final_project.c,86 :: 		}
L_interrupt1:
;final_project.c,88 :: 		if(PIR1 & 0x04){                                           // CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt2
;final_project.c,89 :: 		if(HL){                                // high
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt3
;final_project.c,90 :: 		CCPR1H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;final_project.c,91 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;final_project.c,92 :: 		HL = 0;                      // next time low
	CLRF       _HL+0
;final_project.c,93 :: 		CCP1CON = 0x09;              // compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP1CON+0
;final_project.c,94 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,95 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,96 :: 		}
	GOTO       L_interrupt4
L_interrupt3:
;final_project.c,98 :: 		CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
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
;final_project.c,99 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;final_project.c,100 :: 		CCP1CON = 0x08;             // compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;final_project.c,101 :: 		HL = 1;                     //next time High
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,102 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,103 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,104 :: 		}
L_interrupt4:
;final_project.c,106 :: 		PIR1 = PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;final_project.c,107 :: 		}
L_interrupt2:
;final_project.c,110 :: 		}
L_end_interrupt:
L__interrupt56:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;final_project.c,112 :: 		void main() {
;final_project.c,113 :: 		TRISC = 0x00;  // Set all PORTC pins as output
	CLRF       TRISC+0
;final_project.c,114 :: 		PORTC = 0xC0;  // Clear PORTC, set enables to 0 active low
	MOVLW      192
	MOVWF      PORTC+0
;final_project.c,115 :: 		ATD_init();
	CALL       _ATD_init+0
;final_project.c,118 :: 		TRISD = 0xFF;
	MOVLW      255
	MOVWF      TRISD+0
;final_project.c,121 :: 		Timer0_Init();  // Initialize Timer0
	CALL       _Timer0_Init+0
;final_project.c,122 :: 		Timer2_Init();  // Initialize Timer2
	CALL       _Timer2_Init+0
;final_project.c,123 :: 		Timer1_Init();  // Initialize Timer1
	CALL       _Timer1_Init+0
;final_project.c,125 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;final_project.c,126 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,127 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,131 :: 		INTCON |= 0x80; // Global Interrupt Enable (GIE)
	BSF        INTCON+0, 7
;final_project.c,132 :: 		INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)
	BSF        INTCON+0, 6
;final_project.c,134 :: 		while (1) {
L_main5:
;final_project.c,136 :: 		speed = ATD_read(0);
	CLRF       FARG_ATD_read_channel+0
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _speed+0
;final_project.c,139 :: 		if ((PORTD & 0x40) == 0x40) {  // Check if enter is pressed
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main7
;final_project.c,140 :: 		delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	NOP
	NOP
;final_project.c,141 :: 		if (char_count == LETTER_PER_LINE) {
	MOVF       _char_count+0, 0
	XORLW      20
	BTFSS      STATUS+0, 2
	GOTO       L_main9
;final_project.c,142 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,143 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,144 :: 		}
	GOTO       L_main10
L_main9:
;final_project.c,145 :: 		else if(char_count == 2*LETTER_PER_LINE) {
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main58
	MOVLW      40
	XORWF      _char_count+0, 0
L__main58:
	BTFSS      STATUS+0, 2
	GOTO       L_main11
;final_project.c,146 :: 		Lcd_Cmd(_LCD_THIRD_ROW);
	MOVLW      148
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,147 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,148 :: 		}
	GOTO       L_main12
L_main11:
;final_project.c,149 :: 		else if(char_count == 3*LETTER_PER_LINE) {
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main59
	MOVLW      60
	XORWF      _char_count+0, 0
L__main59:
	BTFSS      STATUS+0, 2
	GOTO       L_main13
;final_project.c,150 :: 		Lcd_Cmd(_LCD_FOURTH_ROW);
	MOVLW      212
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,151 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,152 :: 		}
	GOTO       L_main14
L_main13:
;final_project.c,153 :: 		else if(char_count == 4*LETTER_PER_LINE){
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main60
	MOVLW      80
	XORWF      _char_count+0, 0
L__main60:
	BTFSS      STATUS+0, 2
	GOTO       L_main15
;final_project.c,154 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,155 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,157 :: 		}
L_main15:
L_main14:
L_main12:
L_main10:
;final_project.c,158 :: 		Lcd_Chr_Cp(braille_map[letter]); // Display character on LCD
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;final_project.c,159 :: 		char_count++;
	INCF       _char_count+0, 1
;final_project.c,161 :: 		if(braille_map[letter] == 'a') draw_a();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      97
	BTFSS      STATUS+0, 2
	GOTO       L_main16
	CALL       _draw_a+0
L_main16:
;final_project.c,162 :: 		if(braille_map[letter] == 'b') draw_b();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      98
	BTFSS      STATUS+0, 2
	GOTO       L_main17
	CALL       _draw_b+0
L_main17:
;final_project.c,163 :: 		if(braille_map[letter] == 'c') draw_c();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      99
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	CALL       _draw_c+0
L_main18:
;final_project.c,164 :: 		if(braille_map[letter] == 'd') draw_d();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      100
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	CALL       _draw_d+0
L_main19:
;final_project.c,165 :: 		if(braille_map[letter] == 'e') draw_e();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      101
	BTFSS      STATUS+0, 2
	GOTO       L_main20
	CALL       _draw_e+0
L_main20:
;final_project.c,166 :: 		if(braille_map[letter] == 'f') draw_f();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      102
	BTFSS      STATUS+0, 2
	GOTO       L_main21
	CALL       _draw_f+0
L_main21:
;final_project.c,167 :: 		if(braille_map[letter] == 'g') draw_g();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      103
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	CALL       _draw_g+0
L_main22:
;final_project.c,168 :: 		if(braille_map[letter] == 'h') draw_h();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      104
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	CALL       _draw_h+0
L_main23:
;final_project.c,169 :: 		if(braille_map[letter] == 'i') draw_i();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      105
	BTFSS      STATUS+0, 2
	GOTO       L_main24
	CALL       _draw_i+0
L_main24:
;final_project.c,170 :: 		if(braille_map[letter] == 'j') draw_j();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      106
	BTFSS      STATUS+0, 2
	GOTO       L_main25
	CALL       _draw_j+0
L_main25:
;final_project.c,171 :: 		if(braille_map[letter] == 'k') draw_k();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      107
	BTFSS      STATUS+0, 2
	GOTO       L_main26
	CALL       _draw_k+0
L_main26:
;final_project.c,172 :: 		if(braille_map[letter] == 'l') draw_l();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      108
	BTFSS      STATUS+0, 2
	GOTO       L_main27
	CALL       _draw_l+0
L_main27:
;final_project.c,173 :: 		if(braille_map[letter] == 'm') draw_m();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      109
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	CALL       _draw_m+0
L_main28:
;final_project.c,174 :: 		if(braille_map[letter] == 'n') draw_n();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      110
	BTFSS      STATUS+0, 2
	GOTO       L_main29
	CALL       _draw_n+0
L_main29:
;final_project.c,175 :: 		if(braille_map[letter] == 'o') draw_o();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      111
	BTFSS      STATUS+0, 2
	GOTO       L_main30
	CALL       _draw_o+0
L_main30:
;final_project.c,176 :: 		if(braille_map[letter] == 'p') draw_p();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      112
	BTFSS      STATUS+0, 2
	GOTO       L_main31
	CALL       _draw_p+0
L_main31:
;final_project.c,177 :: 		if(braille_map[letter] == 'q') draw_q();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      113
	BTFSS      STATUS+0, 2
	GOTO       L_main32
	CALL       _draw_q+0
L_main32:
;final_project.c,178 :: 		if(braille_map[letter] == 'r') draw_r();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      114
	BTFSS      STATUS+0, 2
	GOTO       L_main33
	CALL       _draw_r+0
L_main33:
;final_project.c,179 :: 		if(braille_map[letter] == 's') draw_s();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      115
	BTFSS      STATUS+0, 2
	GOTO       L_main34
	CALL       _draw_s+0
L_main34:
;final_project.c,180 :: 		if(braille_map[letter] == 't') draw_t();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      116
	BTFSS      STATUS+0, 2
	GOTO       L_main35
	CALL       _draw_t+0
L_main35:
;final_project.c,181 :: 		if(braille_map[letter] == 'u') draw_u();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      117
	BTFSS      STATUS+0, 2
	GOTO       L_main36
	CALL       _draw_u+0
L_main36:
;final_project.c,182 :: 		if(braille_map[letter] == 'v') draw_v();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      118
	BTFSS      STATUS+0, 2
	GOTO       L_main37
	CALL       _draw_v+0
L_main37:
;final_project.c,183 :: 		if(braille_map[letter] == 'w') draw_w();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      119
	BTFSS      STATUS+0, 2
	GOTO       L_main38
	CALL       _draw_w+0
L_main38:
;final_project.c,184 :: 		if(braille_map[letter] == 'x') draw_x();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      120
	BTFSS      STATUS+0, 2
	GOTO       L_main39
	CALL       _draw_x+0
L_main39:
;final_project.c,185 :: 		if(braille_map[letter] == 'y') draw_y();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      121
	BTFSS      STATUS+0, 2
	GOTO       L_main40
	CALL       _draw_y+0
L_main40:
;final_project.c,186 :: 		if(braille_map[letter] == 'z') draw_z();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      122
	BTFSS      STATUS+0, 2
	GOTO       L_main41
	CALL       _draw_z+0
L_main41:
;final_project.c,188 :: 		letter = 0x00;
	CLRF       _letter+0
;final_project.c,189 :: 		move_next_letter();
	CALL       _move_next_letter+0
;final_project.c,191 :: 		while ((PORTD & 0x40) == 0x40);
L_main42:
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main43
	GOTO       L_main42
L_main43:
;final_project.c,192 :: 		delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main44:
	DECFSZ     R13+0, 1
	GOTO       L_main44
	DECFSZ     R12+0, 1
	GOTO       L_main44
	NOP
	NOP
;final_project.c,193 :: 		}
L_main7:
;final_project.c,195 :: 		if ((PORTD & 0x01) == 0x01) letter |= 0x01; // Set bit 0
	MOVLW      1
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main45
	BSF        _letter+0, 0
L_main45:
;final_project.c,196 :: 		if ((PORTD & 0x02) == 0x02) letter |= 0x02; // Set bit 1
	MOVLW      2
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main46
	BSF        _letter+0, 1
L_main46:
;final_project.c,197 :: 		if ((PORTD & 0x04) == 0x04) letter |= 0x04; // Set bit 2
	MOVLW      4
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main47
	BSF        _letter+0, 2
L_main47:
;final_project.c,198 :: 		if ((PORTD & 0x08) == 0x08) letter |= 0x08; // Set bit 3
	MOVLW      8
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      8
	BTFSS      STATUS+0, 2
	GOTO       L_main48
	BSF        _letter+0, 3
L_main48:
;final_project.c,199 :: 		if ((PORTD & 0x10) == 0x10) letter |= 0x10; // Set bit 4
	MOVLW      16
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      16
	BTFSS      STATUS+0, 2
	GOTO       L_main49
	BSF        _letter+0, 4
L_main49:
;final_project.c,200 :: 		if ((PORTD & 0x20) == 0x20) letter |= 0x20; // Set bit 5
	MOVLW      32
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_main50
	BSF        _letter+0, 5
L_main50:
;final_project.c,201 :: 		if ((PORTD & 0x80) == 0x80) letter = 0x00;  // Clear all bits
	MOVLW      128
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      128
	BTFSS      STATUS+0, 2
	GOTO       L_main51
	CLRF       _letter+0
L_main51:
;final_project.c,202 :: 		}
	GOTO       L_main5
;final_project.c,204 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_pen_up:

;final_project.c,206 :: 		void pen_up(void) {
;final_project.c,207 :: 		angle = SERVO_UP;
	MOVLW      8
	MOVWF      _angle+0
	MOVLW      7
	MOVWF      _angle+1
;final_project.c,208 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,209 :: 		}
L_end_pen_up:
	RETURN
; end of _pen_up

_pen_down:

;final_project.c,211 :: 		void pen_down(void) {
;final_project.c,212 :: 		angle = SERVO_DOWN;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;final_project.c,213 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,214 :: 		}
L_end_pen_down:
	RETURN
; end of _pen_down

_draw_a:

;final_project.c,216 :: 		void draw_a(void) {
;final_project.c,217 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,218 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,219 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,220 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,221 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,222 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,223 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,224 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,225 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,226 :: 		}
L_end_draw_a:
	RETURN
; end of _draw_a

_draw_b:

;final_project.c,228 :: 		void draw_b(void) { //NO CURVES
;final_project.c,229 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,230 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,231 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,232 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,233 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,234 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,235 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,236 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,237 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,238 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,239 :: 		}
L_end_draw_b:
	RETURN
; end of _draw_b

_draw_c:

;final_project.c,241 :: 		void draw_c(void) {
;final_project.c,242 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,243 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,244 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,245 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,246 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,247 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,248 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,249 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,250 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,251 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,252 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,253 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,254 :: 		}
L_end_draw_c:
	RETURN
; end of _draw_c

_draw_d:

;final_project.c,256 :: 		void draw_d(void) {
;final_project.c,257 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,258 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,259 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,260 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,261 :: 		}
L_end_draw_d:
	RETURN
; end of _draw_d

_draw_e:

;final_project.c,263 :: 		void draw_e(void) {
;final_project.c,264 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,265 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,266 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,267 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,268 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,269 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,270 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,271 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,272 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,273 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,274 :: 		}
L_end_draw_e:
	RETURN
; end of _draw_e

_draw_f:

;final_project.c,276 :: 		void draw_f(void) {
;final_project.c,277 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,278 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,279 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,280 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,281 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,282 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,283 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,284 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,285 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,286 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,287 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,288 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,289 :: 		}
L_end_draw_f:
	RETURN
; end of _draw_f

_draw_g:

;final_project.c,291 :: 		void draw_g(void) {
;final_project.c,292 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,293 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,294 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,295 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,296 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,297 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,298 :: 		}
L_end_draw_g:
	RETURN
; end of _draw_g

_draw_h:

;final_project.c,300 :: 		void draw_h(void) {
;final_project.c,301 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,302 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,303 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,304 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,305 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,306 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,307 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,308 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,309 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,310 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,311 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,312 :: 		}
L_end_draw_h:
	RETURN
; end of _draw_h

_draw_i:

;final_project.c,314 :: 		void draw_i(void) { //TODO return to origin
;final_project.c,315 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,316 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,317 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,318 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,319 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,320 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,321 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,322 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,323 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,324 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,325 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,326 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,327 :: 		}
L_end_draw_i:
	RETURN
; end of _draw_i

_draw_j:

;final_project.c,329 :: 		void draw_j(void) {
;final_project.c,330 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,331 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,332 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,333 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,334 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,335 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,336 :: 		}
L_end_draw_j:
	RETURN
; end of _draw_j

_draw_k:

;final_project.c,338 :: 		void draw_k(void) {
;final_project.c,339 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,340 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,341 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,342 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,343 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,344 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,345 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,346 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,347 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,348 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,349 :: 		}
L_end_draw_k:
	RETURN
; end of _draw_k

_draw_l:

;final_project.c,351 :: 		void draw_l(void) {
;final_project.c,352 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,353 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,354 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,355 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,356 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,357 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,358 :: 		}
L_end_draw_l:
	RETURN
; end of _draw_l

_draw_m:

;final_project.c,360 :: 		void draw_m(void) {
;final_project.c,361 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,362 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,363 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,364 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,365 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,366 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,367 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,368 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,369 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,370 :: 		}
L_end_draw_m:
	RETURN
; end of _draw_m

_draw_n:

;final_project.c,372 :: 		void draw_n(void) {
;final_project.c,373 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,374 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,375 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,376 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,377 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,378 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,379 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,380 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,381 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,382 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,383 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,384 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,385 :: 		}
L_end_draw_n:
	RETURN
; end of _draw_n

_draw_o:

;final_project.c,387 :: 		void draw_o(void) {
;final_project.c,388 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,389 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,390 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,391 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,392 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,393 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,394 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,395 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,396 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,397 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,398 :: 		}
L_end_draw_o:
	RETURN
; end of _draw_o

_draw_p:

;final_project.c,400 :: 		void draw_p(void) {
;final_project.c,401 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,402 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,403 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,404 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,405 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,406 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,407 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,408 :: 		}
L_end_draw_p:
	RETURN
; end of _draw_p

_draw_q:

;final_project.c,410 :: 		void draw_q(void) {
;final_project.c,411 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,412 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,413 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,414 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,415 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,416 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,417 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,418 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,419 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,420 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,421 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,422 :: 		}
L_end_draw_q:
	RETURN
; end of _draw_q

_draw_r:

;final_project.c,424 :: 		void draw_r(void) {
;final_project.c,425 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,426 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,427 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,428 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,429 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,430 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,431 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,432 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,433 :: 		}
L_end_draw_r:
	RETURN
; end of _draw_r

_draw_s:

;final_project.c,435 :: 		void draw_s(void) {
;final_project.c,436 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,437 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,438 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,439 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,440 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,441 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,442 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,443 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,444 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,445 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,446 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,447 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,448 :: 		}
L_end_draw_s:
	RETURN
; end of _draw_s

_draw_t:

;final_project.c,450 :: 		void draw_t(void){
;final_project.c,451 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,452 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,453 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,454 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,455 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,456 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,457 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,458 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,459 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,460 :: 		}
L_end_draw_t:
	RETURN
; end of _draw_t

_draw_u:

;final_project.c,462 :: 		void draw_u(void) {
;final_project.c,463 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,464 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,465 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,466 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,467 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,468 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,469 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,470 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,471 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,472 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,473 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,474 :: 		}
L_end_draw_u:
	RETURN
; end of _draw_u

_draw_v:

;final_project.c,476 :: 		void draw_v(void) {
;final_project.c,477 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,478 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,479 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,480 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,481 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,482 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,483 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,484 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,485 :: 		}
L_end_draw_v:
	RETURN
; end of _draw_v

_draw_x:

;final_project.c,487 :: 		void draw_x(void) {
;final_project.c,488 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,489 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,490 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,491 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,492 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,493 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,494 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,495 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,496 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,497 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,498 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,499 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,500 :: 		}
L_end_draw_x:
	RETURN
; end of _draw_x

_draw_w:

;final_project.c,502 :: 		void draw_w(void) {
;final_project.c,503 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,504 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,505 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,506 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,507 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,508 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,509 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,510 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,511 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,512 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,513 :: 		}
L_end_draw_w:
	RETURN
; end of _draw_w

_draw_y:

;final_project.c,515 :: 		void draw_y(void) {
;final_project.c,516 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,517 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,518 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,519 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,520 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,521 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,522 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,523 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,524 :: 		}
L_end_draw_y:
	RETURN
; end of _draw_y

_draw_z:

;final_project.c,526 :: 		void draw_z(void) {
;final_project.c,527 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,528 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,529 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,530 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,531 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,532 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,533 :: 		draw_down_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,534 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,535 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,536 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,537 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,538 :: 		}
L_end_draw_z:
	RETURN
; end of _draw_z

_draw_space:

;final_project.c,541 :: 		void draw_space(void) {
;final_project.c,542 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,543 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,544 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,545 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,546 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,547 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,548 :: 		}
L_end_draw_space:
	RETURN
; end of _draw_space

_move_next_letter:

;final_project.c,550 :: 		void move_next_letter(void) {
;final_project.c,551 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,552 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,553 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,554 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,555 :: 		}
L_end_move_next_letter:
	RETURN
; end of _move_next_letter

_enter_new_line:

;final_project.c,557 :: 		void enter_new_line(void) {
;final_project.c,558 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,559 :: 		for(times = 0; times<2*(LETTER_PER_LINE-1); times++) draw_left(speed);
	CLRF       _times+0
L_enter_new_line52:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORLW      0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__enter_new_line92
	MOVLW      38
	SUBWF      _times+0, 0
L__enter_new_line92:
	BTFSC      STATUS+0, 0
	GOTO       L_enter_new_line53
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
	INCF       _times+0, 1
	GOTO       L_enter_new_line52
L_enter_new_line53:
;final_project.c,560 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,561 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,562 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,563 :: 		}
L_end_enter_new_line:
	RETURN
; end of _enter_new_line
