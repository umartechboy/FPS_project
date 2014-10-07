#include <mega8.h>  
#include "projHeaders.h"  
#include "projDefines.h"
#include <alcd.h>
#include <delay.h>      
#include "customCharsCG.h"

char cpuHaltAllowed;
// Timer 0 overflow interrupt service routine
//used for charge and LCD contrast controller
int mV;
char powerMode;
unsigned char dontWDR;
eeprom unsigned int fpsCount; 

void normalizeContrast(void)
{
    if (mV > 4800)
        OCR2 = 0;
    else if (mV > 4600)
        OCR2 = 50;
    else if (mV > 4300)
        OCR2 = 100;
    else if (mV > 4100)
        OCR2 = 200;
    else
        OCR2 = 249;
}                  
unsigned int elapsed_us;
unsigned int elapsed_ms;
unsigned int elapsed_sec;
unsigned char junkFreeTimer; 
unsigned char autoSleepTimer;


void incTime (void)
{
    elapsed_us += 800;// precisely 192
    elapsed_ms += 8;
    if (elapsed_us >= 1000) { elapsed_ms ++;    elapsed_us %= 1000; }
    if (elapsed_ms >= 1000) 
    { 
        elapsed_sec ++;   
        elapsed_ms %= 1000;
        
        if (junkFreeTimer < 60)
            junkFreeTimer++;   
        if (autoSleepTimer < 255)
            autoSleepTimer++; 
    }
    if (elapsed_sec >= 1000)  { elapsed_sec = 0;    }         
    
} 
bit inPowerLoop = 0;
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{     
    incTime();      
    if(inPowerLoop) return;
    inPowerLoop = 1; 
    
    notLED = !((elapsed_sec % 3 == 0) && (elapsed_ms < 50));                      
    if (cpuHaltAllowed)
    {
        mV = a2v(read_adc(0)) * 1000;      
    }               
        
    
    if (powerMode is FORCE_CHARGE)
    {
        charging be ON;  
        normalizeContrast();
    }
    else if (mV > maxRated)    
    {
        powerMode = POWER_OVERFLOW; 
        // just try to reduce the power by overloading
        charging be ON;     
        OCR2 = 0;        
    }
    else if (mV > batteryFull)
    {             
        if (powerMode == 0) // system start
        {
            charging be ON; 
            OCR2 = 160;  
            powerMode be ON_CHARGING;
        }             
        else
        {    
            if (charging is ON)
            {
                //Battery full, disconnect
                charging be OFF;
                powerMode = ON_EXTERNAL;
                OCR2 = 0;
            }            
            else    // over charged Battery, can't do anything
                powerMode = ON_EXTERNAL;
        }
    }              
    else if (mV > onBattery)
    {
        charging be ON;
        //either discharging in high state or charging normally, lets c   
        if (mV > noExternal) //was not discharging
            powerMode = ON_CHARGING;
        else
            powerMode = ON_BATTERY;
        //let the contrast adjust on next cycle
                       
        //only if returns in same branch
        normalizeContrast();
    }                                         
    else if (mV > batteryLow)
    {
        if (charging is ON)
        {   
            //either too low battery or discharging already
            powerMode = ON_BATTERY;
        }   
        else
        {
            //power falure
            charging be ON;    
                
            if (powerMode != ON_BATTERY) //first time in branch
            {
                OCR2 = 200;
                //soundPowerFailure();
            }
            powerMode = ON_BATTERY;
        }  
        normalizeContrast();
    }                  
    else // battery too low.
    {
        if (powerMode is ON_BATTERY)   
        {
            charging be ON;   
            powerMode = BATTERY_LOW;  
            //soundBatteryLow();
        }     
        else
        //power failed
        {
            charging be ON; 
            powerMode = ON_BATTERY;
            OCR2 = 210;
            //soundPowerFailure(); 
        }
    }      
    if (!dontWDR)               
        #asm("WDR")
    inPowerLoop = 0;
}


void controller_init(void)
{      
    delay_ms(100);
    //OSCCAL = 0xFF; // double the internal oscillator speed  
    cpuHaltAllowed = 0;
    adc_init();
    lcd_init(16);
    uart_init();  
    
    init_fingerPrint_char();
    init_battery_char();
    init_switch_char();
    init_locked_char();
    init_unlocked_char();
    init_smilie_char();
    dontWDR = 0;
         
    DDRB.0 = 1;     //battery charge
    PORTB.0 = 0;    //battery charge
    
    DDRB.1 = 1; //buzzer
    PORTB.1 = 0;        
    
    DDRB.2 = 1;     //not LED
    DDRB.2 = 1;     //not LED
    
    DDRB.3 = 1;     //chargepump 
    
    DDRB.7 = 1;     //motor
    PORTB.7 = 0;
    
    
    DDRC.0 = 0;     //VCC/Vref
    PORTC.0 = 0;    
                    
    DDRD &= ~0xE0; // buttons  
    PORTD |= 0xE0; // buttons 
    
    DDRD.0 = 0; //uart
    DDRD.1 = 1;
    PORTD.0 = 0;
    PORTD.1 = 1;
    
    DDRD.2 = 1;  //FPS power
    PORTD.2 = 0; //FPS power  
    
    DDRD.3 = 0;  //IRD
    PORTD.3 = 0;
           
    //LCD contrast
    
    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: 1000.000 kHz
    // Mode: Fast PWM top=0xFF
    // OC2 output: Inverted PWM
    ASSR=0x00;
    TCCR2=0x7B;
    TCNT2=0x00;
    OCR2=0x7F;
    
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 31.250 kHz
    TCCR0=0x04;
    TCNT0=0x00;   
    TIMSK |= 0x01;
    
    lcd_clear(); 
    cpuHaltAllowed = 1;
    notLED be iOFF;
    powerMode = FORCE_CHARGE;
    
    // Watchdog Timer initialization
    // Watchdog Timer Prescaler: OSC/512k
    #pragma optsize-
    WDTCR=0x1F;
    WDTCR=0x0F;
    #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif            
    
    
    #asm("sei");    
    
    lcd_putsf("techCREATIONS");
    delay_ms(500);         
    failedCount = 0;
    powerMode = ON_CHARGING;     
    lcd_clear();
    delay_ms(10);
}