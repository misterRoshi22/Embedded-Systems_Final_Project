#include "../include/atd.h"
#include "../include/lcd_config.h"
#include "../include/draw_base.h"
#include "../include/timer_init.h"
#include "../include/misc.h"

// constants
const unsigned int SERVO_UP = 1800;
const unsigned int SERVO_DOWN = 1000;

char braille_map[64] = {
    ' ', '\n', '!', '!', '!', '!', '!', '!',  // 0x00 - 0x07
    '!', '!', '!', '!', '!', '!', '!', '!',  // 0x08 - 0x0F
    '!', '!', '!', '!', '!', '!', '!', '!',  // 0x10 - 0x17
    'I', '!', 'S', '!', 'J', 'W', 'T', '!',  // 0x18 - 0x1F
    'A', '!', 'K', 'U', 'E', '!', 'O', 'Z',  // 0x20 - 0x27
    'B', '!', 'L', 'V', 'H', '!', 'R', '!',  // 0x28 - 0x2F
    'C', '!', 'M', 'X', 'D', '!', 'N', 'Y',  // 0x30 - 0x37
    'F', '!', 'P', '!', 'G', '!', 'Q', '!',  // 0x38 - 0x3F
};

char[32] = "the quick brown fox jumps over the lazy dog";
int char_index = 0;

// variables
char print_speed[7];
unsigned char HL = 1;    
unsigned int angle;
unsigned char letter = 0x00;  
unsigned char size;

// testing
unsigned char count_overflow = 0;
unsigned char speed_tester = 0;

