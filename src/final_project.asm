
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;final_project.c,76 :: 		void interrupt(void) {
;final_project.c,78 :: 		if (INTCON & 0x04) {    // STEPPER MOTOR 1 Toggle
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;final_project.c,79 :: 		PORTC ^= 0x02;      // toggle RC1
	MOVLW      2
	XORWF      PORTC+0, 1
;final_project.c,80 :: 		PORTC ^= 0x08;      // toggle RC3
	MOVLW      8
	XORWF      PORTC+0, 1
;final_project.c,81 :: 		INTCON &= ~0x04;    // clear T0IF
	BCF        INTCON+0, 2
;final_project.c,82 :: 		TMR0 = 150 + ((size - 50) * (250 - 150)) / (150 - 50);
	MOVLW      50
	SUBWF      _size+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	ADDLW      150
	MOVWF      TMR0+0
;final_project.c,86 :: 		count_overflow++;
	INCF       _count_overflow+0, 1
;final_project.c,87 :: 		}
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
;final_project.c,97 :: 		if(HL) {                                // high
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
;final_project.c,107 :: 		CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
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
;final_project.c,108 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;final_project.c,109 :: 		CCP1CON = 0x08;             // compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;final_project.c,110 :: 		HL = 1;                     //next time High
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,111 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,112 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,113 :: 		}
L_interrupt4:
;final_project.c,115 :: 		PIR1 = PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;final_project.c,116 :: 		}
L_interrupt2:
;final_project.c,117 :: 		}
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

;final_project.c,119 :: 		void main() {
;final_project.c,120 :: 		TRISC = 0x00;  // Set all PORTC pins as output
	CLRF       TRISC+0
;final_project.c,121 :: 		PORTC = 0xC0;  // Clear PORTC, set enables to 0 active low
	MOVLW      192
	MOVWF      PORTC+0
;final_project.c,123 :: 		TRISD = 0xFF;
	MOVLW      255
	MOVWF      TRISD+0
;final_project.c,124 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;final_project.c,128 :: 		ATD_init();
	CALL       _ATD_init+0
;final_project.c,129 :: 		Timer0_Init();  // Initialize Timer0
	CALL       _Timer0_Init+0
;final_project.c,131 :: 		Timer1_Init();  // Initialize Timer1
	CALL       _Timer1_Init+0
;final_project.c,132 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;final_project.c,134 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,135 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,139 :: 		INTCON |= 0x80; // Global Interrupt Enable (GIE)
	BSF        INTCON+0, 7
;final_project.c,140 :: 		INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)
	BSF        INTCON+0, 6
