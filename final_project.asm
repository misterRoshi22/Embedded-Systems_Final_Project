
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;final_project.c,8 :: 		interrupt() { // TMR0 overflow interrupt occurs every 32ms
;final_project.c,9 :: 		tick++; // Increment tick every 32ms
	INCF       _tick+0, 1
;final_project.c,10 :: 		if (tick == 16) { // This condition is true approximately every 500ms
	MOVF       _tick+0, 0
	XORLW      16
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt0
;final_project.c,11 :: 		tick = 0;
	CLRF       _tick+0
;final_project.c,12 :: 		myreading = ATD_read();
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _myreading+0
	MOVF       R0+1, 0
	MOVWF      _myreading+1
;final_project.c,13 :: 		PORTB = myreading;         // Display on PORTB the lower 8 bits of myreading
	MOVF       R0+0, 0
	MOVWF      PORTB+0
;final_project.c,14 :: 		PORTC = myreading >> 8;    // Display on PORTC the higher 8 bits by shifting 8 positions
	MOVF       R0+1, 0
	MOVWF      R2+0
	CLRF       R2+1
	MOVF       R2+0, 0
	MOVWF      PORTC+0
;final_project.c,15 :: 		myVoltage = (unsigned int)(myreading * 50) / 1023;
	MOVLW      50
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
	MOVWF      _myVoltage+0
	MOVF       R0+1, 0
	MOVWF      _myVoltage+1
;final_project.c,16 :: 		}
L_interrupt0:
;final_project.c,17 :: 		INTCON = INTCON & 0xFB; // Clear the interrupt flag
	MOVLW      251
	ANDWF      INTCON+0, 1
;final_project.c,18 :: 		}
L_end_interrupt:
L__interrupt8:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;final_project.c,20 :: 		void main() {
;final_project.c,22 :: 		TRISB = 0x00;
	CLRF       TRISB+0
;final_project.c,23 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;final_project.c,24 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;final_project.c,27 :: 		ATD_init();
	CALL       _ATD_init+0
;final_project.c,30 :: 		OPTION_REG = 0x07; // Oscillator clock / 4, prescale of 256
	MOVLW      7
	MOVWF      OPTION_REG+0
;final_project.c,31 :: 		INTCON = 0xA0;     // Enable global interrupt and TMR0 overflow interrupt
	MOVLW      160
	MOVWF      INTCON+0
;final_project.c,32 :: 		TMR0 = 0;
	CLRF       TMR0+0
;final_project.c,35 :: 		while (1) {
L_main1:
;final_project.c,36 :: 		delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	NOP
	NOP
;final_project.c,37 :: 		PORTA = 0x04;
	MOVLW      4
	MOVWF      PORTA+0
;final_project.c,38 :: 		PORTD = mysevenseg[myVoltage % 10]; // Display first digit
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _myVoltage+0, 0
	MOVWF      R0+0
	MOVF       _myVoltage+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      _mysevenseg+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;final_project.c,39 :: 		delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	NOP
	NOP
;final_project.c,40 :: 		PORTA = 0x08;
	MOVLW      8
	MOVWF      PORTA+0
;final_project.c,41 :: 		PORTD = (mysevenseg[myVoltage / 10]) | 0x80; // Display second digit
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _myVoltage+0, 0
	MOVWF      R0+0
	MOVF       _myVoltage+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	ADDLW      _mysevenseg+0
	MOVWF      FSR
	MOVLW      128
	IORWF      INDF+0, 0
	MOVWF      PORTD+0
;final_project.c,42 :: 		}
	GOTO       L_main1
;final_project.c,43 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_ATD_init:

;final_project.c,45 :: 		void ATD_init(void) {
;final_project.c,46 :: 		ADCON0 = 0x41; // ATD ON, Don't GO, Channel 0, Fosc/16
	MOVLW      65
	MOVWF      ADCON0+0
;final_project.c,47 :: 		ADCON1 = 0xCE; // All channels are digital except RA0/AN0 is analog, 500 kHz, right justified
	MOVLW      206
	MOVWF      ADCON1+0
;final_project.c,48 :: 		TRISA = 0x01;  // Set RA0/AN0 as input
	MOVLW      1
	MOVWF      TRISA+0
;final_project.c,49 :: 		}
L_end_ATD_init:
	RETURN
; end of _ATD_init

_ATD_read:

;final_project.c,51 :: 		unsigned int ATD_read(void) {
;final_project.c,52 :: 		ADCON0 = ADCON0 | 0x04; // Start conversion (GO bit set)
	BSF        ADCON0+0, 2
;final_project.c,53 :: 		while (ADCON0 & 0x04);  // Wait for conversion to complete
L_ATD_read5:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read6
	GOTO       L_ATD_read5
L_ATD_read6:
;final_project.c,54 :: 		return ((ADRESH << 8) | ADRESL); // Combine high and low bits of the result
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;final_project.c,55 :: 		}
L_end_ATD_read:
	RETURN
; end of _ATD_read
