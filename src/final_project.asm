
_draw_horizontal_line:

;final_project.c,15 :: 		void draw_horizontal_line(unsigned char steps) { //motor 1 step pin is connected to C2
;final_project.c,16 :: 		for (i = 0; i < steps; i++) {
	CLRF       _i+0
L_draw_horizontal_line0:
	MOVF       FARG_draw_horizontal_line_steps+0, 0
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_draw_horizontal_line1
;final_project.c,17 :: 		PORTC |= 0x04;  //0000 0100
	BSF        PORTC+0, 2
;final_project.c,18 :: 		Delay_ms(STEP_MOTOR_SPEED);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_draw_horizontal_line3:
	DECFSZ     R13+0, 1
	GOTO       L_draw_horizontal_line3
	DECFSZ     R12+0, 1
	GOTO       L_draw_horizontal_line3
	NOP
;final_project.c,19 :: 		PORTC &= 0xFB; //1111 1011
	MOVLW      251
	ANDWF      PORTC+0, 1
;final_project.c,20 :: 		Delay_ms(STEP_MOTOR_SPEED);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_draw_horizontal_line4:
	DECFSZ     R13+0, 1
	GOTO       L_draw_horizontal_line4
	DECFSZ     R12+0, 1
	GOTO       L_draw_horizontal_line4
	NOP
;final_project.c,16 :: 		for (i = 0; i < steps; i++) {
	INCF       _i+0, 1
;final_project.c,21 :: 		}
	GOTO       L_draw_horizontal_line0
L_draw_horizontal_line1:
;final_project.c,22 :: 		}
L_end_draw_horizontal_line:
	RETURN
; end of _draw_horizontal_line

_draw_vertical_line:

;final_project.c,24 :: 		void draw_vertical_line(unsigned char steps) { //motor 2 step pin is connected to C3
;final_project.c,25 :: 		for(i = 0; i < steps; i++) {
	CLRF       _i+0
L_draw_vertical_line5:
	MOVF       FARG_draw_vertical_line_steps+0, 0
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_draw_vertical_line6
;final_project.c,26 :: 		PORTC |= 0x08; // 0000 1000
	BSF        PORTC+0, 3
;final_project.c,27 :: 		Delay_ms(STEP_MOTOR_SPEED);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_draw_vertical_line8:
	DECFSZ     R13+0, 1
	GOTO       L_draw_vertical_line8
	DECFSZ     R12+0, 1
	GOTO       L_draw_vertical_line8
	NOP
;final_project.c,28 :: 		PORTC &= 0xF7; // 1111 0111
	MOVLW      247
	ANDWF      PORTC+0, 1
;final_project.c,29 :: 		DElay_ms(STEP_MOTOR_SPEED);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_draw_vertical_line9:
	DECFSZ     R13+0, 1
	GOTO       L_draw_vertical_line9
	DECFSZ     R12+0, 1
	GOTO       L_draw_vertical_line9
	NOP
;final_project.c,25 :: 		for(i = 0; i < steps; i++) {
	INCF       _i+0, 1
;final_project.c,30 :: 		}
	GOTO       L_draw_vertical_line5
L_draw_vertical_line6:
;final_project.c,31 :: 		}
L_end_draw_vertical_line:
	RETURN
; end of _draw_vertical_line

_draw_diagonal_line:

;final_project.c,33 :: 		void draw_diagonal_line(unsigned char steps) {
;final_project.c,34 :: 		for(i = 0; i < steps; i++) {
	CLRF       _i+0
L_draw_diagonal_line10:
	MOVF       FARG_draw_diagonal_line_steps+0, 0
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_draw_diagonal_line11
;final_project.c,35 :: 		PORTC |= 0x0C; // 0000 1100
	MOVLW      12
	IORWF      PORTC+0, 1
;final_project.c,36 :: 		Delay_ms(STEP_MOTOR_SPEED);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_draw_diagonal_line13:
	DECFSZ     R13+0, 1
	GOTO       L_draw_diagonal_line13
	DECFSZ     R12+0, 1
	GOTO       L_draw_diagonal_line13
	NOP
;final_project.c,37 :: 		PORTC &= 0xF3; // 1111 0011
	MOVLW      243
	ANDWF      PORTC+0, 1
;final_project.c,38 :: 		Delay_ms(STEP_MOTOR_SPEED);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_draw_diagonal_line14:
	DECFSZ     R13+0, 1
	GOTO       L_draw_diagonal_line14
	DECFSZ     R12+0, 1
	GOTO       L_draw_diagonal_line14
	NOP
;final_project.c,34 :: 		for(i = 0; i < steps; i++) {
	INCF       _i+0, 1
;final_project.c,39 :: 		}
	GOTO       L_draw_diagonal_line10
L_draw_diagonal_line11:
;final_project.c,40 :: 		}
L_end_draw_diagonal_line:
	RETURN
; end of _draw_diagonal_line

_read_input:

;final_project.c,42 :: 		void read_input() {
;final_project.c,44 :: 		}
L_end_read_input:
	RETURN
; end of _read_input

_main:

;final_project.c,46 :: 		void main() {
;final_project.c,47 :: 		TRISC = 0xC1;                // pin c7, c6 and c0 are inputs,  rest are outputs 1100 0001
	MOVLW      193
	MOVWF      TRISC+0
;final_project.c,48 :: 		PORTC = 0x00;                // initialize PORT C
	CLRF       PORTC+0
;final_project.c,49 :: 		ADCON1 = 0x06;               // configure all pins as digital, except for RA0 which might be used later
	MOVLW      6
	MOVWF      ADCON1+0
;final_project.c,50 :: 		TRISE = 0xFF;                // configure PORRT E as inputs
	MOVLW      255
	MOVWF      TRISE+0
;final_project.c,51 :: 		PORTE = 0x00;                // initialize PORT E
	CLRF       PORTE+0
;final_project.c,53 :: 		while(1) {
L_main15:
;final_project.c,55 :: 		if (PORTC & 0x80) config_word |= 0x20; // Set bit 5
	BTFSS      PORTC+0, 7
	GOTO       L_main17
	BSF        _config_word+0, 5
L_main17:
;final_project.c,56 :: 		if (PORTC & 0x40) config_word |= 0x40; // Set bit 3
	BTFSS      PORTC+0, 6
	GOTO       L_main18
	BSF        _config_word+0, 6
L_main18:
;final_project.c,57 :: 		if (PORTE & 0x01) config_word |= 0x01; // Set bit 0
	BTFSS      PORTE+0, 0
	GOTO       L_main19
	BSF        _config_word+0, 0
L_main19:
;final_project.c,58 :: 		if (PORTE & 0x02) config_word |= 0x02; // Set bit 1
	BTFSS      PORTE+0, 1
	GOTO       L_main20
	BSF        _config_word+0, 1
L_main20:
;final_project.c,59 :: 		if (PORTE & 0x04) config_word |= 0x04; // Set bit 2
	BTFSS      PORTE+0, 2
	GOTO       L_main21
	BSF        _config_word+0, 2
L_main21:
;final_project.c,61 :: 		if (PORTC & 0x01) {                   // Button pressed
	BTFSS      PORTC+0, 0
	GOTO       L_main22
;final_project.c,62 :: 		delay_ms(50);                      // Debouncing delay
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main23:
	DECFSZ     R13+0, 1
	GOTO       L_main23
	DECFSZ     R12+0, 1
	GOTO       L_main23
	NOP
	NOP
;final_project.c,63 :: 		switch (config_word & 0x7) {      // 8 optoions as c6 and c7 are used to control the direction of the motors
	MOVLW      7
	ANDWF      _config_word+0, 0
	MOVWF      FLOC__main+0
	GOTO       L_main24
;final_project.c,64 :: 		case 0b000:                   // nothing // TODO
L_main26:
;final_project.c,65 :: 		break;
	GOTO       L_main25
;final_project.c,67 :: 		case 0b001: draw_vertical_line(STEPS_FULL_ROTATION);     // E0
L_main27:
	MOVLW      200
	MOVWF      FARG_draw_vertical_line_steps+0
	CALL       _draw_vertical_line+0
;final_project.c,68 :: 		break;
	GOTO       L_main25
;final_project.c,70 :: 		case 0b010: draw_vertical_line(STEPS_HALF_ROTATION);     // E1
L_main28:
	MOVLW      100
	MOVWF      FARG_draw_vertical_line_steps+0
	CALL       _draw_vertical_line+0
;final_project.c,71 :: 		break;
	GOTO       L_main25
;final_project.c,73 :: 		case 0b011: draw_horizontal_line(STEPS_FULL_ROTATION);   // E1, E0
L_main29:
	MOVLW      200
	MOVWF      FARG_draw_horizontal_line_steps+0
	CALL       _draw_horizontal_line+0
;final_project.c,74 :: 		break;
	GOTO       L_main25
;final_project.c,76 :: 		case 0b100: draw_horizontal_line(STEPS_HALF_ROTATION);   //  E2
L_main30:
	MOVLW      100
	MOVWF      FARG_draw_horizontal_line_steps+0
	CALL       _draw_horizontal_line+0
;final_project.c,77 :: 		break;
	GOTO       L_main25
;final_project.c,79 :: 		case 0b101: draw_diagonal_line(STEPS_FULL_ROTATION);     // E2, E0
L_main31:
	MOVLW      200
	MOVWF      FARG_draw_diagonal_line_steps+0
	CALL       _draw_diagonal_line+0
;final_project.c,80 :: 		break;
	GOTO       L_main25
;final_project.c,82 :: 		case 0b110: draw_diagonal_line(STEPS_HALF_ROTATION);     // E2, E1
L_main32:
	MOVLW      100
	MOVWF      FARG_draw_diagonal_line_steps+0
	CALL       _draw_diagonal_line+0
;final_project.c,83 :: 		break;
	GOTO       L_main25
;final_project.c,85 :: 		case 0b111:  // E2, E1, E0  //TODO
L_main33:
;final_project.c,86 :: 		break;
	GOTO       L_main25
;final_project.c,87 :: 		}
L_main24:
	MOVF       FLOC__main+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main26
	MOVF       FLOC__main+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main27
	MOVF       FLOC__main+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main28
	MOVF       FLOC__main+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main29
	MOVF       FLOC__main+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_main30
	MOVF       FLOC__main+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_main31
	MOVF       FLOC__main+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_main32
	MOVF       FLOC__main+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_main33
L_main25:
;final_project.c,88 :: 		config_word = 0;
	CLRF       _config_word+0
;final_project.c,89 :: 		while ((PORTC & 0x01) == 0x01); // Wait for button to be released
L_main34:
	MOVLW      1
	ANDWF      PORTC+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main35
	GOTO       L_main34
L_main35:
;final_project.c,90 :: 		delay_ms(50);                // Debouncing delay after release
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main36:
	DECFSZ     R13+0, 1
	GOTO       L_main36
	DECFSZ     R12+0, 1
	GOTO       L_main36
	NOP
	NOP
;final_project.c,92 :: 		}
L_main22:
;final_project.c,93 :: 		}
	GOTO       L_main15
;final_project.c,94 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
