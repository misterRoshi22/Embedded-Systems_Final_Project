
_ATD_init:

;atd.c,4 :: 		void ATD_init(void) {
;atd.c,5 :: 		ADCON0 = 0x41;   // ADC enabled, Fosc/16, Channel 0 (AN0)
	MOVLW      65
	MOVWF      ADCON0+0
;atd.c,6 :: 		ADCON1 = 0xCE;   // All pins digital except AN0 and AN1, right justified
	MOVLW      206
	MOVWF      ADCON1+0
;atd.c,7 :: 		TRISA  = 0x03;   // Configure RA0/AN0 and RA1/AN1 as inputs
	MOVLW      3
	MOVWF      TRISA+0
;atd.c,8 :: 		}
L_end_ATD_init:
	RETURN
; end of _ATD_init

_ATD_read:

;atd.c,11 :: 		unsigned int ATD_read(unsigned char channel) {
;atd.c,13 :: 		ADCON0 &= 0xC7;           // Clear channel selection bits (CHS0–CHS3)
	MOVLW      199
	ANDWF      ADCON0+0, 1
;atd.c,14 :: 		ADCON0 |= (channel << 3); // Set channel (channel 0 = AN0, channel 1 = AN1)
	MOVF       FARG_ATD_read_channel+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      ADCON0+0, 1
;atd.c,16 :: 		ADCON0 |= 0x04;           // Start ADC conversion
	BSF        ADCON0+0, 2
;atd.c,17 :: 		while (ADCON0 & 0x04);    // Wait for conversion to complete
L_ATD_read0:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read1
	GOTO       L_ATD_read0
L_ATD_read1:
;atd.c,19 :: 		return ((ADRESH << 8) | ADRESL);  // Return 10-bit result (0..1023)
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;atd.c,20 :: 		}
L_end_ATD_read:
	RETURN
; end of _ATD_read
