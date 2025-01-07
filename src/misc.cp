#line 1 "C:/Users/20210383/Downloads/Embedded-Systems_Final_Project-main/Embedded-Systems_Final_Project-main/src/misc.c"
#line 1 "c:/users/20210383/downloads/embedded-systems_final_project-main/embedded-systems_final_project-main/src/../include/misc.h"



void Delay(unsigned int delay);
#line 3 "C:/Users/20210383/Downloads/Embedded-Systems_Final_Project-main/Embedded-Systems_Final_Project-main/src/misc.c"
void Delay(unsigned int delay) {
 while (delay--) {
 Delay_ms(1);
 }
}
