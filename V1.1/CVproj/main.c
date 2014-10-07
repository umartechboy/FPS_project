#include <mega8.h>
#include <delay.h>
#include <stdio.h>
#include "projHeaders.h"
#include "projDefines.h"
#include "FPS_GT511Cx.h"
#include "GPS_GT511x_comDefs.h"
#include "customCharsCG.h"

// Alphanumeric LCD functions
#include <alcd.h> 
// Declare your global variables here
eeprom char securityMethod;
eeprom char failedCount;  

//not tested
unsigned char askAuthentication(void)
{
    unsigned char i = 20;
    lcd_clear();
    lcd_putsf("Kindly Give your");
    lcd_gotoxy(0,1);
    lcd_putsf("authentication");
    delay_ms(1000);            
    i = getIdFinally(3, 0);
    return  ((i < 8) || (i == 10));
}
//not tested
unsigned char getIdFinally(unsigned char retries, unsigned char isForDoor)
{
    unsigned char i = 0, id = 10, j = 0;  
    bip();           
    if (!isForDoor)
    {
        lcd_clear();
        lcd_putsf("Place the finger");  
        //delay_ms(2000);
    }       
    
    FPS_power be ON;
    FPS_open();    
    for (i = 0; i < retries; i++)
    { 
        autoSleepTimer = 0;     
        if (failedCount >= 5 && junkFreeTimer < 60)
        {                 
            FPS_power be OFF;
            lcd_clear();  
            soundAlarm();
            return 11;
        }           
        else if (failedCount >= 5)
        {
            failedCount = 0;
        }
        
        setCmosLED(1);
        while (!fingerPressed())
        {
            if (cancel_PB is pressed || autoSleepTimer > 5) 
            {
                FPS_power be OFF; 
                return 9;
            }
        }
        setCmosLED(1);           
        //delay_ms(250);     
        for (j = 0; j < 10 ; j++)
        {
            id = getFingerId();
            if (id < 8)
            {
                j = 10;
            }          
            else
            {
                //delay_ms(100);
            }            
        } 
        if (id < 8)
        {  
            FPS_power be OFF;   
            failedCount = 0;
            
            if (!isForDoor)
            {                   
                if (!isForDoor)
                {
                    lcd_clear();          
                    lcd_putsf("Thank you: ");             
                
                    lcd_putchar('0' + id);
                }
                soundOK();
                delay_ms(1000);
            } 
            else
            bip(); 
            
            return id;
        }
        else
        {                  
            if (!isForDoor)
            {
                lcd_clear();          
                lcd_putsf("Access denied: "); 
            
                lcd_putchar('0' + id);
            } 
            failedCount ++;
            if (failedCount >=5)
                junkFreeTimer = 0;
        }
        soundError();
    }
    return 12;
}

