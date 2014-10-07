#include <stdint.h>
#include <stdbool.h>

uint8_t setCmosLED(uint8_t state_);
uint8_t FPS_open(void);
uint32_t FPS_getInt(uint32_t com);
uint8_t fingerPressed(void);
uint8_t isEnrolled(uint8_t id);
uint8_t enrollAFinger(uint8_t id);
uint8_t getFingerId(void);
uint8_t getAFreeId(void);
uint32_t getEnrolledCount(void);
uint8_t deleteID(uint8_t id);
uint8_t deleteAllIds(void);

