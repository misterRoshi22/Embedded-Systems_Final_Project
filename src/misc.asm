
_Delay:

;misc.c,3 :: 		void Delay(unsigned int delay) {
;misc.c,4 :: 		while (delay--) {
L_Delay0:
	MOVF       FARG_Delay_delay+0, 0
	MOVWF      R0+0
	MOVF       FARG_Delay_delay+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      FARG_Delay_delay+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_Delay_delay+1, 1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Delay1
;misc.c,5 :: 		Delay_ms(1); // Delay 1 ms at a time
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_Delay2:
	DECFSZ     R13+0, 1
	GOTO       L_Delay2
	DECFSZ     R12+0, 1
	GOTO       L_Delay2
	NOP
	NOP
;misc.c,6 :: 		}
	GOTO       L_Delay0
L_Delay1:
;misc.c,7 :: 		}
L_end_Delay:
	RETURN
; end of _Delay
