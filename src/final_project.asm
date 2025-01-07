
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;final_project.c,57 :: 		void interrupt(void) {
;final_project.c,59 :: 		if (INTCON & 0x04) {    // STEPPER MOTOR 1 Toggle
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;final_project.c,60 :: 		PORTC ^= 0x02;      // Toggle RC1 (example action for Timer0)
	MOVLW      2
	XORWF      PORTC+0, 1
;final_project.c,61 :: 		INTCON &= ~0x04;    // Clear T0IF
	BCF        INTCON+0, 2
;final_project.c,62 :: 		TMR0 = 0xF0;        // Reload Timer0 if necessary
	MOVLW      240
	MOVWF      TMR0+0
;final_project.c,63 :: 		}
L_interrupt0:
;final_project.c,65 :: 		if (PIR1 & 0x02) {      // STEPPER MOTOR 2 Toggle
	BTFSS      PIR1+0, 1
	GOTO       L_interrupt1
;final_project.c,66 :: 		PORTC ^= 0x08;      // Toggle RC3 (example action for Timer2)
	MOVLW      8
	XORWF      PORTC+0, 1
;final_project.c,67 :: 		PIR1 &= ~0x02;      // Clear TMR2IF
	BCF        PIR1+0, 1
;final_project.c,68 :: 		}
L_interrupt1:
;final_project.c,70 :: 		if(PIR1 & 0x04){                                           // CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt2
;final_project.c,71 :: 		if(HL){                                // high
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt3
;final_project.c,72 :: 		CCPR1H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;final_project.c,73 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;final_project.c,74 :: 		HL = 0;                      // next time low
	CLRF       _HL+0
;final_project.c,75 :: 		CCP1CON = 0x09;              // compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP1CON+0
;final_project.c,76 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,77 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,78 :: 		}
	GOTO       L_interrupt4
L_interrupt3:
;final_project.c,80 :: 		CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
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
;final_project.c,81 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;final_project.c,82 :: 		CCP1CON = 0x08;             // compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;final_project.c,83 :: 		HL = 1;                     //next time High
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,84 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,85 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,86 :: 		}
L_interrupt4:
;final_project.c,88 :: 		PIR1 = PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;final_project.c,89 :: 		}
L_interrupt2:
;final_project.c,92 :: 		}
L_end_interrupt:
L__interrupt38:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;final_project.c,94 :: 		void main() {
;final_project.c,95 :: 		TRISC = 0x00;  // Set all PORTC pins as output
	CLRF       TRISC+0
;final_project.c,96 :: 		PORTC = 0xC0;  // Clear PORTC, set enables to 0 active low
	MOVLW      192
	MOVWF      PORTC+0
;final_project.c,97 :: 		ATD_init();
	CALL       _ATD_init+0
;final_project.c,100 :: 		TRISD = 0xFF;
	MOVLW      255
	MOVWF      TRISD+0
;final_project.c,103 :: 		Timer0_Init();  // Initialize Timer0
	CALL       _Timer0_Init+0
;final_project.c,104 :: 		Timer2_Init();  // Initialize Timer2
	CALL       _Timer2_Init+0
;final_project.c,105 :: 		Timer1_Init();  // Initialize Timer1
	CALL       _Timer1_Init+0
;final_project.c,107 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;final_project.c,108 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,109 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,113 :: 		INTCON |= 0x80; // Global Interrupt Enable (GIE)
	BSF        INTCON+0, 7
;final_project.c,114 :: 		INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)
	BSF        INTCON+0, 6
