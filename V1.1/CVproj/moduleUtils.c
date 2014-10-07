#include <delay.h>
#include <mega8.h>
#include "projDefines.h"
#include "projHeaders.h"
#include <math.h>

unsigned char getProximity()
{
    char i = 0;
//    IRLED be iON; 
    delay_ms(1);
    i = IRD;    
//    IRLED be iOFF;
    return i;
}   
eeprom char resetByWDT;   
void controllerReset(void)
{
    resetByWDT = 0;
    TIMSK = 0;    
    while(1); 
}
void lockMotorRoutine(void)
{
    fpsCount ++;
    if (mV < 4000)
        soundBatteryLow();
    else
    {
        resetByWDT = 1;  
        TIMSK &= ~0x01;  
        OCR2 = 249;
        lockMotor be ON;
        delay_ms(1500);
        lockMotor be OFF;
        TIMSK |= 0x01;   
        #asm("WDR")
    }     
}
void soundBatteryLow(void)
{         
    beepSwipe(900, 300, 200);
    delay_ms(100);
    beepSwipe(3000, 300, 200);
    delay_ms(100);
    beepSwipe(3000, 300, 200);
}
void soundPowerFailure(void)
{         
    beepSwipe(900, 300, 200); 
    beep(300, 500);
}

void soundPowerOverFlow(void)
{         
    beepSwipe(400, 800, 500);
}

void soundOK(void)
{         
    beepSwipe(400 , 3000, 200);
}
void soundQuestion(void)
{        
    beepSwipe(400,400, 500);
}    
void soundAlarm(void)
{
    buzzer be ON;
    delay_ms(500);
    buzzer be OFF;
    delay_ms(300);  
}                    
void soundSuccess(void)
{
    beep(400,70);
    delay_ms(100);  
    beep(400,750);   
    beepSwipe(400, 3000, 250);
}
void soundError(void)
{               
    beepSwipe(3000 , 400, 200); 
    beepSwipe(3000 , 400, 200);
} 
void soundCancel(void)
{               
    beepSwipe(3000 , 400, 200);
} 

void bips(unsigned char count)
{
    while (count > 0)
    {
        buzzer be ON;
        delay_ms(75);
        buzzer be OFF;
        delay_ms(75);
        count --;
    }
}
void bip(void)
{
    buzzer be ON;
    delay_ms(100);
    buzzer be OFF;
}
void soundTick(void)
{         
    beep(300, 50);
    delay_ms(20); 
    beep(3000,50); 
}
void delay_ms_v(int ms)
{
    while(ms > 0)
    {
        delay_us(998);
        ms--;
    } 
    
} 
void beep(unsigned int f_khz, unsigned int period_ms)
{
    float tp = 0;                                   
    f_khz = min(f_khz, 12600);                      
    f_khz = max(f_khz, 260);
    tp = (float)1000000 / (float)f_khz; // tp in us   
    //now, if ICR = 8, tp = 1us, 16 for 2us
    TCCR1A=0x82;
    TCCR1B=0x19;
    ICR1 = max((int)tp * 8 , 600);
    OCR1A = 400;
    delay_ms_v(period_ms);     
    TCCR1A=0;
    TCCR1B=0;   
    ICR1 = 0;
    buzzer be OFF;
}  
void beepSwipe(unsigned int f_khz1, unsigned int f_khz2, unsigned int period_ms)
{
    signed char i = 0, steps = 50;    
    signed int inc = ((signed int)f_khz2 - (signed int)f_khz1) / steps;
    for (i = 0; i < steps; i++)  
        beep(f_khz1 +  (signed int)(i * inc), period_ms / steps);
}
