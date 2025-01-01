const char DRAW_LINE_TIME = 100;
const char DRAW_DIAG_TIME = 102;

void draw_right(void) { //direction  = 1 goes to right
  PORTC |= 0x10; //set directionn = 1
  PORTC &= 0xBF; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x40; //set enable = 1
}

void draw_left(void) { //direction = 0 goes to left
  PORTC &= 0xEF;     //set direction = 0
  PORTC &= 0xBF; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x40; //set enable = 1
}

void draw_down(void){ // direction = 1
  PORTC &= 0xDF;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x80; //set enable = 1
}

void draw_up(void){ // direction = 0
  PORTC |= 0x20;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x80; //set enable = 1
}

void draw_down_right(void){
  PORTC |= 0x10; //set directionn = 1
  PORTC &= 0xBF; //set enable = 0
  PORTC &= 0xDF;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_DIAG_TIME);
  PORTC |= 0x40; //set enable = 1
  PORTC |= 0x80; //set enable = 1
}

void draw_up_left(void) {
  PORTC &= 0xEF;     //set direction = 0
  PORTC &= 0xBF; //set enable = 0
  PORTC |= 0x20;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_DIAG_TIME);
  PORTC |= 0x40; //set enable = 1
  PORTC |= 0x80; //set enable = 1
}