;final_project.c,143 :: 		while (1) {
L_main5:
;final_project.c,145 :: 		size = ATD_read(0);  //0-255
	CLRF       FARG_ATD_read_channel+0
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _size+0
;final_project.c,146 :: 		size = 50 + ((size * (150 - 50)) / 242); //  50-150
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
	MOVLW      50
	ADDWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _size+0
;final_project.c,147 :: 		letters_per_line = MAX_LETTERS_PER_LINE - ((size - 50) * (MAX_LETTERS_PER_LINE - MIN_LETTERS_PER_LINE)) / (150 - 50);
	MOVLW      50
	SUBWF      R0+0, 1
	CLRF       R0+1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	SUBLW      20
	MOVWF      _letters_per_line+0
;final_project.c,155 :: 		if (previous_letter != braille_map[letter]) {
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       _previous_letter+0, 0
	XORWF      INDF+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main7
;final_project.c,156 :: 		update_current_letter_display(braille_map[letter]);
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_update_current_letter_display_current_letter+0
	CALL       _update_current_letter_display+0
;final_project.c,157 :: 		previous_letter = braille_map[letter];
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      _previous_letter+0
;final_project.c,158 :: 		}
L_main7:
;final_project.c,159 :: 		update_current_size_display(size);  // Update size display
	MOVF       _size+0, 0
	MOVWF      FARG_update_current_size_display_input_size+0
	CLRF       FARG_update_current_size_display_input_size+1
	CALL       _update_current_size_display+0
;final_project.c,161 :: 		if ((PORTD & 0x40) == 0x40) {  // check if enter is pressed
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main8
;final_project.c,162 :: 		Delay(50);
	MOVLW      50
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,163 :: 		if (current_column > letters_per_line) { // move to next row
	MOVF       _current_column+0, 0
	SUBWF      _letters_per_line+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main9
;final_project.c,164 :: 		current_row++;
	INCF       _current_row+0, 1
;final_project.c,165 :: 		current_column = 1;
	MOVLW      1
	MOVWF      _current_column+0
;final_project.c,167 :: 		if (current_row > 3) { // clear screen after 3rd row is full
	MOVF       _current_row+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_main10
;final_project.c,168 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,169 :: 		update_current_letter_display(braille_map[letter]);
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_update_current_letter_display_current_letter+0
	CALL       _update_current_letter_display+0
;final_project.c,170 :: 		current_row = 1;
	MOVLW      1
	MOVWF      _current_row+0
;final_project.c,171 :: 		}
L_main10:
;final_project.c,172 :: 		}
L_main9:
;final_project.c,174 :: 		Lcd_Chr(current_row, current_column, braille_map[letter]);
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
;final_project.c,176 :: 		if (braille_map[letter] == 'A') draw_a();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      65
	BTFSS      STATUS+0, 2
	GOTO       L_main11
	CALL       _draw_a+0
L_main11:
;final_project.c,177 :: 		if (braille_map[letter] == 'B') draw_b();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      66
	BTFSS      STATUS+0, 2
	GOTO       L_main12
	CALL       _draw_b+0
L_main12:
;final_project.c,178 :: 		if (braille_map[letter] == 'C') draw_c();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      67
	BTFSS      STATUS+0, 2
	GOTO       L_main13
	CALL       _draw_c+0
L_main13:
;final_project.c,179 :: 		if (braille_map[letter] == 'D') draw_d();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      68
	BTFSS      STATUS+0, 2
	GOTO       L_main14
	CALL       _draw_d+0
L_main14:
;final_project.c,180 :: 		if (braille_map[letter] == 'E') draw_e();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      69
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	CALL       _draw_e+0
L_main15:
;final_project.c,181 :: 		if (braille_map[letter] == 'F') draw_f();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      70
	BTFSS      STATUS+0, 2
	GOTO       L_main16
	CALL       _draw_f+0
L_main16:
;final_project.c,182 :: 		if (braille_map[letter] == 'G') draw_g();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      71
	BTFSS      STATUS+0, 2
	GOTO       L_main17
	CALL       _draw_g+0
L_main17:
;final_project.c,183 :: 		if (braille_map[letter] == 'H') draw_h();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      72
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	CALL       _draw_h+0
L_main18:
;final_project.c,184 :: 		if (braille_map[letter] == 'I') draw_i();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      73
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	CALL       _draw_i+0
L_main19:
;final_project.c,185 :: 		if (braille_map[letter] == 'J') draw_j();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      74
	BTFSS      STATUS+0, 2
	GOTO       L_main20
	CALL       _draw_j+0
L_main20:
;final_project.c,186 :: 		if (braille_map[letter] == 'K') draw_k();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      75
	BTFSS      STATUS+0, 2
	GOTO       L_main21
	CALL       _draw_k+0
L_main21:
;final_project.c,187 :: 		if (braille_map[letter] == 'L') draw_l();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      76
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	CALL       _draw_l+0
L_main22:
;final_project.c,188 :: 		if (braille_map[letter] == 'M') draw_m();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      77
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	CALL       _draw_m+0
L_main23:
;final_project.c,189 :: 		if (braille_map[letter] == 'N') draw_n();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      78
	BTFSS      STATUS+0, 2
	GOTO       L_main24
	CALL       _draw_n+0
L_main24:
;final_project.c,190 :: 		if (braille_map[letter] == 'O') draw_o();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main25
	CALL       _draw_o+0
L_main25:
;final_project.c,191 :: 		if (braille_map[letter] == 'P') draw_p();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      80
	BTFSS      STATUS+0, 2
	GOTO       L_main26
	CALL       _draw_p+0
L_main26:
;final_project.c,192 :: 		if (braille_map[letter] == 'Q') draw_q();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      81
	BTFSS      STATUS+0, 2
	GOTO       L_main27
	CALL       _draw_q+0
L_main27:
;final_project.c,193 :: 		if (braille_map[letter] == 'R') draw_r();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      82
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	CALL       _draw_r+0
L_main28:
;final_project.c,194 :: 		if (braille_map[letter] == 'S') draw_s();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      83
	BTFSS      STATUS+0, 2
	GOTO       L_main29
	CALL       _draw_s+0
L_main29:
;final_project.c,195 :: 		if (braille_map[letter] == 'T') draw_t();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      84
	BTFSS      STATUS+0, 2
	GOTO       L_main30
	CALL       _draw_t+0
L_main30:
;final_project.c,196 :: 		if (braille_map[letter] == 'U') draw_u();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      85
	BTFSS      STATUS+0, 2
	GOTO       L_main31
	CALL       _draw_u+0
L_main31:
;final_project.c,197 :: 		if (braille_map[letter] == 'V') draw_v();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      86
	BTFSS      STATUS+0, 2
	GOTO       L_main32
	CALL       _draw_v+0
L_main32:
;final_project.c,198 :: 		if (braille_map[letter] == 'W') draw_w();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      87
	BTFSS      STATUS+0, 2
	GOTO       L_main33
	CALL       _draw_w+0
L_main33:
;final_project.c,199 :: 		if (braille_map[letter] == 'X') draw_x();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      88
	BTFSS      STATUS+0, 2
	GOTO       L_main34
	CALL       _draw_x+0
L_main34:
;final_project.c,200 :: 		if (braille_map[letter] == 'Y') draw_y();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      89
	BTFSS      STATUS+0, 2
	GOTO       L_main35
	CALL       _draw_y+0
L_main35:
;final_project.c,201 :: 		if (braille_map[letter] == 'Z') draw_z();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      90
	BTFSS      STATUS+0, 2
	GOTO       L_main36
	CALL       _draw_z+0
L_main36:
;final_project.c,202 :: 		if (braille_map[letter] == '\n') {
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main37
;final_project.c,203 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,204 :: 		current_column = 1;
	MOVLW      1
	MOVWF      _current_column+0
;final_project.c,205 :: 		current_row++;
	INCF       _current_row+0, 1
;final_project.c,206 :: 		if (current_row > 3) { // clear screen after 3rd row is full
	MOVF       _current_row+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_main38
;final_project.c,207 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,208 :: 		current_row = 1;
	MOVLW      1
	MOVWF      _current_row+0
;final_project.c,209 :: 		}
L_main38:
;final_project.c,210 :: 		}
L_main37:
;final_project.c,211 :: 		if (braille_map[letter] == ' ') draw_space();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_main39
	CALL       _draw_space+0
L_main39:
;final_project.c,213 :: 		if (braille_map[letter] != '\n') {
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_main40
;final_project.c,214 :: 		move_next_letter();
	CALL       _move_next_letter+0
;final_project.c,215 :: 		current_column++; // Move to the next column
	INCF       _current_column+0, 1
;final_project.c,216 :: 		}
L_main40:
;final_project.c,218 :: 		letter = 0x00; // Clear letter
	CLRF       _letter+0
;final_project.c,220 :: 		while ((PORTD & 0x40));
L_main41:
	BTFSS      PORTD+0, 6
	GOTO       L_main42
	GOTO       L_main41
L_main42:
;final_project.c,221 :: 		Delay(50);
	MOVLW      50
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,222 :: 		}
L_main8:
;final_project.c,224 :: 		if (PORTD & 0x01) letter |= 0x01; // Set bit 0
	BTFSS      PORTD+0, 0
	GOTO       L_main43
	BSF        _letter+0, 0
L_main43:
;final_project.c,225 :: 		if (PORTD & 0x02) letter |= 0x02; // Set bit 1
	BTFSS      PORTD+0, 1
	GOTO       L_main44
	BSF        _letter+0, 1
L_main44:
;final_project.c,226 :: 		if (PORTD & 0x04) letter |= 0x04; // Set bit 2
	BTFSS      PORTD+0, 2
	GOTO       L_main45
	BSF        _letter+0, 2
L_main45:
;final_project.c,227 :: 		if (PORTD & 0x08) letter |= 0x08; // Set bit 3
	BTFSS      PORTD+0, 3
	GOTO       L_main46
	BSF        _letter+0, 3
L_main46:
;final_project.c,228 :: 		if (PORTD & 0x10) letter |= 0x10; // Set bit 4
	BTFSS      PORTD+0, 4
	GOTO       L_main47
	BSF        _letter+0, 4
L_main47:
;final_project.c,229 :: 		if (PORTD & 0x20) letter |= 0x20; // Set bit 5
	BTFSS      PORTD+0, 5
	GOTO       L_main48
	BSF        _letter+0, 5
L_main48:
;final_project.c,230 :: 		if (PORTD & 0x80) letter = 0x00;  // Clear all bits
	BTFSS      PORTD+0, 7
	GOTO       L_main49
	CLRF       _letter+0
L_main49:
;final_project.c,232 :: 		}
	GOTO       L_main5
