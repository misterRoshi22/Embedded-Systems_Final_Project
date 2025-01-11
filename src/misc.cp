#line 1 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/misc.c"
#line 1 "c:/users/shaba/onedrive/desktop/uni/embedded systems/embedded-systems_final_project/src/../include/misc.h"



void Delay(unsigned int delay);
#line 3 "C:/Users/shaba/OneDrive/Desktop/UNI/Embedded Systems/Embedded-Systems_Final_Project/src/misc.c"
void Delay(unsigned int delay) {
 while (delay--) {
 Delay_ms(1);
 }
}
