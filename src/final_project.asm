
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;final_project.c,80 :: 		void interrupt(void) {
;final_project.c,82 :: 		if (INTCON & 0x04) {    // STEPPER MOTOR 1 Toggle
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;final_project.c,83 :: 		PORTC ^= 0x02;      // toggle RC1
	MOVLW      2
	XORWF      PORTC+0, 1
;final_project.c,84 :: 		PORTC ^= 0x08;      // toggle RC3
	MOVLW      8
	XORWF      PORTC+0, 1
;final_project.c,85 :: 		INTCON &= ~0x04;    // clear T0IF
	BCF        INTCON+0, 2
;final_project.c,86 :: 		TMR0 = 0xE8 + ((size - 50) * (0xF8 - 0xE8)) / (255 - 50);
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
L__interrupt55:
	BTFSC      STATUS+0, 2
	GOTO       L__interrupt56
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__interrupt55
L__interrupt56:
	MOVLW      205
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	ADDLW      232
	MOVWF      TMR0+0
;final_project.c,87 :: 		count_overflow++;
	INCF       _count_overflow+0, 1
;final_project.c,88 :: 		}
L_interrupt0:
;final_project.c,89 :: 		if(count_overflow == 255) speed_tester++;
	MOVF       _count_overflow+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
	INCF       _speed_tester+0, 1
L_interrupt1:
;final_project.c,96 :: 		if(PIR1 & 0x04){                                    // Servo Motor CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt2
;final_project.c,97 :: 		if(HL){                                // high
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt3
;final_project.c,98 :: 		CCPR1H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;final_project.c,99 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;final_project.c,100 :: 		HL = 0;                      // next time low
	CLRF       _HL+0
;final_project.c,101 :: 		CCP1CON = 0x09;              // compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP1CON+0
;final_project.c,102 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,103 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,104 :: 		}
	GOTO       L_interrupt4
L_interrupt3:
;final_project.c,106 :: 		CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
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
;final_project.c,107 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;final_project.c,108 :: 		CCP1CON = 0x08;             // compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;final_project.c,109 :: 		HL = 1;                     //next time High
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,110 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,111 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,112 :: 		}
L_interrupt4:
;final_project.c,114 :: 		PIR1 = PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;final_project.c,115 :: 		}
L_interrupt2:
;final_project.c,118 :: 		}
L_end_interrupt:
L__interrupt54:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;final_project.c,120 :: 		void main() {
;final_project.c,121 :: 		TRISC = 0x00;  // Set all PORTC pins as output
	CLRF       TRISC+0
;final_project.c,122 :: 		PORTC = 0xC0;  // Clear PORTC, set enables to 0 active low
	MOVLW      192
	MOVWF      PORTC+0
;final_project.c,123 :: 		ATD_init();
	CALL       _ATD_init+0
;final_project.c,125 :: 		TRISD = 0xFF;
	MOVLW      255
	MOVWF      TRISD+0
;final_project.c,128 :: 		Timer0_Init();  // Initialize Timer0
	CALL       _Timer0_Init+0
;final_project.c,130 :: 		Timer1_Init();  // Initialize Timer1
	CALL       _Timer1_Init+0
;final_project.c,132 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;final_project.c,133 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,134 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,138 :: 		INTCON |= 0x80; // Global Interrupt Enable (GIE)
	BSF        INTCON+0, 7
;final_project.c,139 :: 		INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)
	BSF        INTCON+0, 6
