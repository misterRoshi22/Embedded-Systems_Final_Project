
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
;final_project.c,82 :: 		TMR0 = 0xF0;        // reload Timer0
	MOVLW      240
	MOVWF      TMR0+0
;final_project.c,83 :: 		}
L_interrupt0:
;final_project.c,90 :: 		if(PIR1 & 0x04){                                    // Servo Motor CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt1
;final_project.c,91 :: 		if(HL){                                // high
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt2
;final_project.c,92 :: 		CCPR1H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;final_project.c,93 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;final_project.c,94 :: 		HL = 0;                      // next time low
	CLRF       _HL+0
;final_project.c,95 :: 		CCP1CON = 0x09;              // compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP1CON+0
;final_project.c,96 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,97 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,98 :: 		}
	GOTO       L_interrupt3
L_interrupt2:
;final_project.c,100 :: 		CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
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
;final_project.c,101 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;final_project.c,102 :: 		CCP1CON = 0x08;             // compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;final_project.c,103 :: 		HL = 1;                     //next time High
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,104 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,105 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,106 :: 		}
L_interrupt3:
;final_project.c,108 :: 		PIR1 = PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;final_project.c,109 :: 		}
L_interrupt1:
;final_project.c,112 :: 		}
L_end_interrupt:
L__interrupt27:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;final_project.c,114 :: 		void main() {
;final_project.c,115 :: 		TRISC = 0x00;  // Set all PORTC pins as output
	CLRF       TRISC+0
;final_project.c,116 :: 		PORTC = 0xC0;  // Clear PORTC, set enables to 0 active low
	MOVLW      192
	MOVWF      PORTC+0
;final_project.c,117 :: 		ATD_init();
	CALL       _ATD_init+0
;final_project.c,119 :: 		TRISD = 0xFF;
	MOVLW      255
	MOVWF      TRISD+0
;final_project.c,122 :: 		Timer0_Init();  // Initialize Timer0
	CALL       _Timer0_Init+0
;final_project.c,124 :: 		Timer1_Init();  // Initialize Timer1
	CALL       _Timer1_Init+0
;final_project.c,126 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;final_project.c,127 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,128 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,132 :: 		INTCON |= 0x80; // Global Interrupt Enable (GIE)
	BSF        INTCON+0, 7
;final_project.c,133 :: 		INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)
	BSF        INTCON+0, 6
;final_project.c,135 :: 		while (1) {
L_main4:
;final_project.c,137 :: 		size = ATD_read(0);
	CLRF       FARG_ATD_read_channel+0
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _size+0
;final_project.c,138 :: 		size = 50 + ((size * (150 - 50)) / 242); //  50-150
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
;final_project.c,143 :: 		if ((PORTD & 0x40) == 0x40) {  // Check if enter is pressed
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main6
;final_project.c,144 :: 		Delay(50);
	MOVLW      50
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,145 :: 		if (char_count == letters_per_line) {
	MOVF       _char_count+0, 0
	XORLW      20
	BTFSS      STATUS+0, 2
	GOTO       L_main7
;final_project.c,146 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,147 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,148 :: 		}
	GOTO       L_main8
L_main7:
;final_project.c,149 :: 		else if(char_count == 2*letters_per_line) {
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main29
	MOVLW      40
	XORWF      _char_count+0, 0
L__main29:
	BTFSS      STATUS+0, 2
	GOTO       L_main9
;final_project.c,150 :: 		Lcd_Cmd(_LCD_THIRD_ROW);
	MOVLW      148
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,151 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,152 :: 		}
	GOTO       L_main10
L_main9:
;final_project.c,153 :: 		else if(char_count == 3*letters_per_line) {
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main30
	MOVLW      60
	XORWF      _char_count+0, 0
L__main30:
	BTFSS      STATUS+0, 2
	GOTO       L_main11
;final_project.c,154 :: 		Lcd_Cmd(_LCD_FOURTH_ROW);
	MOVLW      212
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,155 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,156 :: 		}
	GOTO       L_main12
L_main11:
;final_project.c,157 :: 		else if(char_count == 4*letters_per_line){
	MOVLW      0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main31
	MOVLW      80
	XORWF      _char_count+0, 0
L__main31:
	BTFSS      STATUS+0, 2
	GOTO       L_main13
;final_project.c,158 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,159 :: 		enter_new_line();
	CALL       _enter_new_line+0
;final_project.c,161 :: 		}
L_main13:
L_main12:
L_main10:
L_main8:
;final_project.c,162 :: 		Lcd_Chr_Cp(braille_map[letter]); // Display character on LCD
	MOVF       _letter+0, 0
	ADDLW      _braille_map+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;final_project.c,163 :: 		char_count++;
	INCF       _char_count+0, 1
;final_project.c,192 :: 		letter = 0x00;
	CLRF       _letter+0
;final_project.c,193 :: 		move_next_letter();
	CALL       _move_next_letter+0
;final_project.c,195 :: 		while ((PORTD & 0x40) == 0x40);
L_main14:
	MOVLW      64
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	GOTO       L_main14
L_main15:
;final_project.c,196 :: 		Delay(50);
	MOVLW      50
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,197 :: 		}
L_main6:
;final_project.c,199 :: 		if ((PORTD & 0x01) == 0x01) letter |= 0x01; // Set bit 0
	MOVLW      1
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main16
	BSF        _letter+0, 0
L_main16:
;final_project.c,200 :: 		if ((PORTD & 0x02) == 0x02) letter |= 0x02; // Set bit 1
	MOVLW      2
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main17
	BSF        _letter+0, 1
L_main17:
;final_project.c,201 :: 		if ((PORTD & 0x04) == 0x04) letter |= 0x04; // Set bit 2
	MOVLW      4
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	BSF        _letter+0, 2
L_main18:
;final_project.c,202 :: 		if ((PORTD & 0x08) == 0x08) letter |= 0x08; // Set bit 3
	MOVLW      8
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      8
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	BSF        _letter+0, 3
L_main19:
;final_project.c,203 :: 		if ((PORTD & 0x10) == 0x10) letter |= 0x10; // Set bit 4
	MOVLW      16
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      16
	BTFSS      STATUS+0, 2
	GOTO       L_main20
	BSF        _letter+0, 4
L_main20:
;final_project.c,204 :: 		if ((PORTD & 0x20) == 0x20) letter |= 0x20; // Set bit 5
	MOVLW      32
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_main21
	BSF        _letter+0, 5
L_main21:
;final_project.c,205 :: 		if ((PORTD & 0x80) == 0x80) letter = 0x00;  // Clear all bits
	MOVLW      128
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      128
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	CLRF       _letter+0
L_main22:
;final_project.c,206 :: 		}
	GOTO       L_main4