//not tested
unsigned int registerID(void)
{
    char i = 0, j = 0, k = 0;
    lcd_clear();         
    FPS_power be ON;
    FPS_open();      
    i = getEnrolledCount(); 
    if (i >= 8)        
    {   
        FPS_power be OFF;
        lcd_putsf("Memory Full!");
        lcd_gotoxy(0,1);
        lcd_putsf("Delete an ID");
        delay_ms(2000);    
        return 10;
    }            
    i = getAFreeId();   
    j = getEnrolledCount();
    lcd_clear(); 
    lcd_putsf("ID available: "); 
    lcd_putchar('0' + i);   
    lcd_gotoxy(0,1);
    lcd_putsf("Remaining: ");
    lcd_putchar(8 - j + '0');
    delay_ms(2000);    
    i = enrollAFinger(i);
    while (cancel_PB is pressed);
    if (i == 2)
    {
        soundCancel();
    }   
    else
    {     
        k = getEnrolledCount(); 
        if (j == k) // failed
        {
            lcd_putsf("failed.");
            soundError();
        }   
        else
        {
            lcd_putsf("Succeeded");
        } 
        delay_ms(1000);
        lcd_clear();
        lcd_putsf("Saved at: "); 
        lcd_putchar(i + '0'); 
        lcd_gotoxy(0,1);
        lcd_putsf("Remaining: ");
        lcd_putchar(8 - k + '0');
        delay_ms(2000);    
        
    }        
    FPS_power be OFF;
    return i;
}
//not tested
void deleteIdByFinger(unsigned char all)
{
    char i = 0;
    lcd_clear();
    lcd_putsf("Place the");
    lcd_gotoxy(0,1);
    lcd_putsf("finger");
    i = getIdFinally(3, 0);
    if (i == 8)
    {                  
        soundError();
        lcd_putsf("Unknown ID");
        delay_ms(2000);
        return;
    }                  
    else if (i > 8)
    {                  
        soundError();
        lcd_putsf("ERROR");
        delay_ms(2000);
        return;
    }                                                                                           
    
    while(options_PB is pressed or cancel_PB is pressed or select_PB is pressed);
    
    lcd_clear();
    lcd_putsf("Confirm?");    
    soundQuestion();
    while(options_PB is unpressed and cancel_PB is unpressed and select_PB is unpressed);
    if (select_PB is pressed)
    {
        FPS_power be ON;
        FPS_open();
        
        if(all)
        {
            for(all = 0; all < 8; all++)
            {   
                if (all != i)
                    deleteID(all);
            }
        }
        else
            deleteID(i);
        FPS_power be OFF;
        lcd_clear();
        lcd_putsf("Deleted");
        soundSuccess();
        delay_ms(1000);
    }                  
    else
    {
        soundCancel();
    }
}
signed char menuOpt = -1, refreshMenu = 1;
void main(void)
{
    char i = 0, notSpace = 15, alreadyFresh = 0;; 
    //Init Block
    {
        controller_init();       
        
        if (resetByWDT == 1)
        {
            resetByWDT = 0;    
            goto resumeSession;
        }
        resetByWDT = 0;
    
    }
    
    resumeSession:
     
    failedCount = 0; 
    
    while(1)
    {   
        if (lockMotor is ON || FPS_power is ON)
        {
            controllerReset();
        }
        
        if (elapsed_sec % 10 == 0 && menuOpt == -1 && !alreadyFresh)
        {   
            refreshMenu = 1;
            alreadyFresh = 1;
        }     
        else
        {
            alreadyFresh = 0;
        }
        if (refreshMenu)
        {             
            notSpace = 15;
            refreshMenu = 0;       
            lcd_clear();
            switch (menuOpt)
            {              
                case -1: //no menu  
                    lcd_gotoxy(10,0);
                    if (mV < 4500)   
                    {                
                        lcd_gotoxy(notSpace, 0);
                        notSpace --;
                        lcd_putchar(2);
                    }
                    if (mV > 4300)   
                    {                
                        lcd_gotoxy(notSpace, 0);
                        notSpace --;
                        lcd_putchar(3);
                    } 
                    lcd_gotoxy(notSpace, 0); 
                    notSpace --;
                    if (securityMethod == 1)   
                    {                
                        lcd_putchar(6);
                    }
                    else if (securityMethod == 2)   
                    {                
                        lcd_putchar(5);
                    }
                    else
                    {                
                        lcd_putchar(4);
                    }         
                    
                    lcd_gotoxy(0,1);
                    lcd_putsf("> Menu");
                break;
                
                case 0:     
                    lcd_putsf("Security:");      
                    lcd_gotoxy(0,1);
                    if (securityMethod == 1)
                        lcd_putsf("\"Go Smart\"");
                    else if (securityMethod == 2) 
                        lcd_putsf("\"Open for all\"");
                    else 
                        lcd_putsf("\"Lock the Door\"");          
                break; 
                
                case 1:
                    lcd_putsf("Regeister an ID"); 
                break;
                
                case 2:
                    lcd_putsf("Delete an ID");
                break;    
                case 3:
                    lcd_putsf("Delete all IDs"); 
                break;    
                case 4:
                    switch(i % 4)
                    {
                        case 0:          
                            lcd_putsf("System Status"); 
                            lcd_gotoxy(0,1);
                            lcd_putsf("Press \"Select\"");
                        break;
                        
                        case 1:
                            lcd_putsf("IDs count: ");
                            FPS_power be ON;
                            FPS_open();
                            lcd_putchar(getEnrolledCount() + '0');  
                            FPS_power be OFF;
                        break;  
                        case 2:
                            lcd_putsf("Voltage: ");
                            lcd_putchar((mV / 1000) % 10 + '0'); 
                            lcd_putchar('.');
                            lcd_putchar((mV / 100) % 10 + '0'); 
                            lcd_putchar((mV / 10) % 10 + '0');  
                            lcd_putsf("V");
                            
                            refreshMenu = 1;
                            delay_ms(500); 
                        break; 
                        case 3:
                            lcd_putsf("FPS count:");      
                            lcd_gotoxy(0,1);  
                            lcd_putchar((fpsCount / 1000) % 10 + '0'); 
                            lcd_putchar((fpsCount / 100) % 10 + '0'); 
                            lcd_putchar((fpsCount / 10) % 10 + '0'); 
                            lcd_putchar((fpsCount / 1) % 10 + '0');  
                            
                        break;
                    } 
                break;                    
            }
        }  
        
        if (cancel_PB is pressed && options_PB is pressed)
            controllerReset(); 
        
        if (options_PB is pressed)
        {            
            soundTick();       
            while(options_PB is pressed);
            if (menuOpt == -1)
            {
                if (askAuthentication())
                {
                    soundOK();
                    menuOpt = 0; 
                    refreshMenu = 1;  
                }     
                else
                {
                    soundCancel(); 
                    refreshMenu = 1;  
                }
            }
            else
            {    
                refreshMenu = 1;          
                menuOpt++;      
                i = 0;             
                if (menuOpt == 5)
                    menuOpt = 0;
            }
        }  
        else if (select_PB is pressed)
        {           
            if (menuOpt >= 0)
            {
                refreshMenu = 1;
                if ((i % 4) == 3 && menuOpt == 4)
                {
                    delay_ms(500);
                    if (select_PB is pressed)
                        delay_ms(2000);
                    if (select_PB is pressed)  
                    {
                        fpsCount = 0;
                        i--;  
                        soundSuccess();  
                    }
                    else
                    {
                        soundOK();
                        while(select_PB is pressed);
                    }              
                }   
                else
                {
                    soundOK();
                    while(select_PB is pressed);
                }
            
                switch(menuOpt)
                {
                    case 0: // securityOpt
                        if (securityMethod == 0 || securityMethod == 1)
                            securityMethod++;                       
                        else
                            securityMethod = 0;
                    break;  
                         
                    case 1:
                        registerID();   
                    break;  
                    case 2:
                        deleteIdByFinger(0);
                    break; 
                    case 3:
                        deleteIdByFinger(1);
                    break;  
                    case 4:
                        i ++;
                        refreshMenu = 1;
                    break;                        
                } 
            }        
        }
        else if (cancel_PB is pressed && menuOpt >= 0)
        {      
            soundCancel();
            menuOpt = -1;
            refreshMenu = 1;    
        }    
               
        else // open the door
        {       
            if (userHand is present && menuOpt == -1)
            {        
                i = 0;                
                if (securityMethod == 1) // smart security
                {    
                    {                
                        lcd_gotoxy(notSpace, 0);
                        lcd_putchar(0);
                    }
                    if (getIdFinally(3, 1) < 8)
                    {
                        i = 1;  
                        bip();  
                    }              
                    else
                    {
                        i = 0;
                        delay_ms(2000);
                    }
                }
                else if (securityMethod == 2)// open always
                    i = 1;
                else
                {
                    soundError();
                    i = 0;
                }    
                if (i == 1)
                {   
                    lockMotorRoutine();
                    //open door
                }                
            }
        }
        #asm("WDR")
    }     
}