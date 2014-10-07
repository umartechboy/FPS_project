#ifndef __defs__
#define __defs__


//testing new trend
#define is ==
#define or ||
#define and &&
#define be = 

//bool defines
#define iON 0
#define iOFF 1  

//bool defines
#define absent 0
#define present 1 

#define ON 1
#define OFF 0

#define pressed 0
#define unpressed 1


#define invert(x) x be (~x) % 2

//hardware definitions   
#define notLED PORTB.2
#define options_PB PIND.7
#define select_PB PIND.6
#define cancel_PB PIND.5

#define charging PORTB.0
#define buzzer PORTB.1
#define lockMotor PORTB.7
#define IRD PIND.3     
#define FPS_power PORTD.2

//software defines
#define userHand getProximity()
extern unsigned char rx_counter; 
extern int mV;
extern char cpuHaltAllowed;
extern char powerMode;
extern eeprom char resetByWDT; 
extern eeprom char failedCount; 
extern unsigned char junkFreeTimer; 
extern unsigned char autoSleepTimer;

extern unsigned char dontWDR;
extern eeprom unsigned int fpsCount;  

extern unsigned int elapsed_sec;
          
#define ON_EXTERNAL  1
#define ON_CHARGING 2    
#define ON_BATTERY   3 
#define BATTERY_LOW  4
#define POWER_OVERFLOW 5 
#define BATTERY_OVERCHARGED 6
#define FORCE_CHARGE 7

//Voltage/Charge                   
#define maxRated    5500
#define batteryFull 4800
#define noExternal  4500    
#define onBattery   4100 
#define batteryLow  3800

#define v2a(x) ((float)((float)x + 1.372940824) / (float)0.007573529)
#define a2v(x) ((float)0.007573529*(float)x - (float)1.372940824)


#endif