;final_project.c,141 :: 		while (1) {
L_main5:
;final_project.c,143 :: 		size = ATD_read(0);  //0-255
	CLRF       FARG_ATD_read_channel+0
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _size+0
;final_project.c,145 :: 		IntToStr(size, print_speed);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _print_speed+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;final_project.c,146 :: 		Lcd_Out(1, 1, print_speed);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_speed+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,148 :: 		IntToStr(speed_tester, print_speed_tester);
	MOVF       _speed_tester+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _print_speed_tester+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;final_project.c,149 :: 		Lcd_Out(2, 1, print_speed_tester);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_speed_tester+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,152 :: 		if ((PORTD & 0x40) == 0x40) {  // Check if enter is pressed
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main7
;final_project.c,153 :: 		Delay(50);
	MOVLW      50
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,154 :: 		if (char_count == letters_per_line) {
	MOVF       _char_count+0, 0
	XORLW      20
	BTFSS      STATUS+0, 2
	GOTO       L_main8
;final_project.c,155 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,156 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,157 :: 		}
	GOTO       L_main9
L_main8:
;final_project.c,158 :: 		else if(char_count == 2*letters_per_line) {
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main58
	MOVLW      40
	XORWF      _char_count+0, 0
L__main58:
	BTFSS      STATUS+0, 2
	GOTO       L_main10
;final_project.c,159 :: 		Lcd_Cmd(_LCD_THIRD_ROW);
	MOVLW      148
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,160 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,161 :: 		}
	GOTO       L_main11
L_main10:
;final_project.c,162 :: 		else if(char_count == 3*letters_per_line) {
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main59
	MOVLW      60
	XORWF      _char_count+0, 0
L__main59:
	BTFSS      STATUS+0, 2
	GOTO       L_main12
;final_project.c,163 :: 		Lcd_Cmd(_LCD_FOURTH_ROW);
	MOVLW      212
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,164 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,165 :: 		}
	GOTO       L_main13
L_main12:
;final_project.c,166 :: 		else if(char_count == 4*letters_per_line){
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main60
	MOVLW      80
	XORWF      _char_count+0, 0
L__main60:
	BTFSS      STATUS+0, 2
	GOTO       L_main14
;final_project.c,167 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,168 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,170 :: 		}
L_main14:
L_main13:
L_main11:
L_main9:
;final_project.c,171 :: 		Lcd_Chr_Cp(braille_map[letter]); // Display character on LCD
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;final_project.c,172 :: 		char_count++;
	INCF       _char_count+0, 1
;final_project.c,174 :: 		if(braille_map[letter] == 'a') draw_a();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      97
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	CALL       _draw_a+0
L_main15:
;final_project.c,175 :: 		if(braille_map[letter] == 'b') draw_b();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      98
	BTFSS      STATUS+0, 2
	GOTO       L_main16
	CALL       _draw_b+0
L_main16:
;final_project.c,176 :: 		if(braille_map[letter] == 'c') draw_c();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      99
	BTFSS      STATUS+0, 2
	GOTO       L_main17
	CALL       _draw_c+0
L_main17:
;final_project.c,177 :: 		if(braille_map[letter] == 'd') draw_d();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      100
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	CALL       _draw_d+0
L_main18:
;final_project.c,178 :: 		if(braille_map[letter] == 'e') draw_e();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      101
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	CALL       _draw_e+0
L_main19:
;final_project.c,179 :: 		if(braille_map[letter] == 'f') draw_f();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      102
	BTFSS      STATUS+0, 2
	GOTO       L_main20
	CALL       _draw_f+0
L_main20:
;final_project.c,180 :: 		if(braille_map[letter] == 'g') draw_g();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      103
	BTFSS      STATUS+0, 2
	GOTO       L_main21
	CALL       _draw_g+0
L_main21:
;final_project.c,181 :: 		if(braille_map[letter] == 'h') draw_h();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      104
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	CALL       _draw_h+0
L_main22:
;final_project.c,182 :: 		if(braille_map[letter] == 'i') draw_i();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      105
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	CALL       _draw_i+0
L_main23:
;final_project.c,183 :: 		if(braille_map[letter] == 'j') draw_j();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      106
	BTFSS      STATUS+0, 2
	GOTO       L_main24
	CALL       _draw_j+0
L_main24:
;final_project.c,184 :: 		if(braille_map[letter] == 'k') draw_k();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      107
	BTFSS      STATUS+0, 2
	GOTO       L_main25
	CALL       _draw_k+0
L_main25:
;final_project.c,185 :: 		if(braille_map[letter] == 'l') draw_l();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      108
	BTFSS      STATUS+0, 2
	GOTO       L_main26
	CALL       _draw_l+0
L_main26:
;final_project.c,186 :: 		if(braille_map[letter] == 'm') draw_m();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      109
	BTFSS      STATUS+0, 2
	GOTO       L_main27
	CALL       _draw_m+0
L_main27:
;final_project.c,187 :: 		if(braille_map[letter] == 'n') draw_n();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      110
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	CALL       _draw_n+0
L_main28:
;final_project.c,188 :: 		if(braille_map[letter] == 'o') draw_o();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      111
	BTFSS      STATUS+0, 2
	GOTO       L_main29
	CALL       _draw_o+0
L_main29:
;final_project.c,189 :: 		if(braille_map[letter] == 'p') draw_p();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      112
	BTFSS      STATUS+0, 2
	GOTO       L_main30
	CALL       _draw_p+0
L_main30:
;final_project.c,190 :: 		if(braille_map[letter] == 'q') draw_q();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      113
	BTFSS      STATUS+0, 2
	GOTO       L_main31
	CALL       _draw_q+0
L_main31:
;final_project.c,191 :: 		if(braille_map[letter] == 'r') draw_r();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      114
	BTFSS      STATUS+0, 2
	GOTO       L_main32
	CALL       _draw_r+0
L_main32:
;final_project.c,192 :: 		if(braille_map[letter] == 's') draw_s();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      115
	BTFSS      STATUS+0, 2
	GOTO       L_main33
	CALL       _draw_s+0
L_main33:
;final_project.c,193 :: 		if(braille_map[letter] == 't') draw_t();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      116
	BTFSS      STATUS+0, 2
	GOTO       L_main34
	CALL       _draw_t+0
L_main34:
;final_project.c,194 :: 		if(braille_map[letter] == 'u') draw_u();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      117
	BTFSS      STATUS+0, 2
	GOTO       L_main35
	CALL       _draw_u+0
L_main35:
;final_project.c,195 :: 		if(braille_map[letter] == 'v') draw_v();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      118
	BTFSS      STATUS+0, 2
	GOTO       L_main36
	CALL       _draw_v+0
L_main36:
;final_project.c,196 :: 		if(braille_map[letter] == 'w') draw_w();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      119
	BTFSS      STATUS+0, 2
	GOTO       L_main37
	CALL       _draw_w+0
L_main37:
;final_project.c,197 :: 		if(braille_map[letter] == 'x') draw_x();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      120
	BTFSS      STATUS+0, 2
	GOTO       L_main38
	CALL       _draw_x+0
L_main38:
;final_project.c,198 :: 		if(braille_map[letter] == 'y') draw_y();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      121
	BTFSS      STATUS+0, 2
	GOTO       L_main39
	CALL       _draw_y+0
L_main39:
;final_project.c,199 :: 		if(braille_map[letter] == 'z') draw_z();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      122
	BTFSS      STATUS+0, 2
	GOTO       L_main40
	CALL       _draw_z+0
L_main40:
;final_project.c,201 :: 		letter = 0x00;
	CLRF       _letter+0
;final_project.c,204 :: 		while ((PORTD & 0x40) == 0x40);
L_main41:
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main42
	GOTO       L_main41
L_main42:
;final_project.c,205 :: 		Delay(50);
	MOVLW      50
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,206 :: 		}
L_main7:
;final_project.c,208 :: 		if ((PORTD & 0x01) == 0x01) letter |= 0x01; // Set bit 0
	MOVLW      1
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main43
	BSF        _letter+0, 0
L_main43:
;final_project.c,209 :: 		if ((PORTD & 0x02) == 0x02) letter |= 0x02; // Set bit 1
	MOVLW      2
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main44
	BSF        _letter+0, 1
L_main44:
;final_project.c,210 :: 		if ((PORTD & 0x04) == 0x04) letter |= 0x04; // Set bit 2
	MOVLW      4
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main45
	BSF        _letter+0, 2
L_main45:
;final_project.c,211 :: 		if ((PORTD & 0x08) == 0x08) letter |= 0x08; // Set bit 3
	MOVLW      8
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      8
	BTFSS      STATUS+0, 2
	GOTO       L_main46
	BSF        _letter+0, 3
L_main46:
;final_project.c,212 :: 		if ((PORTD & 0x10) == 0x10) letter |= 0x10; // Set bit 4
	MOVLW      16
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      16
	BTFSS      STATUS+0, 2
	GOTO       L_main47
	BSF        _letter+0, 4
L_main47:
;final_project.c,213 :: 		if ((PORTD & 0x20) == 0x20) letter |= 0x20; // Set bit 5
	MOVLW      32
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_main48
	BSF        _letter+0, 5
L_main48:
;final_project.c,214 :: 		if ((PORTD & 0x80) == 0x80) letter = 0x00;  // Clear all bits
	MOVLW      128
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      128
	BTFSS      STATUS+0, 2
	GOTO       L_main49
	CLRF       _letter+0
L_main49:
;final_project.c,215 :: 		}
	GOTO       L_main5
