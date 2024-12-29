
_IntToStr:

	CLRF       IntToStr_i_L0+0
	CLRF       IntToStr_i_L0+1
	MOVF       FARG_IntToStr_num+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_IntToStr0
	MOVF       FARG_IntToStr_str+0, 0
	MOVWF      FSR
	MOVLW      48
	MOVWF      INDF+0
	INCF       FARG_IntToStr_str+0, 0
	MOVWF      FSR
	CLRF       INDF+0
	GOTO       L_end_IntToStr
L_IntToStr0:
L_IntToStr1:
	MOVF       FARG_IntToStr_num+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_IntToStr2
	MOVF       IntToStr_i_L0+0, 0
	ADDLW      IntToStr_temp_L0+0
	MOVWF      FLOC__IntToStr+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_IntToStr_num+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__IntToStr+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       IntToStr_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       IntToStr_i_L0+1, 1
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_IntToStr_num+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_num+0
	GOTO       L_IntToStr1
L_IntToStr2:
	MOVF       IntToStr_i_L0+0, 0
	ADDLW      IntToStr_temp_L0+0
	MOVWF      FSR
	CLRF       INDF+0
	MOVF       IntToStr_i_L0+0, 0
	MOVWF      IntToStr_length_L0+0
	MOVF       IntToStr_i_L0+1, 0
	MOVWF      IntToStr_length_L0+1
	CLRF       IntToStr_j_L0+0
	CLRF       IntToStr_j_L0+1
L_IntToStr3:
	MOVLW      128
	XORWF      IntToStr_j_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      IntToStr_length_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__IntToStr13
	MOVF       IntToStr_length_L0+0, 0
	SUBWF      IntToStr_j_L0+0, 0
L__IntToStr13:
	BTFSC      STATUS+0, 0
	GOTO       L_IntToStr4
	MOVF       IntToStr_j_L0+0, 0
	ADDWF      FARG_IntToStr_str+0, 0
	MOVWF      R2+0
	MOVF       IntToStr_j_L0+0, 0
	SUBWF      IntToStr_length_L0+0, 0
	MOVWF      R0+0
	MOVF       IntToStr_j_L0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      IntToStr_length_L0+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      R0+0, 1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      IntToStr_temp_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       IntToStr_j_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       IntToStr_j_L0+1, 1
	GOTO       L_IntToStr3
L_IntToStr4:
	MOVF       IntToStr_length_L0+0, 0
	ADDWF      FARG_IntToStr_str+0, 0
	MOVWF      FSR
	CLRF       INDF+0
L_end_IntToStr:
	RETURN
; end of _IntToStr

_main:

	CLRF       TRISB+0
	CALL       _Lcd_Init+0
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
	CALL       _ATD_init+0
	MOVLW      96
	MOVWF      TRISC+0
	CALL       _CCPPWM_init+0
	MOVLW      231
	ANDWF      PORTC+0, 1
L_main6:
	BTFSS      PORTC+0, 5
	GOTO       L_main8
	MOVLW      24
	IORWF      PORTC+0, 1
L_main8:
	BTFSS      PORTC+0, 6
	GOTO       L_main9
	MOVLW      231
	ANDWF      PORTC+0, 1
L_main9:
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      main_k_L0+0
	MOVF       R0+1, 0
	MOVWF      main_k_L0+1
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_num+0
	MOVLW      _print_out+0
	MOVWF      FARG_IntToStr_str+0
	CALL       _IntToStr+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_out+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	MOVF       main_k_L0+0, 0
	MOVWF      FARG_IntToStr_num+0
	MOVLW      _print_out+0
	MOVWF      FARG_IntToStr_str+0
	CALL       _IntToStr+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_out+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	MOVF       main_k_L0+0, 0
	MOVWF      R0+0
	MOVF       main_k_L0+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVLW      250
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _myspeed+0
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_num+0
	MOVLW      _print_out+0
	MOVWF      FARG_IntToStr_str+0
	CALL       _IntToStr+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_out+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	MOVF       _myspeed+0, 0
	MOVWF      FARG_motor1+0
	CALL       _motor1+0
	MOVLW      125
	MOVWF      FARG_motor2+0
	CALL       _motor2+0
	GOTO       L_main6
L_end_main:
	GOTO       $+0
; end of _main

_ATD_init:

	MOVLW      65
	MOVWF      ADCON0+0
	MOVLW      206
	MOVWF      ADCON1+0
	MOVLW      1
	MOVWF      TRISA+0
L_end_ATD_init:
	RETURN
; end of _ATD_init

_ATD_read:

	BSF        ADCON0+0, 2
L_ATD_read10:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read11
	GOTO       L_ATD_read10
L_ATD_read11:
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
L_end_ATD_read:
	RETURN
; end of _ATD_read

_CCPPWM_init:

	MOVLW      7
	MOVWF      T2CON+0
	MOVLW      12
	MOVWF      CCP1CON+0
	MOVLW      12
	MOVWF      CCP2CON+0
	MOVLW      250
	MOVWF      PR2+0
	MOVLW      96
	MOVWF      TRISC+0
	MOVLW      125
	MOVWF      CCPR1L+0
	MOVLW      125
	MOVWF      CCPR2L+0
L_end_CCPPWM_init:
	RETURN
; end of _CCPPWM_init

_motor1:

	MOVF       FARG_motor1_speed+0, 0
	MOVWF      CCPR1L+0
L_end_motor1:
	RETURN
; end of _motor1

_motor2:

	MOVF       FARG_motor2_speed+0, 0
	MOVWF      CCPR2L+0
L_end_motor2:
	RETURN
; end of _motor2
