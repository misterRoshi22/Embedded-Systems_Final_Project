#include "../include/atd.h"

// Function to initialize ADC
void ATD_init(void) {
    ADCON0 = 0x41;   // ADC enabled, Fosc/16, Channel 0 (AN0)
    ADCON1 = 0xCE;   // All pins digital except AN0 and AN1, right justified
    TRISA  = 0x03;   // Configure RA0/AN0 and RA1/AN1 as inputs
}

// Function to read analog value from a specified channel (AN0 or AN1)
unsigned int ATD_read(unsigned char channel) {
    // Select the ADC channel
    ADCON0 &= 0xC7;           // Clear channel selection bits (CHS0–CHS3)
    ADCON0 |= (channel << 3); // Set channel (channel 0 = AN0, channel 1 = AN1)

    ADCON0 |= 0x04;           // Start ADC conversion
    while (ADCON0 & 0x04);    // Wait for conversion to complete

    return ((ADRESH << 8) | ADRESL);  // Return 10-bit result (0..1023)
}

