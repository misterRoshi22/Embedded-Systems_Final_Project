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
unsigned char size = 500;

unsigned char char_count = 0; // Variable to keep track of character count
unsigned char letter = 0x00;  // Variable to store Braille input

const char letters_per_line = 20;
const unsigned int SERVO_UP = 1800;
const unsigned int SERVO_DOWN = 1000;
unsigned int k;
unsigned char myscaledVoltage;

char print_speed[7];
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
void draw_c(void);
void draw_d(void);
void draw_e(void);
void draw_f(void);
void draw_g(void);
void draw_h(void);
void draw_i(void);
void draw_j(void);
void draw_k(void);
void draw_l(void);
void draw_m(void);
void draw_n(void);
void draw_o(void);
void draw_p(void);
void draw_q(void);
void draw_r(void);
void draw_s(void);
void draw_t(void);
void draw_u(void);
void draw_v(void);
void draw_w(void);
void draw_x(void);
void draw_y(void);
void draw_z(void);
void draw_space(void);

void move_next_letter(void);
void enter_new_line(void);


void interrupt(void) {

    if (INTCON & 0x04) {    // STEPPER MOTOR 1 Toggle
        PORTC ^= 0x02;      // toggle RC1
        PORTC ^= 0x08;      // toggle RC3
        INTCON &= ~0x04;    // clear T0IF
        TMR0 = 0xF0;        // reload Timer0
    }

    /*if (PIR1 & 0x02) {      // STEPPER MOTOR 2 Toggle
        PORTC ^= 0x08;      // Toggle RC3 (example action for Timer2)
        PIR1 &= ~0x02;      // Clear TMR2IF
    }*/

    if(PIR1 & 0x04){                                    // Servo Motor CCP1 interrupt
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

    TRISD = 0xFF;

    // Initialize Timers
    Timer0_Init();  // Initialize Timer0
    //Timer2_Init();  // Initialize Timer2
    Timer1_Init();  // Initialize Timer1

    Lcd_Init();
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Cmd(_LCD_CLEAR);
    //Lcd_Out(1,1,"Hello!!");

    // Enable global interrupts
    INTCON |= 0x80; // Global Interrupt Enable (GIE)
    INTCON |= 0x40; // Peripheral Interrupt Enable (PIE)

    while (1) {
    
      size = ATD_read(0);
      size = 50 + ((size * (150 - 50)) / 242); //  50-150
      //IntToStr(size, print_speed);
      //Lcd_Out(1, 1, print_speed);

    
       if ((PORTD & 0x40) == 0x40) {  // Check if enter is pressed
            Delay(50);
                if (char_count == letters_per_line) {
                            Lcd_Cmd(_LCD_SECOND_ROW);
                            enter_new_line();
                }
                else if(char_count == 2*letters_per_line) {
                            Lcd_Cmd(_LCD_THIRD_ROW);
                            enter_new_line();
                }
                else if(char_count == 3*letters_per_line) {
                            Lcd_Cmd(_LCD_FOURTH_ROW);
                            enter_new_line();
                }
                else if(char_count == 4*letters_per_line){
                            Lcd_Cmd(_LCD_CLEAR);
                            enter_new_line();
                            char_count == 0;
                }
                Lcd_Chr_Cp(braille_map[letter]); // Display character on LCD
                char_count++;

               if(braille_map[letter] == 'a') draw_a();
                if(braille_map[letter] == 'b') draw_b();
                if(braille_map[letter] == 'c') draw_c();
                if(braille_map[letter] == 'd') draw_d();
                if(braille_map[letter] == 'e') draw_e();
                if(braille_map[letter] == 'f') draw_f();
                if(braille_map[letter] == 'g') draw_g();
                if(braille_map[letter] == 'h') draw_h();
                if(braille_map[letter] == 'i') draw_i();
                if(braille_map[letter] == 'j') draw_j();
                if(braille_map[letter] == 'k') draw_k();
                if(braille_map[letter] == 'l') draw_l();
                if(braille_map[letter] == 'm') draw_m();
                if(braille_map[letter] == 'n') draw_n();
                if(braille_map[letter] == 'o') draw_o();
                if(braille_map[letter] == 'p') draw_p();
                if(braille_map[letter] == 'q') draw_q();
                if(braille_map[letter] == 'r') draw_r();
                if(braille_map[letter] == 's') draw_s();
                if(braille_map[letter] == 't') draw_t();
                if(braille_map[letter] == 'u') draw_u();
                if(braille_map[letter] == 'v') draw_v();
                if(braille_map[letter] == 'w') draw_w();
                if(braille_map[letter] == 'x') draw_x();
                if(braille_map[letter] == 'y') draw_y();
                if(braille_map[letter] == 'z') draw_z();

                letter = 0x00;
                move_next_letter();

                while ((PORTD & 0x40) == 0x40);
                Delay(50);
        }

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
  draw_up_left(size);
  draw_down(size);
  draw_down(size);
  draw_up(size);
  draw_right(size);
  draw_down_right(size);
  pen_up();
  draw_up_left(size);
  pen_down();
}

void draw_b(void) { //NO CURVES
  draw_right(size);
  draw_down(size);
  draw_left(size);
  draw_left(size);
  draw_up(size);
  draw_up(size);
  draw_right(size);
  draw_down(size);
  draw_left(size);
  draw_right(size);
}

void draw_c(void) {
  pen_up();
  draw_up_right(size);
  pen_down();
  draw_left(size);
  draw_left(size);
  draw_down(size);
  draw_down(size);
  draw_right(size);
  draw_right(size);
  pen_up();
  draw_up_left(size);
  pen_down();
}

void draw_d(void) {
  draw_up_left(size);
  draw_down(size);
  draw_down(size);
  draw_up_right(size);
}

void draw_e(void) {
  draw_left(size);
  draw_up(size);
  draw_right(size);
  pen_up();
  draw_down(size);
  draw_down(size);
  pen_down();
  draw_left(size);
  draw_up(size);
  draw_right(size);
}

void draw_f(void) {
  draw_left(size);
  draw_up(size);
  draw_right(size);
  pen_up();
  draw_down(size);
  draw_down(size);
  draw_left(size);
  pen_down();
  draw_up(size);
  pen_up();
  draw_right(size);
  pen_down();
}

void draw_g(void) {
  draw_right(size);
  draw_down_left(size);
  draw_up_left(size);
  draw_up_right(size);
  pen_up();
  draw_down(size);
}

void draw_h(void) {
  draw_left(size);
  draw_up(size);
  draw_down(size);
  draw_down(size);
  pen_up();
  draw_right(size);
  draw_right(size);
  pen_down();
  draw_up(size);
   draw_up(size);
  draw_down(size);
  draw_left(size);
}

void draw_i(void) { //TODO return to origin
  draw_up(size);
  draw_right(size);
  draw_left(size);
  draw_left(size);
  pen_up();
  draw_down(size);
  draw_down(size);
  pen_down();
  draw_right(size);
  draw_right(size);
  draw_left(size);
  draw_up(size);
}

void draw_j(void) {
  pen_up();
  draw_up(size);
  pen_down();
  draw_right(size);
  draw_down(size);
  draw_down_left(size);
  draw_up(size);
}

void draw_k(void) {
  draw_up_right(size);
  pen_up();
  draw_down(size);
  draw_down(size);
  pen_down();
  draw_up_left(size);
  draw_up(size);
  draw_down(size);
  draw_down(size);
  draw_up(size);
}

void draw_l(void) {
  draw_up(size);
  draw_down(size);
  draw_down(size);
  draw_right(size);
  draw_left(size);
  draw_up(size);
}

void draw_m(void) {
  draw_up_right(size);
  draw_down(size);
  draw_down(size);
  pen_up();
  draw_right(size);
  draw_right(size);
  draw_up(size);
  draw_up(size);
  draw_down_right(size);
}

void draw_n(void) {
  pen_up();
  draw_down_left(size);
  pen_down();
  draw_up(size);
  draw_up(size);
  draw_down_right(size);
  draw_down_right(size);
  draw_up(size);
  draw_up(size);
  pen_up();
  draw_down_right(size);
  pen_down();
}

void draw_o(void) {
  pen_up();
  draw_up(size);
  pen_down();
  draw_down_right(size);
  draw_down_left(size);
  draw_up_left(size);
  draw_up_right(size);
  pen_up();
  draw_down(size);
  pen_down();
}

void draw_p(void) {
  draw_right(size);
  draw_up(size);
  draw_left(size);
  draw_down(size);
  draw_down(size);
  pen_up();
  draw_up_right(size);
}

void draw_q(void) {
  draw_down_right(size);
  pen_up();
  draw_left(size);
  pen_down();
  draw_up_left(size);
  draw_up_right(size);
  draw_down_right(size);
  draw_down_left(size);
  pen_up();
  draw_up(size);
  pen_down();
}

void draw_r(void) {
  draw_down(size);
  pen_up();
  draw_right(size);
  pen_down();
  draw_up_left(size);
  draw_up(size);
  draw_down_right(size);
  draw_left(size);
}

void draw_s(void) {
  pen_up();
  draw_down_left(size);
  pen_down();
  draw_right(size);
  draw_up_right(size);
  draw_left(size);
  draw_left(size);
  draw_up_right(size);
  draw_right(size);
  pen_up();
  draw_down_left(size);
  pen_down();
}

void draw_t(void){
  draw_up(size);
  draw_right(size);
  draw_left(size);
  draw_left(size);
  pen_up();
  draw_down_right(size);
  pen_down();
  draw_down(size);
  draw_up(size);
}

void draw_u(void) {
  pen_up();
  draw_up_left(size);
  pen_down();
  draw_down(size);
  draw_down_right(size);
  draw_right(size);
  draw_up(size);
  draw_up(size);
  pen_up();
  draw_down_left(size);
  pen_down();
}

void draw_v(void) {
  pen_up();
  draw_up_left(size);
  pen_down();
  draw_down(size);
  draw_down(size);
  draw_up_right(size);
  draw_up_right(size);
  pen_up();
  draw_down_left(size);
}

void draw_x(void) {
  draw_up_left(size);
  pen_up();
  draw_down(size);
  draw_down(size);
  pen_down();
  draw_up_right(size);
  draw_up_right(size);
  pen_up();
  draw_down(size);
  draw_down(size);
  pen_down();
  draw_up_left(size);
}

void draw_w(void) {
  draw_down_left(size);
  draw_up(size);
  draw_up(size);
  pen_up();
  draw_right(size);
  draw_right(size);
  pen_down();
  draw_down(size);
  draw_down(size);
  draw_up_left(size);
}

void draw_y(void) {
  draw_up_left(size);
  pen_up();
  draw_right(size);
  draw_right(size);
  pen_down();
  draw_down_left(size);
  draw_down(size);
  pen_up();
  draw_up(size);
}

void draw_z(void) {
  draw_up_right(size);
  draw_left(size);
  draw_left(size);
  pen_up();
  draw_down_right(size);
  pen_down();
  draw_down_left(size);
  draw_right(size);
  draw_right(size);
  pen_up();
  draw_up_left(size);
}


void draw_space(void) {
  pen_up();
  draw_right(size);
  draw_right(size);
  draw_right(size);
  draw_right(size);
  pen_down();
}

void move_next_letter(void) {
pen_up();
  draw_right(size);
  draw_right(size);
pen_down();
}

void enter_new_line(void) {
pen_up();
  for(times = 0; times<2*(letters_per_line-1); times++) draw_left(size);
  draw_down(size);
  draw_down(size);
pen_down();
}