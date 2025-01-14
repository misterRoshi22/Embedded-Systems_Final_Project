#line 1 "C:/Users/20210383/Embedded-Systems_Final_Project/src/atd.c"
#line 1 "c:/users/20210383/embedded-systems_final_project/src/../include/atd.h"



void ATD_init(void);
unsigned int ATD_read(unsigned char channel);
#line 4 "C:/Users/20210383/Embedded-Systems_Final_Project/src/atd.c"
void ATD_init(void) {
 ADCON0 = 0x41;
 ADCON1 = 0xCE;
 TRISA = 0x03;
}


unsigned int ATD_read(unsigned char channel) {

 ADCON0 &= 0xC7;
 ADCON0 |= (channel << 3);

 ADCON0 |= 0x04;
 while (ADCON0 & 0x04);

 return ((ADRESH << 8) | ADRESL);
}