;final_project.c,234 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_pen_up:

;final_project.c,237 :: 		void pen_up(void) {
;final_project.c,238 :: 		angle = SERVO_UP;
	MOVLW      8
	MOVWF      _angle+0
	MOVLW      7
	MOVWF      _angle+1
;final_project.c,239 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,240 :: 		}
L_end_pen_up:
	RETURN
; end of _pen_up

_pen_down:

;final_project.c,242 :: 		void pen_down(void) {
;final_project.c,243 :: 		angle = SERVO_DOWN;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;final_project.c,244 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,245 :: 		}
L_end_pen_down:
	RETURN
; end of _pen_down

_draw_a:

;final_project.c,247 :: 		void draw_a(void) {
;final_project.c,248 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,249 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,250 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,251 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,252 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,253 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,254 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,255 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,256 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,257 :: 		}
L_end_draw_a:
	RETURN
; end of _draw_a

_draw_b:

;final_project.c,259 :: 		void draw_b(void) { //NO CURVES
;final_project.c,260 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,261 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,262 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,263 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,264 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,265 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,266 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,267 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,268 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,269 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,270 :: 		}
L_end_draw_b:
	RETURN
; end of _draw_b

_draw_c:

;final_project.c,272 :: 		void draw_c(void) {
;final_project.c,273 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,274 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,275 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,276 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,277 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,278 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,279 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,280 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,281 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,282 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,283 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,284 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,285 :: 		}
L_end_draw_c:
	RETURN
