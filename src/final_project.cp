#line 1 "C:/Users/20210383/Desktop/project/src/final_project.c"






unsigned char direction_1 = 0;
unsigned char direction_2 = 0;
unsigned char i;
const unsigned STEP_MOTOR_SPEED = 2;
const unsigned STEPS_FULL_ROTATION = 200;
const unsigned STEPS_HALF_ROTATION = 100;
unsigned char config_word;

void draw_horizontal_line(unsigned char steps) {
 for (i = 0; i < steps; i++) {
 PORTC |= 0x04;
 Delay_ms(STEP_MOTOR_SPEED);
 PORTC &= 0xFB;
 Delay_ms(STEP_MOTOR_SPEED);
 }
}

void draw_vertical_line(unsigned char steps) {
 for(i = 0; i < steps; i++) {
 PORTC |= 0x08;
 Delay_ms(STEP_MOTOR_SPEED);
 PORTC &= 0xF7;
 DElay_ms(STEP_MOTOR_SPEED);
 }
}

void draw_diagonal_line(unsigned char steps) {
 for(i = 0; i < steps; i++) {
 PORTC |= 0x0C;
 Delay_ms(STEP_MOTOR_SPEED);
 PORTC &= 0xF3;
 Delay_ms(STEP_MOTOR_SPEED);
 }
}

void read_input() {

}

void main() {
 TRISC = 0xC1;
 PORTC = 0x00;
 ADCON1 = 0x06;
 TRISE = 0xFF;
 PORTE = 0x00;

 while(1) {

 if (PORTC & 0x80) config_word |= 0x20;
 if (PORTC & 0x40) config_word |= 0x40;
 if (PORTE & 0x01) config_word |= 0x01;
 if (PORTE & 0x02) config_word |= 0x02;
 if (PORTE & 0x04) config_word |= 0x04;

 if (PORTC & 0x01) {
 delay_ms(50);
 switch (config_word & 0x7) {
 case 0b000:
 break;

 case 0b001: draw_vertical_line(STEPS_FULL_ROTATION);
 break;

 case 0b010: draw_vertical_line(STEPS_HALF_ROTATION);
 break;

 case 0b011: draw_horizontal_line(STEPS_FULL_ROTATION);
 break;

 case 0b100: draw_horizontal_line(STEPS_HALF_ROTATION);
 break;

 case 0b101: draw_diagonal_line(STEPS_FULL_ROTATION);
 break;

 case 0b110: draw_diagonal_line(STEPS_HALF_ROTATION);
 break;

 case 0b111:
 break;
 }
 config_word = 0;
 while ((PORTC & 0x01) == 0x01);
 delay_ms(50);

 }
 }
}
