const char DRAW_LINE_TIME = 400;
const char DRAW_DIAG_TIME = 408;
const char SERVO_UP =  1500;
const char SERVO_DOWN = 1000;
//unsigned int angle;  // Count value of high - pertaining to the angle


void draw_right(void) { //direction  = 1 goes to right
 // angle = SERVO_DOWN;
  PORTC |= 0x10; //set directionn = 1
  PORTC &= 0xBF; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x40; //set enable = 1
}

void draw_left(void) { //direction = 0 goes to left
  //angle = SERVO_DOWN;
  PORTC &= 0xEF;     //set direction = 0
  PORTC &= 0xBF; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x40; //set enable = 1
}

void draw_down(void){ // direction = 1
  //angle = SERVO_DOWN;
  PORTC &= 0xDF;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x80; //set enable = 1
}

void draw_up(void){ // direction = 0
  //angle = SERVO_DOWN;
  PORTC |= 0x20;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x80; //set enable = 1
}

void draw_down_right(void){
  //angle = SERVO_DOWN;
  PORTC |= 0x10; //set directionn = 1
  PORTC &= 0xBF; //set enable = 0
  PORTC &= 0xDF;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_DIAG_TIME);
  PORTC |= 0x40; //set enable = 1
  PORTC |= 0x80; //set enable = 1
}

void draw_up_left(void) {
  //angle = SERVO_DOWN;
  PORTC &= 0xEF;     //set direction = 0
  PORTC &= 0xBF; //set enable = 0
  PORTC |= 0x20;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_DIAG_TIME);
  PORTC |= 0x40; //set enable = 1
  PORTC |= 0x80; //set enable = 1
}

void move_right(void) { //direction  = 1 goes to right
  //angle = SERVO_UP;
  PORTC |= 0x10; //set directionn = 1
  PORTC &= 0xBF; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x40; //set enable = 1
}

void move_left(void) {
  //angle = SERVO_UP;
  PORTC &= 0xEF;     //set direction = 0
  PORTC &= 0xBF; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x40; //set enable = 1
}

void move_down(void){ // direction = 1
  //angle = SERVO_UP;
  PORTC &= 0xDF;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x80; //set enable = 1
}

void move_up(void){ // direction = 0
  //angle = SERVO_UP;
  PORTC |= 0x20;
  PORTC &= 0x7F; //set enable = 0
  Delay_ms(DRAW_LINE_TIME);
  PORTC |= 0x80; //set enable = 1
}