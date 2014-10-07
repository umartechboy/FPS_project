#include <alcd.h>
void define_char(unsigned char flash *pc,unsigned char char_code)
{
    unsigned char i,address;
    address=(char_code<<3)|0x40;
    for (i=0; i<8; i++) lcd_write_byte(address++,*pc++);
}
flash unsigned char fingerPrint_charTable[8]=
{
	0b1001110,
	0b1010001,
	0b1010101,
	0b1010100,
	0b1010111,
	0b1010000,
	0b1001111,
	0b11000000};

void init_fingerPrint_char(void)
{
	define_char(fingerPrint_charTable, 0);
}

flash unsigned char power_charTable[8]=
{
    0b1000010,
    0b1000100,
    0b1001000,
    0b1001110,
    0b1000010,
    0b1000100,
    0b1001000,
    0b11000000};

void init_power_char(void)
{
    define_char(power_charTable, 1);
}

flash unsigned char battery_charTable[8]=
{
    0b1001110,
    0b1010001,
    0b1010001,
    0b1011111,
    0b1011111,
    0b1011111,
    0b1011111,
    0b11000000};

void init_battery_char(void)
{
    define_char(battery_charTable, 2);
}

flash unsigned char switch_charTable[8]=
{
    0b1000010,
    0b1001001,
    0b1000110,
    0b1000001,
    0b1000110,
    0b1001000,
    0b1000100,
    0b11000000};

void init_switch_char(void)
{
    define_char(switch_charTable, 3);
}

flash unsigned char locked_charTable[8]=
{
    0b1001110,
    0b1010001,
    0b1010001,
    0b1011111,
    0b1011011,
    0b1011011,
    0b1011111,
    0b11000000};

void init_locked_char(void)
{
    define_char(locked_charTable, 4);
}

flash unsigned char unlocked_charTable[8]=
{
    0b1001110,
    0b1010000,
    0b1010000,
    0b1011110,
    0b1011011,
    0b1011011,
    0b1011111,
    0b11000000};

void init_unlocked_char(void)
{
    define_char(unlocked_charTable, 5);
}

flash unsigned char smilie_charTable[8]=
{
    0b1000000,
    0b1001010,
    0b1000000,
    0b1000000,
    0b1010001,
    0b1001110,
    0b1000000,
    0b11000000};

void init_smilie_char(void)
{
    define_char(smilie_charTable, 6);
}