;final_project.c,217 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_pen_up:

;final_project.c,220 :: 		void pen_up(void) {
;final_project.c,221 :: 		angle = SERVO_UP;
	MOVLW      8
	MOVWF      _angle+0
	MOVLW      7
	MOVWF      _angle+1
;final_project.c,222 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,223 :: 		}
L_end_pen_up:
	RETURN
; end of _pen_up

_pen_down:

;final_project.c,225 :: 		void pen_down(void) {
;final_project.c,226 :: 		angle = SERVO_DOWN;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;final_project.c,227 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,228 :: 		}
L_end_pen_down:
	RETURN
; end of _pen_down

_draw_a:

;final_project.c,230 :: 		void draw_a(void) {
;final_project.c,231 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,232 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,233 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,234 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,235 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,236 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,237 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,238 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,239 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,240 :: 		}
L_end_draw_a:
	RETURN
; end of _draw_a

_draw_b:

;final_project.c,242 :: 		void draw_b(void) { //NO CURVES
;final_project.c,243 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,244 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,245 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,246 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,247 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,248 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,249 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,250 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,251 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,252 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,253 :: 		}
L_end_draw_b:
	RETURN
; end of _draw_b

_draw_c:

;final_project.c,255 :: 		void draw_c(void) {
;final_project.c,256 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,257 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,258 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,259 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,260 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,261 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,262 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,263 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,264 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,265 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,266 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,267 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,268 :: 		}
L_end_draw_c:
	RETURN
