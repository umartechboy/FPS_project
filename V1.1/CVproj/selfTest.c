#include <mega8.h>
#include <delay.h>
#include <stdio.h>
#include "projHeaders.h"
#include "projDefines.h"
#include "FPS_GT511Cx.h"
#include "GPS_GT511x_comDefs.h"

void selfTest(void)
{            
    lcd_putsf("System Test");
    delay_ms(1000);            
    
    lcd_clear();    
    lcd_puts("System init OK!");
    
    delay_ms(1000);
    lcd_clear();    
    lcd_puts("Power Status: ");
    lcd_gotoxy(0,1);           
    
    lcd_putchar('0' + (mV / 1000) %10);
    lcd_putchar('.');
    lcd_putchar('0' + (mV / 100) %10);
    lcd_putsf("V, PM = ");          
    lcd_putchar('0' + powerMode);
    lcd_putsf(", C = ");          
    lcd_putchar('0' + (OCR2 / 100) %10);   
    lcd_putchar('0' + (OCR2 / 10) %10);   
    lcd_putchar('0' + (OCR2 / 1) %10);
    delay_ms(5000);
              
    lcd_clear();
    
    lcd_putsf("Notifications");
    
    for (i = 0; i < 5; i++)
    {                           
        invert(buzzer);
        invert(notLED);
        lcd_gotoxy(0,1);
        lcd_putchar(buzzer + '0'); 
        lcd_putchar(notLED + '0');  
        delay_ms(1000);
    } 
            
    buzzer be OFF;
    notLED be iOFF;
    
    lcd_clear();
    lcd_putsf("Buttons");  
    i = 0;
    while (i < 6)
    { 
        lcd_gotoxy(0,1);
        if (options_PB is pressed or cancel_PB is pressed or  select_PB is pressed )
        {   
            buzzer be ON;
            if (options_PB is pressed)
                lcd_putsf("OpsPB ");  
            if (select_PB is pressed)
                lcd_putsf("SelPB ");                                                        
            if (cancel_PB is pressed)
                lcd_putsf("CnlPB");
            while (options_PB is pressed or cancel_PB is pressed or  select_PB is pressed );
                           
            buzzer be OFF;
            lcd_clear();
            lcd_putsf("Buttons");          
            i++;         
        } 
    }
                       
    delay_ms(1000);   

    lcd_clear();
    lcd_putsf("Proximity Test, Place Hand: ");
    lcd_putchar(userHand + '0');
    i be userHand;
    while (i is userHand);
    lcd_clear();
    lcd_putsf("Inverted, Proximity OK: ");
    lcd_putchar(userHand + '0');
                       
    delay_ms(1000);   
     
    lcd_clear();
    lcd_putsf("FPS test");  
    delay_ms(1000);
    FPS_power be ON;
    FPS_open();
    setCmosLED(1);
    lcd_clear();          
    FPS_power be OFF;
    lcd_putsf("FPS OK!");
    delay_ms(1000);  
    FPS_power be ON;  
    FPS_open();
    setCmosLED(1);  
    lcd_clear();     
    lcd_putsf("ID = ");
    while (1)
    {    
        lcd_gotoxy(5,0);
        if (fingerPressed())
        {           
            beep(4000,200);
            lcd_putchar('0' + getFingerId());  
            setCmosLED(1);  
        }
        else
        {                   
            lcd_putchar('N');
        }  
        delay_ms(100);
    }
}
