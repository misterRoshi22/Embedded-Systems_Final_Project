// C0 is enter button when confgure word is pressed
// C2, C3 are step pins for motor 1 and 2 respectively
// C4, C5 are direction pins for motor 1 and 2 repectively
// C6, C7, E0, E2, E3 are used to confifure the settings of the motor
// [C7, C6, E0, E1, E2] are the configure word for the step motors

unsigned char direction_1 = 0; // for the direction of motor 1
unsigned char direction_2 = 0; // for the direction of motor 2
unsigned char i;
const unsigned STEP_MOTOR_SPEED = 2;
const unsigned STEPS_FULL_ROTATION = 200;
const unsigned STEPS_HALF_ROTATION = 100;
unsigned char config_word; // 5 bits word

void draw_horizontal_line(unsigned char steps) { //motor 1 step pin is connected to C2
  for (i = 0; i < steps; i++) {
    PORTC |= 0x04;  //0000 0100
    Delay_ms(STEP_MOTOR_SPEED);
    PORTC &= 0xFB; //1111 1011
    Delay_ms(STEP_MOTOR_SPEED);
  }
}

void draw_vertical_line(unsigned char steps) { //motor 2 step pin is connected to C3
  for(i = 0; i < steps; i++) {
    PORTC |= 0x08; // 0000 1000
    Delay_ms(STEP_MOTOR_SPEED);
    PORTC &= 0xF7; // 1111 0111
    DElay_ms(STEP_MOTOR_SPEED);
  }
}

void draw_diagonal_line(unsigned char steps) {
  for(i = 0; i < steps; i++) {
    PORTC |= 0x0C; // 0000 1100
    Delay_ms(STEP_MOTOR_SPEED);
    PORTC &= 0xF3; // 1111 0011
    Delay_ms(STEP_MOTOR_SPEED);
  }
}

void read_input() {

}

void main() {
  TRISC = 0xC1;                // pin c7, c6 and c0 are inputs,  rest are outputs 1100 0001
  PORTC = 0x00;                // initialize PORT C
  ADCON1 = 0x06;               // configure all pins as digital, except for RA0 which might be used later
  TRISE = 0xFF;                // configure PORRT E as inputs
  PORTE = 0x00;                // initialize PORT E

  while(1) {
        // Read button inputs and update the Braille `letter`
        if (PORTC & 0x80) config_word |= 0x20; // Set bit 4
        if (PORTC & 0x40) config_word |= 0x40; // Set bit 3
        if (PORTE & 0x01) config_word |= 0x01; // Set bit 0
        if (PORTE & 0x02) config_word |= 0x02; // Set bit 1
        if (PORTE & 0x04) config_word |= 0x04; // Set bit 2
        
        if (PORTC & 0x01) {                   // Button pressed
           delay_ms(50);                      // Debouncing delay
            switch (config_word & 0x7) {      // 8 optoions as c6 and c7 are used to control the direction of the motors
                case 0b000:                   // nothing // TODO
                    break;

                case 0b001: draw_vertical_line(STEPS_FULL_ROTATION);     // E0
                    break;

                case 0b010: draw_vertical_line(STEPS_HALF_ROTATION);     // E1
                    break;

                case 0b011: draw_horizontal_line(STEPS_FULL_ROTATION);   // E1, E0
                    break;

                case 0b100: draw_horizontal_line(STEPS_HALF_ROTATION);   //  E2
                    break;

                case 0b101: draw_diagonal_line(STEPS_FULL_ROTATION);     // E2, E0
                    break;

                case 0b110: draw_diagonal_line(STEPS_HALF_ROTATION);     // E2, E1
                    break;

                case 0b111:  // E2, E1, E0  //TODO
                    break;
            }
            config_word = 0;
            while ((PORTC & 0x01) == 0x01); // Wait for button to be released
            delay_ms(50);                // Debouncing delay after release
      
      }
  }
}

