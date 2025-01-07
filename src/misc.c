#include "../include/misc.h"

void Delay(unsigned int delay) {
    while (delay--) {
        Delay_ms(1); // Delay 1 ms at a time
    }
}