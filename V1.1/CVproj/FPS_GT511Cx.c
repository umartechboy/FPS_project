#include "GPS_GT511x_comDefs.h"
#include "projDefines.h"
#include "projHeaders.h"
#include <mega8.h>
#include <delay.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <alcd.h>

#define lowByte(u16) (u16 % 256)
#define highByte(u16) ((u16 >> 8) % 256)
#define UseLCDDebug 0

uint8_t txPacket []= 	{0x55, 0xAA, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0, 0x00, 0x0, 0x00};
uint8_t rxPacket [12];

#define rxData (x_)  rxPacket[4 + x_]
void getCommand(uint16_t com, uint32_t data)
{
	uint16_t chkSum_ = 0, rd_data = 0, i;
    cpuHaltAllowed = 0;
#if UseLCDDebug
	lcd_clear();
    lcd_putsf("Sent\n");
#endif
	for (i = 0; i < 4; i++)
	{
		txPacket[4 + i] = data % 256; data /= 256;
	}
	txPacket[8] = com % 256; com /= 256;
	txPacket[9] = com % 256;

	for(i = 0; i < 10; i++)
		chkSum_ += txPacket[i];
	txPacket[10] = chkSum_ % 256; chkSum_ /= 256;
	txPacket[11] = chkSum_ ;

	for(i = 0; i < 12; i++)
	{
		putchar(txPacket[i]);
	}
#if UseLCDDebug   
	lcd_clear();
	lcd_putsf("Got Back.");
#endif
	for (i = 0; i < 12; i++)
	{
		//while(rx_counter == 0);
		rd_data = getchar();

		rxPacket[i] = rd_data;
	}  
    cpuHaltAllowed = 1;  
}

uint8_t setCmosLED(uint8_t state_)
{
	getCommand(CmosLed, state_);
	return rxPacket[10] == 0x30; // ACK
}

uint8_t FPS_open(void)
{
    delay_ms(100);
	getCommand(FPSOpen, 0);
	return rxPacket[10] == 0x30; // ACK
}
uint8_t FPS_close(void)
{
	getCommand(FPSClose, 0);
	return rxPacket[10] == 0x30; // ACK
}
void FPS_reset(void)
{
	FPS_open();
    delay_ms(1000);
	FPS_close();
}
uint32_t FPS_getInt(uint32_t com)
{
	uint32_t ans = 0, i = 0;
	getCommand(com, 0);
	for (i = 0; i < 4; i++)
	{
		ans += rxPacket[4 + i] << (8 * i);
	}
	return ans;
}
uint8_t fingerPressed(void)
{
	getCommand(IsPressFinger, 0);
	return rxPacket[4] ? 0: 1;
} 
uint32_t getEnrolledCount(void)
{
	return FPS_getInt(GetEnrollCount);
}
uint8_t isEnrolled(uint8_t id)
{
#if UseLCDDebug
	lcd_clear();
	lcd_putsf("CheckEnrolled");
#endif
	getCommand(CheckEnrolled, id);
	return rxPacket[4] ? 0: 1;
}
uint8_t deleteID(uint8_t id)
{
#if UseLCDDebug
	lcd_clear();
	lcd_putsf("delete ID");
#endif
	getCommand(DeleteID, id);
	return rxPacket[4] ? 0: 1;
}
uint8_t getFingerId(void)
{
	uint32_t ans = 0;
	//lcd_clear();
	//lcd_putsf("Place your finger.");
	setCmosLED(1);
	while (!fingerPressed());
	ans = FPS_getInt(Identify1_N);
	setCmosLED(0);
	if (rxPacket[10] == Nack)
	{
	    lcd_clear();
	    lcd_putsf("Failed");
		return 21;
	}
	return ans;
}
uint8_t deleteAllIds(void)
{
	uint32_t ans = 0;
	
	ans = FPS_getInt(DeleteAll);
	
    if (rxPacket[10] == Nack)
	{
	    lcd_clear();
	    lcd_putsf("Failed");
		return 21;
	}
	return ans;
}

uint8_t getAFreeId(void)
{
	uint8_t i = 0;
	for (i = 0; i < 8; i++)
	{
		if (!isEnrolled(i))
			return i;
	}
	return i;
}
uint8_t enrollAFinger(uint8_t id)
{
	lcd_clear();   
    bips(4);
	lcd_putsf("Place finger ");
    lcd_gotoxy(0,1);
    lcd_putsf("(1/3)");
    delay_ms(1000);
	setCmosLED(1);
	while (!fingerPressed()) {if (cancel_PB is pressed) return 2;}
	delay_ms(1000);

	getCommand(EnrollStart, id);
	getCommand(Enroll1, 0);
	if (rxPacket[10] == Nack)
	{
	    lcd_clear();
	    lcd_putsf("Failed. ");
        lcd_gotoxy(0,1);
        lcd_putsf("Reseting FPS.");
		FPS_reset();
		return 0;
	}         
    delay_ms(1000);   
	lcd_clear();      
    
	lcd_putsf("Take of the ");
    lcd_gotoxy(0,1);
    lcd_putsf("finger.");
    soundOK();
	while (fingerPressed()){if (cancel_PB is pressed) return 2;}


	lcd_clear();
    bip();
	lcd_putsf("Place finger ");
    lcd_gotoxy(0,1);
    lcd_putsf("(2/3)");
    delay_ms(1000);
	while (!fingerPressed()) {if (cancel_PB is pressed) return 2;}
	delay_ms(1000);

	getCommand(Enroll2, 0);
	if (rxPacket[10] == Nack)
	{
	    lcd_clear();
	    lcd_putsf("Failed. Reseting ");
        lcd_gotoxy(0,1);
        lcd_putsf("FPS.");
		FPS_reset();
		return 0;
	}                          
    delay_ms(1000);
	lcd_clear(); 
	lcd_putsf("Take of the ");
    lcd_gotoxy(0,1);
    lcd_putsf("finger."); 
    soundOK();
	while (fingerPressed()){if (cancel_PB is pressed) return 2;}

	lcd_clear();
    bip();
	lcd_putsf("Place finger ");
    lcd_gotoxy(0,1);
    lcd_putsf("(3/3)");
    delay_ms(2000);
	while (!fingerPressed()) {if (cancel_PB is pressed) return 2;}
	delay_ms(1000);

	getCommand(Enroll3, 0);
	if (rxPacket[10] == Nack)
	{
	    lcd_clear();
	    lcd_putsf("Failed. Reseting ");
        lcd_gotoxy(0,1);
        lcd_putsf("FPS.");
		FPS_reset();
		return 0;
	}              
    delay_ms(1000); 
	lcd_clear(); 
	lcd_putsf("Take of the ");
    lcd_gotoxy(0,1);
    lcd_putsf("finger."); 
    soundOK();
	while (fingerPressed()){if (cancel_PB is pressed) return 2;}
	setCmosLED(0);
	lcd_clear();
	lcd_putsf("Enrollment ");
    delay_ms(500);
	return 1;
}
