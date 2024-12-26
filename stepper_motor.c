#define STEP_PIN PORTB.F1  // Step pin on RB1
#define DIR_PIN  PORTB.F0  // Direction pin on RB0

// Use constant delays instead of variables for Delay_us
const unsigned int STEP_DELAY = 500; // Delay for step pulses in microseconds

void rotate_stepper_full_rotation() {
    unsigned int i;

    DIR_PIN = 1; // Set direction (1 for CW, 0 for CCW)

    for (i = 0; i < 200; i++) {  // 200 steps for a full rotation
        STEP_PIN = 1;            // Generate HIGH pulse
        Delay_us(STEP_DELAY);    // Constant delay
        STEP_PIN = 0;            // Generate LOW pulse
        Delay_us(STEP_DELAY);    // Constant delay
    }
}

void main() {
    TRISB = 0x00; // Set PORTB as output

    while (1) {
        rotate_stepper_full_rotation(); // Rotate one full revolution
        Delay_ms(1000);                 // Delay before the next rotation
    }
}