; end of _draw_c

_draw_d:

;final_project.c,287 :: 		void draw_d(void) {
;final_project.c,288 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,289 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,290 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,291 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,292 :: 		}
L_end_draw_d:
	RETURN
; end of _draw_d

_draw_e:

;final_project.c,294 :: 		void draw_e(void) {
;final_project.c,295 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,296 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,297 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,298 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,299 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,300 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,301 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,302 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,303 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,304 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,305 :: 		}
L_end_draw_e:
	RETURN
; end of _draw_e

_draw_f:

;final_project.c,307 :: 		void draw_f(void) {
;final_project.c,308 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,309 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,310 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,311 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,312 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,313 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,314 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,315 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,316 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,317 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,318 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,319 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,320 :: 		}
L_end_draw_f:
	RETURN
; end of _draw_f

_draw_g:

;final_project.c,322 :: 		void draw_g(void) {
;final_project.c,323 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,324 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,325 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,326 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,327 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,328 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,329 :: 		}
L_end_draw_g:
	RETURN
; end of _draw_g

_draw_h:

;final_project.c,331 :: 		void draw_h(void) {
;final_project.c,332 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,333 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,334 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,335 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,336 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,337 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,338 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,339 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,340 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,341 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,342 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,343 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,344 :: 		}
L_end_draw_h:
	RETURN
; end of _draw_h

_draw_i:

;final_project.c,346 :: 		void draw_i(void) { //TODO return to origin
;final_project.c,347 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,348 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,349 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,350 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,351 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,352 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,353 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,354 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,355 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,356 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,357 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,358 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,359 :: 		}
L_end_draw_i:
	RETURN
; end of _draw_i

_draw_j:

;final_project.c,361 :: 		void draw_j(void) {
;final_project.c,362 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,363 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,364 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,365 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,366 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,367 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,368 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,369 :: 		}
L_end_draw_j:
	RETURN
; end of _draw_j

_draw_k:

;final_project.c,371 :: 		void draw_k(void) {
;final_project.c,372 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,373 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,374 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,375 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,376 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,377 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,378 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,379 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,380 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,381 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,382 :: 		}
L_end_draw_k:
	RETURN
; end of _draw_k

_draw_l:

;final_project.c,384 :: 		void draw_l(void) {
;final_project.c,385 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,386 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,387 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,388 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,389 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,390 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,391 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,392 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,393 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,400 :: 		}
L_end_draw_l:
	RETURN
; end of _draw_l

_draw_m:

;final_project.c,402 :: 		void draw_m(void) {
;final_project.c,403 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,404 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,405 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,406 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,407 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,408 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,409 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,410 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,411 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,412 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,413 :: 		}
L_end_draw_m:
	RETURN
; end of _draw_m

_draw_n:

;final_project.c,415 :: 		void draw_n(void) {
;final_project.c,416 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,417 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,418 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,419 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,420 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,421 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,422 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,423 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,424 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,425 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,426 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,427 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,428 :: 		}
L_end_draw_n:
	RETURN
; end of _draw_n

_draw_o:

;final_project.c,430 :: 		void draw_o(void) {
;final_project.c,431 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,432 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,433 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,434 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,435 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,436 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,437 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,438 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,439 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,440 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,441 :: 		}
L_end_draw_o:
	RETURN
; end of _draw_o

_draw_p:

;final_project.c,443 :: 		void draw_p(void) {
;final_project.c,444 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,445 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,446 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,447 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,448 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,449 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,450 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,451 :: 		}
L_end_draw_p:
	RETURN
