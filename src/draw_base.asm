
_draw_right:

;draw_base.c,6 :: 		void draw_right(unsigned char speed) { //direction  = 1 goes to right
;draw_base.c,7 :: 		PORTC |= 0x10; //set directionn = 1
	BSF        PORTC+0, 4
;draw_base.c,8 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,9 :: 		Delay(speed);
	MOVF       FARG_draw_right_speed+0, 0
	MOVWF      FARG_Delay_delay+0
	CLRF       FARG_Delay_delay+1
	CALL       _Delay+0
;draw_base.c,10 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,11 :: 		}
L_end_draw_right:
	RETURN
; end of _draw_right

_draw_left:

;draw_base.c,13 :: 		void draw_left(unsigned char speed) { //direction = 0 goes to left
;draw_base.c,14 :: 		PORTC &= 0xEF;     //set direction = 0
	MOVLW      239
	ANDWF      PORTC+0, 1
;draw_base.c,15 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,16 :: 		Delay(speed);
	MOVF       FARG_draw_left_speed+0, 0
	MOVWF      FARG_Delay_delay+0
	CLRF       FARG_Delay_delay+1
	CALL       _Delay+0
;draw_base.c,17 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,18 :: 		}
L_end_draw_left:
	RETURN
; end of _draw_left

_draw_down:

;draw_base.c,20 :: 		void draw_down(unsigned char speed){ // direction = 1
;draw_base.c,21 :: 		PORTC &= 0xDF;
	MOVLW      223
	ANDWF      PORTC+0, 1
;draw_base.c,22 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,23 :: 		Delay(speed);
	MOVF       FARG_draw_down_speed+0, 0
	MOVWF      FARG_Delay_delay+0
	CLRF       FARG_Delay_delay+1
	CALL       _Delay+0
;draw_base.c,24 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,25 :: 		}
L_end_draw_down:
	RETURN
; end of _draw_down

_draw_up:

;draw_base.c,27 :: 		void draw_up(unsigned char speed){ // direction = 0
;draw_base.c,28 :: 		PORTC |= 0x20;
	BSF        PORTC+0, 5
;draw_base.c,29 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,30 :: 		Delay(speed);
	MOVF       FARG_draw_up_speed+0, 0
	MOVWF      FARG_Delay_delay+0
	CLRF       FARG_Delay_delay+1
	CALL       _Delay+0
;draw_base.c,31 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,32 :: 		}
L_end_draw_up:
	RETURN
; end of _draw_up

_draw_down_right:

;draw_base.c,34 :: 		void draw_down_right(unsigned char speed){
;draw_base.c,35 :: 		PORTC |= 0x10; //set directionn = 1
	BSF        PORTC+0, 4
;draw_base.c,36 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,37 :: 		PORTC &= 0xDF;
	MOVLW      223
	ANDWF      PORTC+0, 1
;draw_base.c,38 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,39 :: 		Delay(speed);
	MOVF       FARG_draw_down_right_speed+0, 0
	MOVWF      FARG_Delay_delay+0
	CLRF       FARG_Delay_delay+1
	CALL       _Delay+0
;draw_base.c,40 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,41 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,42 :: 		}
L_end_draw_down_right:
	RETURN
; end of _draw_down_right

_draw_down_left:

;draw_base.c,44 :: 		void draw_down_left(unsigned char speed) {
;draw_base.c,45 :: 		PORTC &= 0xDF;
	MOVLW      223
	ANDWF      PORTC+0, 1
;draw_base.c,46 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,47 :: 		PORTC &= 0xEF;     //set direction = 0
	MOVLW      239
	ANDWF      PORTC+0, 1
;draw_base.c,48 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,49 :: 		Delay(speed);
	MOVF       FARG_draw_down_left_speed+0, 0
	MOVWF      FARG_Delay_delay+0
	CLRF       FARG_Delay_delay+1
	CALL       _Delay+0
;draw_base.c,50 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,51 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,52 :: 		}
L_end_draw_down_left:
	RETURN
; end of _draw_down_left

_draw_up_right:

;draw_base.c,54 :: 		void draw_up_right(unsigned char speed) {
;draw_base.c,55 :: 		PORTC |= 0x10; //set directionn = 1
	BSF        PORTC+0, 4
;draw_base.c,56 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,57 :: 		PORTC |= 0x20;
	BSF        PORTC+0, 5
;draw_base.c,58 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,59 :: 		Delay(speed);
	MOVF       FARG_draw_up_right_speed+0, 0
	MOVWF      FARG_Delay_delay+0
	CLRF       FARG_Delay_delay+1
	CALL       _Delay+0
;draw_base.c,60 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,61 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,62 :: 		}
L_end_draw_up_right:
	RETURN
; end of _draw_up_right

_draw_up_left:

;draw_base.c,64 :: 		void draw_up_left(unsigned char speed) {
;draw_base.c,65 :: 		PORTC &= 0xEF;     //set direction = 0
	MOVLW      239
	ANDWF      PORTC+0, 1
;draw_base.c,66 :: 		PORTC &= 0xBF; //set enable = 0
	MOVLW      191
	ANDWF      PORTC+0, 1
;draw_base.c,67 :: 		PORTC |= 0x20;
	BSF        PORTC+0, 5
;draw_base.c,68 :: 		PORTC &= 0x7F; //set enable = 0
	MOVLW      127
	ANDWF      PORTC+0, 1
;draw_base.c,69 :: 		Delay(speed);
	MOVF       FARG_draw_up_left_speed+0, 0
	MOVWF      FARG_Delay_delay+0
	CLRF       FARG_Delay_delay+1
	CALL       _Delay+0
;draw_base.c,70 :: 		PORTC |= 0x40; //set enable = 1
	BSF        PORTC+0, 6
;draw_base.c,71 :: 		PORTC |= 0x80; //set enable = 1
	BSF        PORTC+0, 7
;draw_base.c,72 :: 		}
L_end_draw_up_left:
	RETURN
; end of _draw_up_left
