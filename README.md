# Braille-to-English CNC Machine

This repository contains the code for a Braille-to-English CNC machine project. The project uses a PIC16F877A microcontroller to interpret Braille input and control two stepper motors and a servo motor to write corresponding English letters. The machine also includes an LCD display for feedback.

## Features

- **Braille-to-English Conversion**: Converts Braille input to English letters using a pre-defined Braille map.
- **CNC Drawing Capability**: Uses stepper motors and a servo motor to draw English letters based on Braille input.
- **LCD Feedback**: Displays the interpreted English letter on an LCD.
- **Adjustable Drawing Size**: Dynamically adjusts the size of the drawn characters based on analog input.
- **Interrupt-Driven Motor Control**: Utilizes hardware interrupts for precise motor control.

## Hardware Requirements

- **Microcontroller**: PIC16F877A
- **Clock**: 8 MHz external oscillator
- **Motors**:
  - 2 Stepper motors for movement
  - 1 Servo motor for pen up/down control
- **LCD Display**: 40x4 character LCD
- **Braille Input Device**: Port D buttons for Braille input
- **Analog Input**: Potentiometer or sensor for size adjustment

## Software Requirements

- **Compiler**: mikroC for PIC
- **Hardware Libraries**:
  - `atd.h`: For analog-to-digital conversion
  - `lcd_config.h`: For LCD control
  - `draw_base.h`: For motor control base functions
  - `timer_init.h`: For timer initialization
  - `misc.h`: Miscellaneous functions like Delay

## Code Structure

- **Interrupt Handling**: Handles motor toggling and servo control using Timer0, Timer1, and CCP1 interrupts.
- **Braille Map**: Maps 6-bit Braille input to corresponding English letters.
- **Drawing Functions**: Implements individual functions to draw each English letter.
- **LCD Functions**: Displays English letters and user prompts.

## How to Use

1. **Connect the Hardware**:
   - Configure stepper motors, servo motor, LCD, and Braille input buttons as per the schematics.
   - Connect the analog input to adjust the character size.

2. **Load the Code**:
   - Compile the code using mikroC and flash it onto the PIC16F877A microcontroller.

3. **Input Braille Characters**:
   - Use PORTD buttons to input Braille characters.
   - Press the ENTER button (`PORTD.7`) to process and draw the character.

4. **LCD Feedback**:
   - The LCD displays the interpreted English character.

5. **Observe Drawing**:
   - The CNC machine will draw the character using stepper motors and the servo motor.

## Braille Map

The following table maps Braille inputs (6 bits) to corresponding English characters:

| English Letter | Braille Input (Hex) |
|----------------|----------------------|
| (space)        | 0x00                |
| a              | 0x20                |
| b              | 0x28                |
| c              | 0x30                |
| d              | 0x34                |
| e              | 0x24                |
| f              | 0x38                |
| g              | 0x3C                |
| h              | 0x2C                |
| i              | 0x18                |
| j              | 0x1C                |
| k              | 0x22                |
| l              | 0x2A                |
| m              | 0x32                |
| n              | 0x36                |
| o              | 0x26                |
| p              | 0x3A                |
| q              | 0x3E                |
| r              | 0x2E                |
| s              | 0x1A                |
| t              | 0x1E                |
| u              | 0x23                |
| v              | 0x2B                |
| w              | 0x1D                |
| x              | 0x33                |
| y              | 0x37                |
| z              | 0x27                |

> Note: This Braille map is inspired by the Perkins Brailler.

## Contributors

- **Mahmoud Abu-Qteish** - [Email](mailto:mah20210383@std.psut.edu.jo)
- **Abdulkarim Damisi** - [Email](mailto:abd20210173@std.psut.edu.jo)
- **Ghaith Abboud** - [Email](mailto:gha20210055@std.psut.edu.jo)

---

Feel free to reach out to the contributors for more information or support.
