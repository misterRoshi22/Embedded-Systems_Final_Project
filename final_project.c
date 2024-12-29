// LCD module connections
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;

unsigned char char_count = 0; // Variable to keep track of character count
unsigned char letter = 0x00;  // Variable to store Braille input

char braille_map[64] = {
    ' ', '!', '!', '!', '!', '!', '!', '1',  // 0x00 - 0x07
    '!', '!', '!', '!', '!', '!', '!', '1',  // 0x08 - 0x0F
    '!', '!', '!', '!', '!', '!', '!', '1',  // 0x10 - 0x17
    'i', '!', 's', '!', 'j', 'w', 't', '!',  // 0x18 - 0x1F
    'a', '!', 'k', 'u', 'e', '!', 'o', 'z',  // 0x20 - 0x27
    'b', '!', 'l', 'v', 'h', '!', 'r', '!',  // 0x28 - 0x2F
    'c', '!', 'm', 'x', 'd', '!', 'n', 'y',  // 0x30 - 0x37
    'f', '!', 'p', '!', 'g', '!', 'q', '!',  // 0x38 - 0x3F
};

void main() {
    // Initialize LCD and configure ports
    TRISD = 0xFF; // Set PORTD as input
    TRISB = 0x00; // Set PORTB as output (for LCD)
    //TRISD = 0xFF; // Set PORTD as input (for Enter button)

    Lcd_Init();               // Initialize LCD
    Lcd_Cmd(_LCD_CLEAR);      // Clear display
   // Lcd_Cmd(_LCD_CURSOR_ON);  // Turn on cursor

    while (1) {
                if (char_count > 31) { // Reset after filling both rows
                Lcd_Cmd(_LCD_CLEAR);
                char_count = 0;
            }
        // Check if "Enter" button on PORTD6 is pressed
        if ((PORTD & 0x40) == 0x40) {
            if (char_count == 16) {
                Lcd_Cmd(_LCD_SECOND_ROW); // Move cursor to second row
            }

            Lcd_Chr_Cp(braille_map[letter]); // Display character on LCD
            char_count++;



            letter = 0x00; // Reset the letter after printing
            while ((PORTD & 0x40) == 0x40); // Wait for button release (debouncing)
        }

        // Read button inputs and update the Braille `letter`
        if ((PORTD & 0x01) == 0x01) letter |= 0x01; // Set bit 0
        if ((PORTD & 0x02) == 0x02) letter |= 0x02; // Set bit 1
        if ((PORTD & 0x04) == 0x04) letter |= 0x04; // Set bit 2
        if ((PORTD & 0x08) == 0x08) letter |= 0x08; // Set bit 3
        if ((PORTD & 0x10) == 0x10) letter |= 0x10; // Set bit 4
        if ((PORTD & 0x20) == 0x20) letter |= 0x20; // Set bit 5
        if ((PORTD & 0x80) == 0x80) letter = 0x00;  // Clear all bits
    }


}