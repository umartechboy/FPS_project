/* 
  LCD user defined characters demo
  
  CodeVisionAVR C Compiler
  (C) 2000-2007 HP InfoTech S.R.L.
  www.hpinfotech.ro
  
  Chip: ATmega8515
  Memory Model: SMALL
  Data Stack Size: 128 bytes

  Use an 2x16 alphanumeric LCD connected
  to the STK500 PORTC header as follows:

  [LCD]   [STK500 PORTC HEADER]
   1 GND- 9  GND
   2 +5V- 10 VCC  
   3 VLC- LCD contrast control voltage 0..1V
   4 RS - 1  PC0
   5 RD - 2  PC1
   6 EN - 3  PC2
  11 D4 - 5  PC4
  12 D5 - 6  PC5
  13 D6 - 7  PC6
  14 D7 - 8  PC7
*/


// Alphanumeric LCD Module functions
// The LCD connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric menu
#include <alcd.h>
#include "customCharsCG.h"

typedef unsigned char byte;



void main(void)
{
char i ;
// initialize the LCD for
// 2 lines & 16 columns
lcd_init(16);

init_fingerPrint_char();
init_power_char();
init_battery_char();
init_switch_char();
init_locked_char();
init_unlocked_char();
init_smilie_char();


// switch to writing in Display RAM
lcd_gotoxy(0,0);
// display the user defined characters
lcd_putsf("User defined\nchar 0:");
// display the user defined char 0

for (i = 0; i< 8; i++)
lcd_putchar(i);

while (1);
}
