
_draw_right:

;draw_base.c,4 :: 		void draw_right(void) { //direction  = 1 goes to right
;draw_base.c,5 :: 		PORTC |= 0x10; //set directionn = 1
	BSF        PORTC+0, 4
;draw_base.c,6 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,7 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_draw_right0:
	DECFSZ     R13+0, 1
	GOTO       L_draw_right0
	DECFSZ     R12+0, 1
	GOTO       L_draw_right0
	DECFSZ     R11+0, 1
	GOTO       L_draw_right0
	NOP
;draw_base.c,8 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,9 :: 		}
L_end_draw_right:
	RETURN
; end of _draw_right

_draw_left:

;draw_base.c,11 :: 		void draw_left(void) { //direction = 0 goes to left
;draw_base.c,12 :: 		PORTC &= 0xEF;     //set direction = 0
	MOVLW      239
	ANDWF      PORTC+0, 1
;draw_base.c,13 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,14 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_draw_left1:
	DECFSZ     R13+0, 1
	GOTO       L_draw_left1
	DECFSZ     R12+0, 1
	GOTO       L_draw_left1
	DECFSZ     R11+0, 1
	GOTO       L_draw_left1
	NOP
;draw_base.c,15 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,16 :: 		}
L_end_draw_left:
	RETURN
; end of _draw_left

_draw_down:

;draw_base.c,18 :: 		void draw_down(void){ // direction = 1
;draw_base.c,19 :: 		PORTC &= 0xDF;
	MOVLW      223
	ANDWF      PORTC+0, 1
;draw_base.c,20 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,21 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_draw_down2:
	DECFSZ     R13+0, 1
	GOTO       L_draw_down2
	DECFSZ     R12+0, 1
	GOTO       L_draw_down2
	DECFSZ     R11+0, 1
	GOTO       L_draw_down2
	NOP
;draw_base.c,22 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,23 :: 		}
L_end_draw_down:
	RETURN
; end of _draw_down

_draw_up:

;draw_base.c,25 :: 		void draw_up(void){ // direction = 0
;draw_base.c,26 :: 		PORTC |= 0x20;
	BSF        PORTC+0, 5
;draw_base.c,27 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,28 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_draw_up3:
	DECFSZ     R13+0, 1
	GOTO       L_draw_up3
	DECFSZ     R12+0, 1
	GOTO       L_draw_up3
	DECFSZ     R11+0, 1
	GOTO       L_draw_up3
	NOP
;draw_base.c,29 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,30 :: 		}
L_end_draw_up:
	RETURN
; end of _draw_up

_draw_down_right:

;draw_base.c,32 :: 		void draw_down_right(void){
;draw_base.c,33 :: 		PORTC |= 0x10; //set directionn = 1
	BSF        PORTC+0, 4
;draw_base.c,34 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,35 :: 		PORTC &= 0xDF;
	MOVLW      223
	ANDWF      PORTC+0, 1
;draw_base.c,36 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,37 :: 		Delay_ms(DRAW_DIAG_TIME);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      9
	MOVWF      R12+0
	MOVLW      236
	MOVWF      R13+0
L_draw_down_right4:
	DECFSZ     R13+0, 1
	GOTO       L_draw_down_right4
	DECFSZ     R12+0, 1
	GOTO       L_draw_down_right4
	DECFSZ     R11+0, 1
	GOTO       L_draw_down_right4
	NOP
;draw_base.c,38 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,39 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,40 :: 		}
L_end_draw_down_right:
	RETURN
; end of _draw_down_right

_draw_up_left:

;draw_base.c,42 :: 		void draw_up_left(void) {
;draw_base.c,43 :: 		PORTC &= 0xEF;     //set direction = 0
	MOVLW      239
	ANDWF      PORTC+0, 1
;draw_base.c,44 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,45 :: 		PORTC |= 0x20;
	BSF        PORTC+0, 5
;draw_base.c,46 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,47 :: 		Delay_ms(DRAW_DIAG_TIME);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      9
	MOVWF      R12+0
	MOVLW      236
	MOVWF      R13+0
L_draw_up_left5:
	DECFSZ     R13+0, 1
	GOTO       L_draw_up_left5
	DECFSZ     R12+0, 1
	GOTO       L_draw_up_left5
	DECFSZ     R11+0, 1
	GOTO       L_draw_up_left5
	NOP
;draw_base.c,48 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,49 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,50 :: 		}
L_end_draw_up_left:
	RETURN
; end of _draw_up_left