;final_project.c,116 :: 		while (1) {
L_main5:
;final_project.c,118 :: 		speed = ATD_read(0);
	CLRF       FARG_ATD_read_channel+0
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _speed+0
;final_project.c,121 :: 		if ((PORTD & 0x40) == 0x40) {  // Check if enter is pressed
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main7
;final_project.c,122 :: 		delay_ms(50);
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
;final_project.c,123 :: 		if (char_count == LETTER_PER_LINE) {
	MOVF       _char_count+0, 0
	XORLW      20
	BTFSS      STATUS+0, 2
	GOTO       L_main9
;final_project.c,124 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,125 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,126 :: 		}
	GOTO       L_main10
L_main9:
;final_project.c,127 :: 		else if(char_count == 2*LETTER_PER_LINE) {
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
	MOVLW      40
	XORWF      _char_count+0, 0
L__main40:
	BTFSS      STATUS+0, 2
	GOTO       L_main11
;final_project.c,128 :: 		Lcd_Cmd(_LCD_THIRD_ROW);
	MOVLW      148
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,129 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,130 :: 		}
	GOTO       L_main12
L_main11:
;final_project.c,131 :: 		else if(char_count == 3*LETTER_PER_LINE) {
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main41
	MOVLW      60
	XORWF      _char_count+0, 0
L__main41:
	BTFSS      STATUS+0, 2
	GOTO       L_main13
;final_project.c,132 :: 		Lcd_Cmd(_LCD_FOURTH_ROW);
	MOVLW      212
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,133 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,134 :: 		}
	GOTO       L_main14
L_main13:
;final_project.c,135 :: 		else if(char_count == 4*LETTER_PER_LINE){
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main42
	MOVLW      80
	XORWF      _char_count+0, 0
L__main42:
	BTFSS      STATUS+0, 2
	GOTO       L_main15
;final_project.c,136 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,137 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,139 :: 		}
L_main15:
L_main14:
L_main12:
L_main10:
;final_project.c,140 :: 		Lcd_Chr_Cp(braille_map[letter]); // Display character on LCD
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;final_project.c,141 :: 		char_count++;
	INCF       _char_count+0, 1
;final_project.c,143 :: 		if(braille_map[letter] == 'a') draw_a();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      97
	BTFSS      STATUS+0, 2
	GOTO       L_main16
	CALL       _draw_a+0
L_main16:
;final_project.c,144 :: 		if(braille_map[letter] == 'b') draw_b();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      98
	BTFSS      STATUS+0, 2
	GOTO       L_main17
	CALL       _draw_b+0
L_main17:
;final_project.c,145 :: 		if(braille_map[letter] == 'e') draw_e();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      101
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	CALL       _draw_e+0
L_main18:
;final_project.c,146 :: 		if(braille_map[letter] == 'f') draw_f();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      102
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	CALL       _draw_f+0
L_main19:
;final_project.c,147 :: 		if(braille_map[letter] == 'h') draw_h();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      104
	BTFSS      STATUS+0, 2
	GOTO       L_main20
	CALL       _draw_h+0
L_main20:
;final_project.c,148 :: 		if(braille_map[letter] == 'i') draw_i();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      105
	BTFSS      STATUS+0, 2
	GOTO       L_main21
	CALL       _draw_i+0
L_main21:
;final_project.c,149 :: 		if(braille_map[letter] == 'k') draw_k();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      107
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	CALL       _draw_k+0
L_main22:
;final_project.c,150 :: 		if(braille_map[letter] == 'l') draw_l();
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      108
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	CALL       _draw_l+0
L_main23:
;final_project.c,152 :: 		letter = 0x00;
	CLRF       _letter+0
;final_project.c,153 :: 		move_next_letter();
	CALL       _move_next_letter+0
;final_project.c,155 :: 		while ((PORTD & 0x40) == 0x40);
L_main24:
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main25
	GOTO       L_main24
L_main25:
;final_project.c,156 :: 		delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main26:
	DECFSZ     R13+0, 1
	GOTO       L_main26
	DECFSZ     R12+0, 1
	GOTO       L_main26
	NOP
	NOP
;final_project.c,157 :: 		}
L_main7:
;final_project.c,160 :: 		if ((PORTD & 0x01) == 0x01) letter |= 0x01; // Set bit 0
	MOVLW      1
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main27
	BSF        _letter+0, 0
L_main27:
;final_project.c,161 :: 		if ((PORTD & 0x02) == 0x02) letter |= 0x02; // Set bit 1
	MOVLW      2
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	BSF        _letter+0, 1
L_main28:
;final_project.c,162 :: 		if ((PORTD & 0x04) == 0x04) letter |= 0x04; // Set bit 2
	MOVLW      4
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main29
	BSF        _letter+0, 2
L_main29:
;final_project.c,163 :: 		if ((PORTD & 0x08) == 0x08) letter |= 0x08; // Set bit 3
	MOVLW      8
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      8
	BTFSS      STATUS+0, 2
	GOTO       L_main30
	BSF        _letter+0, 3
L_main30:
;final_project.c,164 :: 		if ((PORTD & 0x10) == 0x10) letter |= 0x10; // Set bit 4
	MOVLW      16
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      16
	BTFSS      STATUS+0, 2
	GOTO       L_main31
	BSF        _letter+0, 4
L_main31:
;final_project.c,165 :: 		if ((PORTD & 0x20) == 0x20) letter |= 0x20; // Set bit 5
	MOVLW      32
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_main32
	BSF        _letter+0, 5
L_main32:
;final_project.c,166 :: 		if ((PORTD & 0x80) == 0x80) letter = 0x00;  // Clear all bits
	MOVLW      128
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      128
	BTFSS      STATUS+0, 2
	GOTO       L_main33
	CLRF       _letter+0
L_main33:
;final_project.c,167 :: 		}
	GOTO       L_main5