; end of _draw_p

_draw_q:

;final_project.c,453 :: 		void draw_q(void) {
;final_project.c,454 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,455 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,456 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,457 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,458 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,459 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,460 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,461 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,462 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,463 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,464 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,465 :: 		}
L_end_draw_q:
	RETURN
; end of _draw_q

_draw_r:

;final_project.c,467 :: 		void draw_r(void) {
;final_project.c,468 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,469 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,470 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,471 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,472 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,473 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,474 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,475 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,476 :: 		}
L_end_draw_r:
	RETURN
; end of _draw_r

_draw_s:

;final_project.c,478 :: 		void draw_s(void) {
;final_project.c,479 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,480 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,481 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,482 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,483 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,484 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,485 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,486 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,487 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,488 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,489 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,490 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,491 :: 		}
L_end_draw_s:
	RETURN
; end of _draw_s

_draw_t:

;final_project.c,493 :: 		void draw_t(void){
;final_project.c,494 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,495 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,496 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,497 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,498 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,499 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,500 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,501 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,502 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,503 :: 		}
L_end_draw_t:
	RETURN
; end of _draw_t

_draw_u:

;final_project.c,505 :: 		void draw_u(void) {
;final_project.c,506 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,507 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,508 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,509 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,510 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,511 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,512 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,513 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,514 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,515 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,516 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,517 :: 		}
L_end_draw_u:
	RETURN
; end of _draw_u

_draw_v:

;final_project.c,519 :: 		void draw_v(void) {
;final_project.c,520 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,521 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,522 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,523 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,524 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,525 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,526 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,527 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,528 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,529 :: 		}
L_end_draw_v:
	RETURN
; end of _draw_v

_draw_x:

;final_project.c,531 :: 		void draw_x(void) {
;final_project.c,532 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,533 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,534 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,535 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,536 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,537 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,538 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,539 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,540 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,541 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,542 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,543 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,544 :: 		}
L_end_draw_x:
	RETURN
; end of _draw_x

_draw_w:

;final_project.c,546 :: 		void draw_w(void) {
;final_project.c,547 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,548 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,549 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,550 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,551 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,552 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,553 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,554 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,555 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,556 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,557 :: 		}
L_end_draw_w:
	RETURN
; end of _draw_w

_draw_y:

;final_project.c,559 :: 		void draw_y(void) {
;final_project.c,560 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,561 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,562 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,563 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,564 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,565 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,566 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,567 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,568 :: 		draw_up(100);
	MOVLW      100
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,569 :: 		}
L_end_draw_y:
	RETURN
; end of _draw_y

_draw_z:

;final_project.c,571 :: 		void draw_z(void) {
;final_project.c,572 :: 		draw_up_right(100);
	MOVLW      100
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
;final_project.c,573 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,574 :: 		draw_left(100);
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,575 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,576 :: 		draw_down_right(100);
	MOVLW      100
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,577 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,578 :: 		draw_down_left(100);
	MOVLW      100
	MOVWF      FARG_draw_down_left_speed+0
	CALL       _draw_down_left+0
;final_project.c,579 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,580 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,581 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,582 :: 		draw_up_left(100);
	MOVLW      100
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,583 :: 		}
L_end_draw_z:
	RETURN
; end of _draw_z

_draw_space:

;final_project.c,586 :: 		void draw_space(void) {
;final_project.c,593 :: 		}
L_end_draw_space:
	RETURN
; end of _draw_space

_move_next_letter:

;final_project.c,595 :: 		void move_next_letter(void) {
;final_project.c,596 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,597 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,598 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,599 :: 		draw_right(100);
	MOVLW      100
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,600 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,601 :: 		}
L_end_move_next_letter:
	RETURN
; end of _move_next_letter

_enter_new_line:

;final_project.c,604 :: 		void enter_new_line(void) {
;final_project.c,605 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,606 :: 		for(times = 0; times<2*(current_column)+2; times++) draw_left(100);
	CLRF       _times+0
L_enter_new_line50:
	MOVF       _current_column+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVLW      2
	ADDWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R2+1
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R2+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__enter_new_line87
	MOVF       R2+0, 0
	SUBWF      _times+0, 0
L__enter_new_line87:
	BTFSC      STATUS+0, 0
	GOTO       L_enter_new_line51
	MOVLW      100
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
	INCF       _times+0, 1
	GOTO       L_enter_new_line50
L_enter_new_line51:
;final_project.c,607 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,608 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,609 :: 		draw_down(100);
	MOVLW      100
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,610 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,611 :: 		}
L_end_enter_new_line:
	RETURN
; end of _enter_new_line
