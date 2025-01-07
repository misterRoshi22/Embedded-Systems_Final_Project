#include "../include/atd.h"
#include "../include/lcd_config.h"
#include "../include/draw_base.h"
#include "../include/timer_init.h"
#include "../include/misc.h"
// Variables
unsigned int analog_value;
unsigned char timer_value;
char print_string[7];
unsigned char update_lcd = 0;
unsigned char HL = 1;    // High Low
unsigned int angle;
unsigned char times;
unsigned char speed = 500;

unsigned char char_count = 0; // Variable to keep track of character count
unsigned char letter = 0x00;  // Variable to store Braille input

const char LETTER_PER_LINE = 20;
const unsigned int SERVO_UP = 1800;
const unsigned int SERVO_DOWN = 1000;
unsigned int k;
unsigned char myscaledVoltage;

char print_angle[7];

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

void Delay(unsigned int delay);

void pen_up(void);
void pen_down(void);

void draw_a(void);
void draw_b(void);
void draw_e(void);
void draw_f(void);
void draw_h(void);
void draw_i(void);
void draw_k(void);
void draw_l(void);
void draw_space(void);

void move_next_letter(void);
void enter_new_line(void);


void interrupt(void) {

    if (INTCON & 0x04) {    // STEPPER MOTOR 1 Toggle
        PORTC ^= 0x02;      // Toggle RC1 (example action for Timer0)
        INTCON &= ~0x04;    // Clear T0IF
        TMR0 = 0xF0;        // Reload Timer0 if necessary
    }

    if (PIR1 & 0x02) {      // STEPPER MOTOR 2 Toggle
        PORTC ^= 0x08;      // Toggle RC3 (example action for Timer2)
        PIR1 &= ~0x02;      // Clear TMR2IF
    }

if(PIR1 & 0x04){                                           // CCP1 interrupt
             if(HL){                                // high
                       CCPR1H = angle >> 8;
                       CCPR1L = angle;
                       HL = 0;                      // next time low
                       CCP1CON = 0x09;              // compare mode, clear output on match
                       TMR1H = 0;
                       TMR1L = 0;
             }
             else{                                          //low
                       CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
                       CCPR1L = (40000 - angle);
                       CCP1CON = 0x08;             // compare mode, set output on match
                       HL = 1;                     //next time High
                       TMR1H = 0;
                       TMR1L = 0;
             }

             PIR1 = PIR1&0xFB;
       }


}

void main() {
    TRISC = 0x00;  // Set all PORTC pins as output
    PORTC = 0xC0;  // Clear PORTC, set enables to 0 active low
    ATD_init();

    //FOR TESTING PURPOSES ONLY
    TRISD = 0xFF;

    // Initialize Timers
    Timer0_Init();  // Initialize Timer0
    Timer2_Init();  // Initialize Timer2
    Timer1_Init();  // Initialize Timer1

    Lcd_Init();
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Cmd(_LCD_CLEAR);
    //Lcd_Out(1,1,"Hello!!");

    // Enable global interrupts
    INTCON |= 0x80; // Global Interrupt Enable (GIE)
    INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)

    while (1) {
    
    speed = ATD_read(0);
    speed >> 2;
    
       if ((PORTD & 0x40) == 0x40) {  // Check if enter is pressed
            delay_ms(50);
                if (char_count == LETTER_PER_LINE) {
                            Lcd_Cmd(_LCD_SECOND_ROW);
                            enter_new_line();
                }
                else if(char_count == 2*LETTER_PER_LINE) {
                            Lcd_Cmd(_LCD_THIRD_ROW);
                            enter_new_line();
                }
                else if(char_count == 3*LETTER_PER_LINE) {
                            Lcd_Cmd(_LCD_FOURTH_ROW);
                            enter_new_line();
                }
                else if(char_count == 4*LETTER_PER_LINE){
                            Lcd_Cmd(_LCD_CLEAR);
                            enter_new_line();
                            char_count == 0;
                }
                Lcd_Chr_Cp(braille_map[letter]); // Display character on LCD
                char_count++;

                if(braille_map[letter] == 'a') draw_a();
                if(braille_map[letter] == 'b') draw_b();
                if(braille_map[letter] == 'e') draw_e();
                if(braille_map[letter] == 'f') draw_f();
                if(braille_map[letter] == 'h') draw_h();
                if(braille_map[letter] == 'i') draw_i();
                if(braille_map[letter] == 'k') draw_k();
                if(braille_map[letter] == 'l') draw_l();

                letter = 0x00;
                move_next_letter();

                while ((PORTD & 0x40) == 0x40);
                delay_ms(50);
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

void pen_up(void) {
angle = SERVO_UP;
Delay(100);
}

void pen_down(void) {
 angle = SERVO_DOWN;
 Delay(100);
}

void draw_a(void) {
  draw_up_left(speed);
  draw_down(speed);
  draw_down(speed);
  draw_up(speed);
  draw_right(speed);
  draw_down_right(speed);
  pen_up();
  draw_up_left(speed);
  pen_down();
}

void draw_b(void) { //NO CURVES
   draw_right(speed);
   draw_up(speed);
   draw_up(speed);
   draw_down(speed);
   draw_right(speed);
   draw_down(speed);
   draw_left(speed);
   draw_left(speed);
   draw_up(speed);
   draw_right(speed);
}

void draw_e(void) {
  draw_left(speed);
  draw_up(speed);
  draw_right(speed);
pen_up();
  draw_down(speed);
  draw_down(speed);
pen_down();
  draw_left(speed);
  draw_up(speed);
  draw_right(speed);
}

void draw_f(void) {
  draw_left(speed);
  draw_up(speed);
  draw_right(speed);
  pen_up();
  draw_down(speed);
pen_down();
  draw_right(speed);
  draw_down(speed);
  draw_up(speed);
  draw_right(speed);
}


void draw_h(void) {
  draw_left(speed);
  draw_up(speed);
  draw_down(speed);
  draw_down(speed);
pen_up();
  draw_right(speed);
  draw_right(speed);

  draw_up(speed);
   draw_up(speed);
  draw_down(speed);
  draw_left(speed);
}

void draw_i(void) { //TODO return to origin
  draw_up(speed);
  draw_right(speed);
  draw_left(speed);
  draw_left(speed);
pen_up();
  draw_down(speed);
  draw_down(speed);
pen_down();
  draw_right(speed);
  draw_right(speed);
  draw_left(speed);
  draw_up(speed);
}

void draw_k(void) {
  draw_up_right(speed);
pen_up();
  draw_down(speed);
  draw_down(speed);
pen_down();
  draw_up_left(speed);
  draw_up(speed);
  draw_down(speed);
  draw_down(speed);
  draw_up(speed);
}

void draw_l(void) {
  draw_up(speed);
  draw_down(speed);
  draw_down(speed);
  draw_right(speed);
  draw_left(speed);
  draw_up(speed);
}

void draw_space(void) {
     pen_up();
     draw_right(speed);
     draw_right(speed);
     draw_right(speed);
     draw_right(speed);
     pen_down();
}

void move_next_letter(void) {
pen_up();
  draw_right(speed);
  draw_right(speed);
pen_down();
}

void enter_new_line(void) {
pen_up();
  for(times = 0; times<2*(LETTER_PER_LINE-1); times++) draw_left(speed);
  draw_down(speed);
  draw_down(speed);
pen_down();
}