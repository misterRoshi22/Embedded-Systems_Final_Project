
_draw_right:

;draw_base.c,8 :: 		void draw_right(void) { //direction  = 1 goes to right
;draw_base.c,10 :: 		PORTC |= 0x10; //set directionn = 1
	BSF        PORTC+0, 4
;draw_base.c,11 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,12 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_draw_right0:
	DECFSZ     R13+0, 1
	GOTO       L_draw_right0
	DECFSZ     R12+0, 1
	GOTO       L_draw_right0
	DECFSZ     R11+0, 1
	GOTO       L_draw_right0
;draw_base.c,13 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,14 :: 		}
L_end_draw_right:
	RETURN
; end of _draw_right

_draw_left:

;draw_base.c,16 :: 		void draw_left(void) { //direction = 0 goes to left
;draw_base.c,18 :: 		PORTC &= 0xEF;     //set direction = 0
	MOVLW      239
	ANDWF      PORTC+0, 1
;draw_base.c,19 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,20 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_draw_left1:
	DECFSZ     R13+0, 1
	GOTO       L_draw_left1
	DECFSZ     R12+0, 1
	GOTO       L_draw_left1
	DECFSZ     R11+0, 1
	GOTO       L_draw_left1
;draw_base.c,21 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,22 :: 		}
L_end_draw_left:
	RETURN
; end of _draw_left

_draw_down:

;draw_base.c,24 :: 		void draw_down(void){ // direction = 1
;draw_base.c,26 :: 		PORTC &= 0xDF;
	MOVLW      223
	ANDWF      PORTC+0, 1
;draw_base.c,27 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,28 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_draw_down2:
	DECFSZ     R13+0, 1
	GOTO       L_draw_down2
	DECFSZ     R12+0, 1
	GOTO       L_draw_down2
	DECFSZ     R11+0, 1
	GOTO       L_draw_down2
;draw_base.c,29 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,30 :: 		}
L_end_draw_down:
	RETURN
; end of _draw_down

_draw_up:

;draw_base.c,32 :: 		void draw_up(void){ // direction = 0
;draw_base.c,34 :: 		PORTC |= 0x20;
	BSF        PORTC+0, 5
;draw_base.c,35 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,36 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_draw_up3:
	DECFSZ     R13+0, 1
	GOTO       L_draw_up3
	DECFSZ     R12+0, 1
	GOTO       L_draw_up3
	DECFSZ     R11+0, 1
	GOTO       L_draw_up3
;draw_base.c,37 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,38 :: 		}
L_end_draw_up:
	RETURN
; end of _draw_up

_draw_down_right:

;draw_base.c,40 :: 		void draw_down_right(void){
;draw_base.c,42 :: 		PORTC |= 0x10; //set directionn = 1
	BSF        PORTC+0, 4
;draw_base.c,43 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,44 :: 		PORTC &= 0xDF;
	MOVLW      223
	ANDWF      PORTC+0, 1
;draw_base.c,45 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,46 :: 		Delay_ms(DRAW_DIAG_TIME);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      36
	MOVWF      R12+0
	MOVLW      184
	MOVWF      R13+0
L_draw_down_right4:
	DECFSZ     R13+0, 1
	GOTO       L_draw_down_right4
	DECFSZ     R12+0, 1
	GOTO       L_draw_down_right4
	DECFSZ     R11+0, 1
	GOTO       L_draw_down_right4
	NOP
;draw_base.c,47 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,48 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,49 :: 		}
L_end_draw_down_right:
	RETURN
; end of _draw_down_right

_draw_up_left:

;draw_base.c,51 :: 		void draw_up_left(void) {
;draw_base.c,53 :: 		PORTC &= 0xEF;     //set direction = 0
	MOVLW      239
	ANDWF      PORTC+0, 1
;draw_base.c,54 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,55 :: 		PORTC |= 0x20;
	BSF        PORTC+0, 5
;draw_base.c,56 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,57 :: 		Delay_ms(DRAW_DIAG_TIME);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      36
	MOVWF      R12+0
	MOVLW      184
	MOVWF      R13+0
L_draw_up_left5:
	DECFSZ     R13+0, 1
	GOTO       L_draw_up_left5
	DECFSZ     R12+0, 1
	GOTO       L_draw_up_left5
	DECFSZ     R11+0, 1
	GOTO       L_draw_up_left5
	NOP
;draw_base.c,58 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,59 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,60 :: 		}
L_end_draw_up_left:
	RETURN
; end of _draw_up_left

_move_right:

;draw_base.c,62 :: 		void move_right(void) { //direction  = 1 goes to right
;draw_base.c,64 :: 		PORTC |= 0x10; //set directionn = 1
	BSF        PORTC+0, 4
;draw_base.c,65 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,66 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_move_right6:
	DECFSZ     R13+0, 1
	GOTO       L_move_right6
	DECFSZ     R12+0, 1
	GOTO       L_move_right6
	DECFSZ     R11+0, 1
	GOTO       L_move_right6
;draw_base.c,67 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,68 :: 		}
L_end_move_right:
	RETURN
; end of _move_right

_move_left:

;draw_base.c,70 :: 		void move_left(void) {
;draw_base.c,72 :: 		PORTC &= 0xEF;     //set direction = 0
	MOVLW      239
	ANDWF      PORTC+0, 1
;draw_base.c,73 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,74 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_move_left7:
	DECFSZ     R13+0, 1
	GOTO       L_move_left7
	DECFSZ     R12+0, 1
	GOTO       L_move_left7
	DECFSZ     R11+0, 1
	GOTO       L_move_left7
;draw_base.c,75 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,76 :: 		}
L_end_move_left:
	RETURN
; end of _move_left

_move_down:

;draw_base.c,78 :: 		void move_down(void){ // direction = 1
;draw_base.c,80 :: 		PORTC &= 0xDF;
	MOVLW      223
	ANDWF      PORTC+0, 1
;draw_base.c,81 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,82 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_move_down8:
	DECFSZ     R13+0, 1
	GOTO       L_move_down8
	DECFSZ     R12+0, 1
	GOTO       L_move_down8
	DECFSZ     R11+0, 1
	GOTO       L_move_down8
;draw_base.c,83 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,84 :: 		}
L_end_move_down:
	RETURN
; end of _move_down

_move_up:

;draw_base.c,86 :: 		void move_up(void){ // direction = 0
;draw_base.c,88 :: 		PORTC |= 0x20;
	BSF        PORTC+0, 5
;draw_base.c,89 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,90 :: 		Delay_ms(DRAW_LINE_TIME);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_move_up9:
	DECFSZ     R13+0, 1
	GOTO       L_move_up9
	DECFSZ     R12+0, 1
	GOTO       L_move_up9
	DECFSZ     R11+0, 1
	GOTO       L_move_up9
;draw_base.c,91 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,92 :: 		}
L_end_move_up:
	RETURN
; end of _move_up
