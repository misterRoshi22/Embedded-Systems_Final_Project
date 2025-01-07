#line 1 "C:/Users/20210383/Desktop/project/src/misc.c"
#line 1 "c:/users/20210383/desktop/project/src/../include/misc.h"



void Delay(unsigned int delay);
#line 3 "C:/Users/20210383/Desktop/project/src/misc.c"
void Delay(unsigned int delay) {
 while (delay--) {
 Delay_ms(1);
 }
}
