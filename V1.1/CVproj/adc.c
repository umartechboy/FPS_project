#include <mega8.h>
#include <stdlib.h>
#include <delay.h>

unsigned int adc_data;
#define ADC_VREF_TYPE 0xC0

// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result
adc_data=ADCW;
}

// Read the AD conversion result
// with noise canceling
unsigned int read_adc_(unsigned char adc_input)
{
#asm("sei");
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
#asm
    in   r30,mcucr
    cbr  r30,__sm_mask
    sbr  r30,__se_bit | __sm_adc_noise_red
    out  mcucr,r30
    sleep
    cbr  r30,__se_bit
    out  mcucr,r30
#endasm
return adc_data;
}
unsigned int read_adc__(unsigned char adc_input)
{
    signed long num = 0;
    signed int temp = 0;
    char i = 0, rc = 0;  
    //return read_adc_(adc_input);
    for (i = 0; i < 10; i++)
    {
        num += read_adc_(adc_input); 
    } 
    num /= 10;
    //we have the initial
    while (rc < 3)
    {         
        temp = read_adc_(adc_input);
        if (temp > num + 5 || temp < num - 5)
            rc--;                             
        else rc++;
        if (rc <= 3)
        {
            num = ((num * 1) + (temp * 9)) / 10;
            rc = 0; 
        }
        num = (long)((num * 9) + (long)(temp * 1)) / 10; 
    }            
    return num;
    //return (read_adc_(adc_input) + read_adc_(adc_input) + read_adc_(adc_input)) / 3;
}
#define adcSamples 5
unsigned int read_adc(unsigned char adc_input)
{                  
    signed int samples[adcSamples];
    signed int avg = 0, ans = 0;
    signed int minV = 1024, maxV = 0;
    char i = 0, valCount = 0;
     
    for (i = 0; i < adcSamples; i++)
    {       
        //delay_ms(10);
        samples[i] = read_adc__(adc_input); 
    }              
                   
    for (i = 0; i < adcSamples; i++)
    {
        avg += samples[i]; 
    }                     
    avg /= adcSamples;
    for (i = 0; i < adcSamples; i++)
    {
        if (abs(samples[i] - avg) >= maxV)
            maxV = abs(samples[i] - avg);
        if (abs(samples[i] - avg) <= minV)
            minV = abs(samples[i] - avg);
    }                                    
    minV = (minV * 8 + maxV * 2) / 10;
    for (i = 0; i < adcSamples; i++)
    {
        if (abs(samples[i] - avg) <= minV)
        {
            ans += samples[i];
            valCount++;
        }              
    }
    return ans / valCount;
}

void adc_init(void)
{
    
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: Int., cap. on AREF
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x8B;
}