;final_project.c,208 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_pen_up:

;final_project.c,210 :: 		void pen_up(void) {
;final_project.c,211 :: 		angle = SERVO_UP;
	MOVLW      8
	MOVWF      _angle+0
	MOVLW      7
	MOVWF      _angle+1
;final_project.c,212 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,213 :: 		}
L_end_pen_up:
	RETURN
; end of _pen_up

_pen_down:

;final_project.c,215 :: 		void pen_down(void) {
;final_project.c,216 :: 		angle = SERVO_DOWN;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;final_project.c,217 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_delay+0
	MOVLW      0
	MOVWF      FARG_Delay_delay+1
	CALL       _Delay+0
;final_project.c,218 :: 		}
L_end_pen_down:
	RETURN
; end of _pen_down

_draw_space:

;final_project.c,549 :: 		void draw_space(void) {
;final_project.c,550 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,551 :: 		draw_right(size);
	MOVF       _size+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,552 :: 		draw_right(size);
	MOVF       _size+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,553 :: 		draw_right(size);
	MOVF       _size+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,554 :: 		draw_right(size);
	MOVF       _size+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,555 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,556 :: 		}
L_end_draw_space:
	RETURN
; end of _draw_space

_move_next_letter:

;final_project.c,558 :: 		void move_next_letter(void) {
;final_project.c,559 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,560 :: 		draw_right(size);
	MOVF       _size+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,561 :: 		draw_right(size);
	MOVF       _size+0, 0
	MOVWF      FARG_draw_right_speed+0
	CALL       _draw_right+0
;final_project.c,562 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,563 :: 		}
L_end_move_next_letter:
	RETURN
; end of _move_next_letter

_enter_new_line:

;final_project.c,565 :: 		void enter_new_line(void) {
;final_project.c,566 :: 		pen_up();
	CALL       _pen_up+0
;final_project.c,567 :: 		for(times = 0; times<2*(letters_per_line-1); times++) draw_left(size);
	CLRF       _times+0
L_enter_new_line23:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORLW      0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__enter_new_line37
	MOVLW      38
	SUBWF      _times+0, 0
L__enter_new_line37:
	BTFSC      STATUS+0, 0
	GOTO       L_enter_new_line24
	MOVF       _size+0, 0
	MOVWF      FARG_draw_left_speed+0
	CALL       _draw_left+0
	INCF       _times+0, 1
	GOTO       L_enter_new_line23
L_enter_new_line24:
;final_project.c,568 :: 		draw_down(size);
	MOVF       _size+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,569 :: 		draw_down(size);
	MOVF       _size+0, 0
	MOVWF      FARG_draw_down_speed+0
	CALL       _draw_down+0
;final_project.c,570 :: 		pen_down();
	CALL       _pen_down+0
;final_project.c,571 :: 		}
L_end_enter_new_line:
	RETURN
; end of _enter_new_line