// lcd Variables
char current_row = 1;
char current_column = 1;
char previous_letter = 0x00;
const char letters_per_line = 20;

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
        TMR0 = 0xE8 + ((size - 50) * (0xF8 - 0xE8)) / (255 - 50);
        count_overflow++;
    }
    
    if(count_overflow == 255) speed_tester++;

      // if (PIR1 & 0x02) {      // STEPPER MOTOR 2 Toggle
      //     PORTC ^= 0x08;      // Toggle RC3 (example action for Timer2)
      //     PIR1 &= ~0x02;      // Clear TMR2IF
      // }

    if(PIR1 & 0x04){                                    // Servo Motor CCP1 interrupt
        if(HL) {                                // high
          CCPR1H = angle >> 8;
          CCPR1L = angle;
          HL = 0;                      // next time low
          CCP1CON = 0x09;              // compare mode, clear output on match
          TMR1H = 0;
          TMR1L = 0;
        }
    
        else {                                          //low
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

    TRISD = 0xFF;
    PORTD = 0x00;

    
    // Initialize System
    ATD_init();
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
    
      size = ATD_read(0);  //0-255
      size = 50 + ((size * (150 - 50)) / 242); //  50-150
      
      //IntToStr(size, print_speed);
      //Lcd_Out(1, 1, print_speed);
      //IntToStr(speed_tester, print_speed_tester);
      //Lcd_Out(2, 1, print_speed_tester);
      

      //print current char and current size
      if (previous_letter != braille_map[letter]) {  
            update_current_letter_display(braille_map[letter]);
            previous_letter = braille_map[letter];  
      }
      update_current_size_display(size);  // Update size display

      if ((PORTD & 0x40) == 0x40) {  // check if enter is pressed
            Delay(50);
            if (current_column > letters_per_line) { // move to next row
                current_row++;
                current_column = 1;

                if (current_row > 3) { // clear screen after 3rd row is full
                    Lcd_Cmd(_LCD_CLEAR);
                     update_current_letter_display(braille_map[letter]);
                    current_row = 1;
                }
            }
            
            Lcd_Chr(current_row, current_column, braille_map[letter]);

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
                if(braille_map[letter] == '\n') enter_new_line();
                if(braille_map[letter] == ' ') draw_space();

            current_column++; // Move to the next column
            letter = 0x00; // Clear letter

            while ((PORTD & 0x40));
            Delay(50);
        }

        if (PORTD & 0x01) letter |= 0x01; // Set bit 0
        if (PORTD & 0x02) letter |= 0x02; // Set bit 1
        if (PORTD & 0x04) letter |= 0x04; // Set bit 2
        if (PORTD & 0x08) letter |= 0x08; // Set bit 3
        if (PORTD & 0x10) letter |= 0x10; // Set bit 4
        if (PORTD & 0x20) letter |= 0x20; // Set bit 5
        if (PORTD & 0x80) letter = 0x00;  // Clear all bits
        
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
  draw_up_left(100);
  draw_down(100);
  draw_down(100);
  draw_up(100);
  draw_right(100);
  draw_down_right(100);
  pen_up();
  draw_up_left(100);
  pen_down();
}

void draw_b(void) { //NO CURVES
  draw_right(100);
  draw_down(100);
  draw_left(100);
  draw_left(100);
  draw_up(100);
  draw_up(100);
  draw_right(100);
  draw_down(100);
  draw_left(100);
  draw_right(100);
}

void draw_c(void) {
  pen_up();
  draw_up_right(100);
  pen_down();
  draw_left(100);
  draw_left(100);
  draw_down(100);
  draw_down(100);
  draw_right(100);
  draw_right(100);
  pen_up();
  draw_up_left(100);
  pen_down();
}

void draw_d(void) {
  draw_up_left(100);
  draw_down(100);
  draw_down(100);
  draw_up_right(100);
}

void draw_e(void) {
  draw_left(100);
  draw_up(100);
  draw_right(100);
  pen_up();
  draw_down(100);
  draw_down(100);
  pen_down();
  draw_left(100);
  draw_up(100);
  draw_right(100);
}

void draw_f(void) {
  draw_left(100);
  draw_up(100);
  draw_right(100);
  pen_up();
  draw_down(100);
  draw_down(100);
  draw_left(100);
  pen_down();
  draw_up(100);
  pen_up();
  draw_right(100);
  pen_down();
}

void draw_g(void) {
  draw_right(100);
  draw_down_left(100);
  draw_up_left(100);
  draw_up_right(100);
  pen_up();
  draw_down(100);
}

void draw_h(void) {
  draw_left(100);
  draw_up(100);
  draw_down(100);
  draw_down(100);
  pen_up();
  draw_right(100);
  draw_right(100);
  pen_down();
  draw_up(100);
   draw_up(100);
  draw_down(100);
  draw_left(100);
}

void draw_i(void) { //TODO return to origin
  draw_up(100);
  draw_right(100);
  draw_left(100);
  draw_left(100);
  pen_up();
  draw_down(100);
  draw_down(100);
  pen_down();
  draw_right(100);
  draw_right(100);
  draw_left(100);
  draw_up(100);
}

void draw_j(void) {
  pen_up();
  draw_up(100);
  pen_down();
  draw_right(100);
  draw_down(100);
  draw_down_left(100);
  draw_up(100);
}

void draw_k(void) {
  draw_up_right(100);
  pen_up();
  draw_down(100);
  draw_down(100);
  pen_down();
  draw_up_left(100);
  draw_up(100);
  draw_down(100);
  draw_down(100);
  draw_up(100);
}

void draw_l(void) {
  pen_up();
  draw_up_left(100);
  pen_down();
  draw_down(100);
  draw_down(100);
  draw_right(100);
  pen_up();
  draw_up(100);
  pen_down();
  // draw_up(100);
  // draw_down(100);
  // draw_down(100);
  // draw_right(100);
  // draw_left(100);
  // draw_up(100);
}

void draw_m(void) {
  draw_up_right(100);
  draw_down(100);
  draw_down(100);
  pen_up();
  draw_right(100);
  draw_right(100);
  draw_up(100);
  draw_up(100);
  draw_down_right(100);
}

void draw_n(void) {
  pen_up();
  draw_down_left(100);
  pen_down();
  draw_up(100);
  draw_up(100);
  draw_down_right(100);
  draw_down_right(100);
  draw_up(100);
  draw_up(100);
  pen_up();
  draw_down_right(100);
  pen_down();
}

void draw_o(void) {
  pen_up();
  draw_up(100);
  pen_down();
  draw_down_right(100);
  draw_down_left(100);
  draw_up_left(100);
  draw_up_right(100);
  pen_up();
  draw_down(100);
  pen_down();
}

void draw_p(void) {
  draw_right(100);
  draw_up(100);
  draw_left(100);
  draw_down(100);
  draw_down(100);
  pen_up();
  draw_up_right(100);
}

void draw_q(void) {
  draw_down_right(100);
  pen_up();
  draw_left(100);
  pen_down();
  draw_up_left(100);
  draw_up_right(100);
  draw_down_right(100);
  draw_down_left(100);
  pen_up();
  draw_up(100);
  pen_down();
}

void draw_r(void) {
  draw_down(100);
  pen_up();
  draw_right(100);
  pen_down();
  draw_up_left(100);
  draw_up(100);
  draw_down_right(100);
  draw_left(100);
}

void draw_s(void) {
  pen_up();
  draw_down_left(100);
  pen_down();
  draw_right(100);
  draw_up_right(100);
  draw_left(100);
  draw_left(100);
  draw_up_right(100);
  draw_right(100);
  pen_up();
  draw_down_left(100);
  pen_down();
}

void draw_t(void){
  draw_up(100);
  draw_right(100);
  draw_left(100);
  draw_left(100);
  pen_up();
  draw_down_right(100);
  pen_down();
  draw_down(100);
  draw_up(100);
}

void draw_u(void) {
  pen_up();
  draw_up_left(100);
  pen_down();
  draw_down(100);
  draw_down_right(100);
  draw_right(100);
  draw_up(100);
  draw_up(100);
  pen_up();
  draw_down_left(100);
  pen_down();
}

void draw_v(void) {
  pen_up();
  draw_up_left(100);
  pen_down();
  draw_down(100);
  draw_down(100);
  draw_up_right(100);
  draw_up_right(100);
  pen_up();
  draw_down_left(100);
}

void draw_x(void) {
  draw_up_left(100);
  pen_up();
  draw_down(100);
  draw_down(100);
  pen_down();
  draw_up_right(100);
  draw_up_right(100);
  pen_up();
  draw_down(100);
  draw_down(100);
  pen_down();
  draw_up_left(100);
}

void draw_w(void) {
  draw_down_left(100);
  draw_up(100);
  draw_up(100);
  pen_up();
  draw_right(100);
  draw_right(100);
  pen_down();
  draw_down(100);
  draw_down(100);
  draw_up_left(100);
}

void draw_y(void) {
  draw_up_left(100);
  pen_up();
  draw_right(100);
  draw_right(100);
  pen_down();
  draw_down_left(100);
  draw_down(100);
  pen_up();
  draw_up(100);
}

void draw_z(void) {
  draw_up_right(100);
  draw_left(100);
  draw_left(100);
  pen_up();
  draw_down_right(100);
  pen_down();
  draw_down_left(100);
  draw_right(100);
  draw_right(100);
  pen_up();
  draw_up_left(100);
}


void draw_space(void) {
  pen_up();
  draw_right(100);
  draw_right(100);
  draw_right(100);
  draw_right(100);
  pen_down();
}

void move_next_letter(void) {
  pen_up();
  draw_right(100);
  draw_right(100);
  pen_down();
}

unsigned char times;
void enter_new_line(void) {
  pen_up();
  for(times = 0; times<2*(current_column-1); times++) draw_left(100);
  draw_down(100);
  draw_down(100);
  pen_down();
}