; end of _draw_c

_draw_d:

;final_project.c,270 :: 		void draw_d(void) {
;final_project.c,271 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,272 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,273 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,274 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,275 :: 		}
L_end_draw_d:
	RETURN
; end of _draw_d

_draw_e:

;final_project.c,277 :: 		void draw_e(void) {
;final_project.c,278 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,279 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,280 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,281 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,282 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,283 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,284 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,285 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,286 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,287 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,288 :: 		}
L_end_draw_e:
	RETURN
; end of _draw_e

_draw_f:

;final_project.c,290 :: 		void draw_f(void) {
;final_project.c,291 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,292 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,293 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,294 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,295 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,296 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,297 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,298 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,299 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,300 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,301 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,302 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,303 :: 		}
L_end_draw_f:
	RETURN
; end of _draw_f

_draw_g:

;final_project.c,305 :: 		void draw_g(void) {
;final_project.c,306 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,307 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,308 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,309 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,310 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,311 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,312 :: 		}
L_end_draw_g:
	RETURN
; end of _draw_g

_draw_h:

;final_project.c,314 :: 		void draw_h(void) {
;final_project.c,315 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,316 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,317 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,318 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,319 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,320 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,321 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,322 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,323 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,324 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,325 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,326 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,327 :: 		}
L_end_draw_h:
	RETURN
; end of _draw_h

_draw_i:

;final_project.c,329 :: 		void draw_i(void) { //TODO return to origin
;final_project.c,330 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,331 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,332 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,333 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,334 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,335 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,336 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,337 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,338 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,339 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,340 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,341 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,342 :: 		}
L_end_draw_i:
	RETURN
; end of _draw_i

_draw_j:

;final_project.c,344 :: 		void draw_j(void) {
;final_project.c,345 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,346 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,347 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,348 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,349 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,350 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,351 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,352 :: 		}
L_end_draw_j:
	RETURN
; end of _draw_j

_draw_k:

;final_project.c,354 :: 		void draw_k(void) {
;final_project.c,355 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,356 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,357 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,358 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,359 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,360 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,361 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,362 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,363 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,364 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,365 :: 		}
L_end_draw_k:
	RETURN
; end of _draw_k

_draw_l:

;final_project.c,367 :: 		void draw_l(void) {
;final_project.c,368 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,369 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,370 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,371 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,372 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,373 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,374 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,375 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,376 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,383 :: 		}
L_end_draw_l:
	RETURN
; end of _draw_l

_draw_m:

;final_project.c,385 :: 		void draw_m(void) {
;final_project.c,386 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,387 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,388 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,389 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,390 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,391 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,392 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,393 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,394 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,395 :: 		}
L_end_draw_m:
	RETURN
; end of _draw_m

_draw_n:

;final_project.c,397 :: 		void draw_n(void) {
;final_project.c,398 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,399 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,400 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,401 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,402 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,403 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,404 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,405 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,406 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,407 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,408 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,409 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,410 :: 		}
L_end_draw_n:
	RETURN
