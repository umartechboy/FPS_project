#include <alcd.h>

flash byte dudd0_charTable[8]=
{
	0b1000000,
	0b1010000,
	0b1000010,
	0b1000110,
	0b1000110,
	0b1000000,
	0b1000000,
	0b11000000};

void init_dudd0(void)
{
	define_char(dudd0_charTable,+ 0);
}
flash byte dudd2_charTable[8]=
{
	0b1000000,
	0b1010000,
	0b1010010,
	0b1010110,
	0b1010110,
	0b1010000,
	0b1000000,
	0b11000000};

void init_dudd2(void)
{
	define_char(dudd2_charTable,+ 1);
}