;final_project.c,171 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_pen_up:

;final_project.c,173 :: 		void pen_up(void) {
;final_project.c,174 :: 		angle = SERVO_UP;
	MOVLW      8
	MOVWF      _angle+0
	MOVLW      7
	MOVWF      _angle+1
;final_project.c,175 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,176 :: 		}
L_end_pen_up:
	RETURN
; end of _pen_up

_pen_down:

;final_project.c,178 :: 		void pen_down(void) {
;final_project.c,179 :: 		angle = SERVO_DOWN;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;final_project.c,180 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,181 :: 		}
L_end_pen_down:
	RETURN
; end of _pen_down

_draw_a:

;final_project.c,183 :: 		void draw_a(void) {
;final_project.c,184 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,185 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,186 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,187 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,188 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,189 :: 		draw_down_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_right_speed+0
	CALL       _draw_down_right+0
;final_project.c,190 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,191 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,192 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,193 :: 		}
L_end_draw_a:
	RETURN
; end of _draw_a

_draw_b:

;final_project.c,195 :: 		void draw_b(void) { //NO CURVES
;final_project.c,196 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,197 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,198 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,199 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,200 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,201 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,202 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,203 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,204 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,205 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,206 :: 		}
L_end_draw_b:
	RETURN
; end of _draw_b

_draw_e:

;final_project.c,208 :: 		void draw_e(void) {
;final_project.c,209 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,210 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,211 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,212 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,213 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,214 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,215 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,216 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,217 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,218 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,219 :: 		}
L_end_draw_e:
	RETURN
; end of _draw_e

_draw_f:

;final_project.c,221 :: 		void draw_f(void) {
;final_project.c,222 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,223 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,224 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,225 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,226 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,227 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,228 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,229 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,230 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,231 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,232 :: 		}
L_end_draw_f:
	RETURN
; end of _draw_f

_draw_h:

;final_project.c,235 :: 		void draw_h(void) {
;final_project.c,236 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,237 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,238 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,239 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,240 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,241 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,242 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,244 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,245 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,246 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,247 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,248 :: 		}
L_end_draw_h:
	RETURN
; end of _draw_h

_draw_i:

;final_project.c,250 :: 		void draw_i(void) { //TODO return to origin
;final_project.c,251 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,252 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,253 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,254 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,255 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,256 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,257 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,258 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,259 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,260 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,261 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,262 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,263 :: 		}
L_end_draw_i:
	RETURN
; end of _draw_i

_draw_k:

;final_project.c,265 :: 		void draw_k(void) {
;final_project.c,266 :: 		draw_up_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_right_speed+0
	CALL       _draw_up_right+0
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
;final_project.c,271 :: 		draw_up_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_left_speed+0
	CALL       _draw_up_left+0
;final_project.c,272 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,273 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,274 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,275 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,276 :: 		}
L_end_draw_k:
	RETURN
; end of _draw_k

_draw_l:

;final_project.c,278 :: 		void draw_l(void) {
;final_project.c,279 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,280 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,281 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,282 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,283 :: 		draw_left(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
;final_project.c,284 :: 		draw_up(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_up_speed+0
	CALL       _draw_up+0
;final_project.c,285 :: 		}
L_end_draw_l:
	RETURN
; end of _draw_l

_draw_space:

;final_project.c,287 :: 		void draw_space(void) {
;final_project.c,288 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,289 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,290 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,291 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,292 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,293 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,294 :: 		}
L_end_draw_space:
	RETURN
; end of _draw_space

_move_next_letter:

;final_project.c,296 :: 		void move_next_letter(void) {
;final_project.c,297 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,298 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,299 :: 		draw_right(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,300 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,301 :: 		}
L_end_move_next_letter:
	RETURN
; end of _move_next_letter

_enter_new_line:

;final_project.c,303 :: 		void enter_new_line(void) {
;final_project.c,304 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,305 :: 		for(times = 0; times<2*(LETTER_PER_LINE-1); times++) draw_left(speed);
	CLRF       _times+0
L_enter_new_line34:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORLW      0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__enter_new_line56
	MOVLW      38
	SUBWF      _times+0, 0
L__enter_new_line56:
	BTFSC      STATUS+0, 0
	GOTO       L_enter_new_line35
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
	INCF       _times+0, 1
	GOTO       L_enter_new_line34
L_enter_new_line35:
;final_project.c,306 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,307 :: 		draw_down(speed);
	MOVF       _speed+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,308 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,309 :: 		}
L_end_enter_new_line:
	RETURN
; end of _enter_new_line