; end of _draw_n

_draw_o:

;final_project.c,412 :: 		void draw_o(void) {
;final_project.c,413 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,414 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,415 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,416 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,417 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,418 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,419 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,420 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,421 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,422 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,423 :: 		}
L_end_draw_o:
	RETURN
; end of _draw_o

_draw_p:

;final_project.c,425 :: 		void draw_p(void) {
;final_project.c,426 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,427 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,428 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,429 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,430 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,431 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,432 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,433 :: 		}
L_end_draw_p:
	RETURN
; end of _draw_p

_draw_q:

;final_project.c,435 :: 		void draw_q(void) {
;final_project.c,436 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,437 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,438 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,439 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,440 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,441 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,442 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,443 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,444 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,445 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,446 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,447 :: 		}
L_end_draw_q:
	RETURN
; end of _draw_q

_draw_r:

;final_project.c,449 :: 		void draw_r(void) {
;final_project.c,450 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,451 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,452 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,453 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,454 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,455 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,456 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,457 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,458 :: 		}
L_end_draw_r:
	RETURN
; end of _draw_r

_draw_s:

;final_project.c,460 :: 		void draw_s(void) {
;final_project.c,461 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,462 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,463 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,464 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,465 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,466 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,467 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,468 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,469 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,470 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,471 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,472 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,473 :: 		}
L_end_draw_s:
	RETURN
; end of _draw_s

_draw_t:

;final_project.c,475 :: 		void draw_t(void){
;final_project.c,476 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,477 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,478 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,479 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,480 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,481 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,482 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,483 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,484 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,485 :: 		}
L_end_draw_t:
	RETURN
; end of _draw_t

_draw_u:

;final_project.c,487 :: 		void draw_u(void) {
;final_project.c,488 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,489 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,490 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,491 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,492 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,493 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,494 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,495 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,496 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,497 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,498 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,499 :: 		}
L_end_draw_u:
	RETURN
; end of _draw_u

_draw_v:

;final_project.c,501 :: 		void draw_v(void) {
;final_project.c,502 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,503 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,504 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,505 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,506 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,507 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,508 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,509 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,510 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,511 :: 		}
L_end_draw_v:
	RETURN
; end of _draw_v

_draw_x:

;final_project.c,513 :: 		void draw_x(void) {
;final_project.c,514 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,515 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,516 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,517 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,518 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,519 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,520 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,521 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,522 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,523 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,524 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,525 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,526 :: 		}
L_end_draw_x:
	RETURN
; end of _draw_x

_draw_w:

;final_project.c,528 :: 		void draw_w(void) {
;final_project.c,529 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,530 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,531 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,532 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,533 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,534 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,535 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,536 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,537 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,538 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,539 :: 		}
L_end_draw_w:
	RETURN
; end of _draw_w

_draw_y:

;final_project.c,541 :: 		void draw_y(void) {
;final_project.c,542 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,543 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,544 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,545 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,546 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,547 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,548 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,549 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,550 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,551 :: 		}
L_end_draw_y:
	RETURN
; end of _draw_y

_draw_z:

;final_project.c,553 :: 		void draw_z(void) {
;final_project.c,554 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,555 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,556 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,557 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,558 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,559 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,560 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,561 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,562 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,563 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,564 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,565 :: 		}
L_end_draw_z:
	RETURN
; end of _draw_z

_draw_space:

;final_project.c,568 :: 		void draw_space(void) {
;final_project.c,569 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,570 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,571 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,572 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,573 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,574 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,575 :: 		}
L_end_draw_space:
	RETURN
; end of _draw_space

_move_next_letter:

;final_project.c,577 :: 		void move_next_letter(void) {
;final_project.c,578 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,579 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,580 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,581 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,582 :: 		}
L_end_move_next_letter:
	RETURN
; end of _move_next_letter

_enter_new_line:

;final_project.c,584 :: 		void enter_new_line(void) {
;final_project.c,585 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,586 :: 		for(times = 0; times<2*(letters_per_line-1); times++) draw_left(100);
	CLRF       _times+0
L_enter_new_line50:
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
	GOTO       L_enter_new_line51
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
	INCF       _times+0, 1
	GOTO       L_enter_new_line50
L_enter_new_line51:
;final_project.c,587 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,588 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,589 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,590 :: 		}
L_end_enter_new_line:
	RETURN
; end of _enter_new_line
