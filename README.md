# Smart Braille-to-English Translator

The **Smart Braille-to-English Translator** is an innovative embedded system designed to facilitate communication between visually impaired individuals and those unfamiliar with Braille. The project aims to bridge the communication gap by translating Braille inputs into readable English text and replicating it using a precise pen-based writing mechanism.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [System Overview](#system-overview)
- [Hardware Components](#hardware-components)
- [How It Works](#how-it-works)
- [Future Enhancements](#future-enhancements)
- [Contributors](#contributors)

## Introduction
The project combines simple hardware components with advanced control logic to create a user-friendly and cost-effective solution. By utilizing six push buttons to input Braille characters, the system processes these inputs to:
- Translate Braille characters into English.
- Control stepper motors and a servo motor to replicate the English characters on paper.
- Enhance accessibility for visually impaired users.

## Features
- **Braille-to-English Decoding:** Converts Braille input (3x2 grid of six cells) into English text.
- **Pen-based Writing Mechanism:** Uses two stepper motors for X-Y axis movement and a servo motor for Z-axis control.
- **User Interaction Enhancements:**
  - Ultrasonic sensor to detect user proximity and activate the system.
  - Tilt sensor to ensure paper alignment.
  - Potentiometer for adjustable writing speed.
  - LCD screen for real-time character display.

## System Overview
The system consists of modular stages:
1. **Input Stage:** Collects Braille input through six push buttons.
2. **Processing Stage:** Maps Braille inputs to English characters and calculates writing coordinates.
3. **Output Stage:** Drives stepper motors and a servo motor to replicate the characters on paper.

This modular design ensures adaptability for future iterations, such as translating Braille to other languages.

## Hardware Components
- 6 push buttons
- 2 stepper motors (X-Y axis control)
- 1 servo motor (Z-axis control)
- Ultrasonic sensor
- Tilt sensor
- Potentiometer
- LCD screen
- Microcontroller (PIC16F877A or equivalent)

## How It Works
1. Users input Braille characters via the push buttons.
2. The microcontroller processes the input and determines the corresponding English characters.
3. The system calculates the X-Y-Z coordinates required for writing.
4. Stepper motors position the pen, and the servo motor raises/lowers it to write the character.
5. The LCD screen displays the current character for verification.

## Future Enhancements
- Support for Braille-to-Arabic translation.
- Improved portability with a dedicated power source.
- Enhanced writing accuracy using advanced sensors.

## Contributors
- **Mahmoud Abu-Qteish** - [Email](mailto:mah20210383@std.psut.edu.jo)
- **Abdulkarim Damisi** - [Email](mailto:abd20210173@std.psut.edu.jo)
- **Ghaith Abboud** - [Email](mailto:gha20210055@std.psut.edu.jo)

---

This repository documents the development of the Smart Braille-to-English Translator, including code, schematics, and design documentation.
