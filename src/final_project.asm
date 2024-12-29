
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

	BTFSS      PIR1+0, 2
	GOTO       L_interrupt0
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt1
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
	CLRF       _HL+0
	MOVLW      9
	MOVWF      CCP1CON+0
	CLRF       TMR1H+0
	CLRF       TMR1L+0
	GOTO       L_interrupt2
L_interrupt1:
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
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
	MOVLW      8
	MOVWF      CCP1CON+0
	MOVLW      1
	MOVWF      _HL+0
	CLRF       TMR1H+0
	CLRF       TMR1L+0
L_interrupt2:
	MOVLW      251
	ANDWF      PIR1+0, 1
L_interrupt0:
L_end_interrupt:
L__interrupt9:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

	CLRF       TRISC+0
	CLRF       PORTC+0
	MOVLW      3
	MOVWF      TRISB+0
	CLRF       PORTB+0
	CLRF       TMR1H+0
	CLRF       TMR1L+0
	MOVLW      1
	MOVWF      _HL+0
	MOVLW      8
	MOVWF      CCP1CON+0
	MOVLW      1
	MOVWF      T1CON+0
	MOVLW      192
	MOVWF      INTCON+0
	BSF        PIE1+0, 2
	MOVLW      7
	MOVWF      CCPR1H+0
	MOVLW      208
	MOVWF      CCPR1L+0
L_main3:
	BTFSS      PORTB+0, 0
	GOTO       L_main5
	MOVLW      196
	MOVWF      _angle+0
	MOVLW      9
	MOVWF      _angle+1
	GOTO       L_main6
L_main5:
	BTFSS      PORTB+0, 1
	GOTO       L_main7
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
L_main7:
L_main6:
	GOTO       L_main3
L_end_main:
	GOTO       $+0
; end of _main
