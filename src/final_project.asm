
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;final_project.c,26 :: 		void interrupt(void){
;final_project.c,28 :: 		if(PIR1 & 0x04){                                           // CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt0
;final_project.c,29 :: 		if(HL){                                // high
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt1
;final_project.c,30 :: 		CCPR1H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;final_project.c,31 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;final_project.c,32 :: 		HL = 0;                      // next time low
	CLRF       _HL+0
;final_project.c,33 :: 		CCP1CON = 0x09;              // compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP1CON+0
;final_project.c,34 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,35 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,36 :: 		}
	GOTO       L_interrupt2
L_interrupt1:
;final_project.c,38 :: 		CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
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
;final_project.c,39 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;final_project.c,40 :: 		CCP1CON = 0x08;             // compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;final_project.c,41 :: 		HL = 1;                     //next time High
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,42 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,43 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,44 :: 		}
L_interrupt2:
;final_project.c,46 :: 		PIR1 = PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;final_project.c,47 :: 		}
L_interrupt0:
;final_project.c,50 :: 		}
L_end_interrupt:
L__interrupt10:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;final_project.c,53 :: 		void main() {
;final_project.c,54 :: 		TRISC = 0x00;           // PWM output at CCP1(RC2)
	CLRF       TRISC+0
;final_project.c,55 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;final_project.c,56 :: 		TRISD = 0x00;           // for 7 seg display
	CLRF       TRISD+0
;final_project.c,57 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;final_project.c,58 :: 		ATD_init();
	CALL       _ATD_init+0
;final_project.c,59 :: 		PORTA = 0x08;          // Enable 4th seven segment display
	MOVLW      8
	MOVWF      PORTA+0
;final_project.c,60 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;final_project.c,61 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;final_project.c,63 :: 		HL = 1;                // start high
	MOVLW      1
	MOVWF      _HL+0
;final_project.c,64 :: 		CCP1CON = 0x08;        // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;final_project.c,66 :: 		T1CON = 0x01;          // TMR1 On Fosc/4 (inc 0.5uS) with 0 prescaler (TMR1 overflow after 0xFFFF counts == 65535)==> 32.767ms
	MOVLW      1
	MOVWF      T1CON+0
;final_project.c,68 :: 		INTCON = 0xC0;         // Enable GIE and peripheral interrupts
	MOVLW      192
	MOVWF      INTCON+0
;final_project.c,69 :: 		PIE1 = PIE1|0x04;      // Enable CCP1 interrupts
	BSF        PIE1+0, 2
;final_project.c,70 :: 		CCPR1H = 2000>>8;      // Value preset in a program to compare the TMR1H value to            - 1ms
	MOVLW      7
	MOVWF      CCPR1H+0
;final_project.c,71 :: 		CCPR1L = 2000;         // Value preset in a program to compare the TMR1L value to
	MOVLW      208
	MOVWF      CCPR1L+0
;final_project.c,73 :: 		Lcd_Init();               // Initialize LCD
	CALL       _Lcd_Init+0
;final_project.c,74 :: 		Lcd_Cmd(_LCD_CLEAR);      // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,75 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;final_project.c,78 :: 		while(1){
L_main3:
;final_project.c,79 :: 		k = ATD_read();  // 0-1023
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       FLOC__main+0, 0
	MOVWF      _k+0
	MOVF       FLOC__main+1, 0
	MOVWF      _k+1
;final_project.c,80 :: 		myscaledVoltage = ((k*5)/1023); // 0-5
	MOVF       FLOC__main+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+1, 0
	MOVWF      R0+1
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
	MOVWF      _myscaledVoltage+0
;final_project.c,81 :: 		PORTD = mysevenseg[myscaledVoltage];
	MOVF       R0+0, 0
	ADDLW      _mysevenseg+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;final_project.c,83 :: 		k = k>>2;  // divided by 4 ==> 0-255
	MOVF       FLOC__main+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      _k+0
	MOVF       R0+1, 0
	MOVWF      _k+1
;final_project.c,85 :: 		angle = 1000 + ((k*25)/2.55);     //angle= 1000 + ((k*2500)/255); 1000count=500uS to 3500count =1750us
	MOVLW      25
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	CALL       _word2double+0
	MOVLW      51
	MOVWF      R4+0
	MOVLW      51
	MOVWF      R4+1
	MOVLW      35
	MOVWF      R4+2
	MOVLW      128
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      122
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	CALL       _double2word+0
	MOVF       R0+0, 0
	MOVWF      _angle+0
	MOVF       R0+1, 0
	MOVWF      _angle+1
;final_project.c,86 :: 		if(angle>3500) angle = 3500;      // 1.75ms
	MOVF       R0+1, 0
	SUBLW      13
	BTFSS      STATUS+0, 2
	GOTO       L__main12
	MOVF       R0+0, 0
	SUBLW      172
L__main12:
	BTFSC      STATUS+0, 0
	GOTO       L_main5
	MOVLW      172
	MOVWF      _angle+0
	MOVLW      13
	MOVWF      _angle+1
L_main5:
;final_project.c,87 :: 		if(angle<1000) angle = 1000;      // 0.5ms
	MOVLW      3
	SUBWF      _angle+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main13
	MOVLW      232
	SUBWF      _angle+0, 0
L__main13:
	BTFSC      STATUS+0, 0
	GOTO       L_main6
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
L_main6:
;final_project.c,88 :: 		IntToStr(angle, print_angle);
	MOVF       _angle+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _angle+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _print_angle+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;final_project.c,89 :: 		Lcd_Out(1,1,"angle: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_final_project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,90 :: 		Lcd_Out(1, 8, print_angle);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _print_angle+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;final_project.c,91 :: 		}
	GOTO       L_main3
;final_project.c,93 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_ATD_init:

;final_project.c,96 :: 		void ATD_init(void){
;final_project.c,97 :: 		ADCON0=0x41;           // ON, Channel 0, Fosc/16== 500KHz, Dont Go
	MOVLW      65
	MOVWF      ADCON0+0
;final_project.c,98 :: 		ADCON1=0xCE;           // RA0 Analog, others are Digital, Right Allignment,
	MOVLW      206
	MOVWF      ADCON1+0
;final_project.c,99 :: 		TRISA=0x01;
	MOVLW      1
	MOVWF      TRISA+0
;final_project.c,100 :: 		}
L_end_ATD_init:
	RETURN
; end of _ATD_init

_ATD_read:

;final_project.c,101 :: 		unsigned int ATD_read(void){
;final_project.c,102 :: 		ADCON0=ADCON0 | 0x04;  // GO
	BSF        ADCON0+0, 2
;final_project.c,103 :: 		while(ADCON0&0x04);    // wait until DONE
L_ATD_read7:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read8
	GOTO       L_ATD_read7
L_ATD_read8:
;final_project.c,104 :: 		return (ADRESH<<8)|ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;final_project.c,105 :: 		}
L_end_ATD_read:
	RETURN
; end of _ATD_read
