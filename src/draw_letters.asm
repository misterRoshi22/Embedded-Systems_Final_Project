
_draw_e:

;draw_letters.c,4 :: 		void draw_e(void) {
;draw_letters.c,5 :: 		draw_left();
	CALL       _draw_left+0
;draw_letters.c,6 :: 		draw_up();
	CALL       _draw_up+0
;draw_letters.c,7 :: 		draw_right();
	CALL       _draw_right+0
;draw_letters.c,8 :: 		move_down();
	CALL       _move_down+0
;draw_letters.c,9 :: 		move_down();
	CALL       _move_down+0
;draw_letters.c,10 :: 		draw_left();
	CALL       _draw_left+0
;draw_letters.c,11 :: 		draw_up();
	CALL       _draw_up+0
;draw_letters.c,12 :: 		move_right();
	CALL       _move_right+0
;draw_letters.c,13 :: 		}
L_end_draw_e:
	RETURN
; end of _draw_e

_draw_a:

;draw_letters.c,15 :: 		void draw_a(void) {
;draw_letters.c,16 :: 		draw_up_left();
	CALL       _draw_up_left+0
;draw_letters.c,17 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,18 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,19 :: 		draw_up();
	CALL       _draw_up+0
;draw_letters.c,20 :: 		draw_right();
	CALL       _draw_right+0
;draw_letters.c,21 :: 		draw_down_right();
	CALL       _draw_down_right+0
;draw_letters.c,22 :: 		draw_up_left();
	CALL       _draw_up_left+0
;draw_letters.c,23 :: 		}
L_end_draw_a:
	RETURN
; end of _draw_a

_draw_i:

;draw_letters.c,25 :: 		void draw_i(void) { //TODO return to origin
;draw_letters.c,26 :: 		draw_right();
	CALL       _draw_right+0
;draw_letters.c,27 :: 		draw_right();
	CALL       _draw_right+0
;draw_letters.c,28 :: 		draw_left();
	CALL       _draw_left+0
;draw_letters.c,29 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,30 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,31 :: 		draw_right();
	CALL       _draw_right+0
;draw_letters.c,32 :: 		draw_left();
	CALL       _draw_left+0
;draw_letters.c,33 :: 		draw_left();
	CALL       _draw_left+0
;draw_letters.c,34 :: 		}
L_end_draw_i:
	RETURN
; end of _draw_i

_draw_h:

;draw_letters.c,36 :: 		void draw_h(void) {
;draw_letters.c,37 :: 		draw_left();
	CALL       _draw_left+0
;draw_letters.c,38 :: 		draw_up();
	CALL       _draw_up+0
;draw_letters.c,39 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,40 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,41 :: 		draw_up();
	CALL       _draw_up+0
;draw_letters.c,42 :: 		draw_right();
	CALL       _draw_right+0
;draw_letters.c,43 :: 		draw_right();
	CALL       _draw_right+0
;draw_letters.c,44 :: 		draw_up();
	CALL       _draw_up+0
;draw_letters.c,45 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,46 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,47 :: 		draw_up();
	CALL       _draw_up+0
;draw_letters.c,48 :: 		}
L_end_draw_h:
	RETURN
; end of _draw_h

_draw_l:

;draw_letters.c,50 :: 		void draw_l(void) {
;draw_letters.c,51 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,52 :: 		draw_left();
	CALL       _draw_left+0
;draw_letters.c,53 :: 		draw_up();
	CALL       _draw_up+0
;draw_letters.c,54 :: 		draw_up();
	CALL       _draw_up+0
;draw_letters.c,55 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,56 :: 		draw_right();
	CALL       _draw_right+0
;draw_letters.c,58 :: 		}
L_end_draw_l:
	RETURN
; end of _draw_l

_move_next_letter:

;draw_letters.c,59 :: 		void move_next_letter(void) { //TODO: change to move_right();
;draw_letters.c,60 :: 		draw_right();
	CALL       _draw_right+0
;draw_letters.c,61 :: 		draw_right();
	CALL       _draw_right+0
;draw_letters.c,62 :: 		}
L_end_move_next_letter:
	RETURN
; end of _move_next_letter

_enter_new_line:

;draw_letters.c,65 :: 		void enter_new_line(void) {
;draw_letters.c,66 :: 		for(times = 0; times<6; times++) draw_left();
	CLRF       _times+0
L_enter_new_line0:
	MOVLW      6
	SUBWF      _times+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_enter_new_line1
	CALL       _draw_left+0
	INCF       _times+0, 1
	GOTO       L_enter_new_line0
L_enter_new_line1:
;draw_letters.c,67 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,68 :: 		draw_down();
	CALL       _draw_down+0
;draw_letters.c,69 :: 		}
L_end_enter_new_line:
	RETURN
; end of _enter_new_line
